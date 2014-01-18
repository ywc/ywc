<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">

<xsl:include href="../render/placeholder.xsl" />
<xsl:include href="../../inc/ywc-core.xsl" />
<xsl:include href="../javascript/javascript-init.xsl" />
	
<xsl:template name="render_template">
<xsl:param name="uri_params_lang_delims" as="xs:string*" select="('/','','en','','','')" />
<xsl:param name="ywc_delim_header" as="xs:string" select="''" />
<xsl:param name="template_id" as="xs:string" select="'aaaaaa'" />
<xsl:param name="parent_node_uri" select="." />
<xsl:param name="env" as="xs:string*" select="('env','app')" />
	
	<xsl:variable name="preUri" select="ywc:preUri($uri_params_lang_delims[1],$uri_params_lang_delims[3])" />
	<xsl:variable name="xml_template" select="document('../../../xml/data/template.xml') | document('../../../../../cache/xml/data/template.xml')" />
	<xsl:variable name="xml_placeholder" select="(document('../../../xml/data/placeholder.xml') | document('../../../../../cache/xml/data/placeholder.xml'))/ywc/placeholder[@template_id = $template_id]" />
	<xsl:for-each select="$xml_template/ywc/template[@template_id = $template_id]">
		
		<xsl:variable name="content_type">
			<xsl:choose>
				<xsl:when test="contains(@content_type,'*')">
					<xsl:value-of select="substring-before(@content_type,'*')" />
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="@content_type" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:value-of select="concat($content_type,$ywc_delim_header)" />
		
		<!-- render start of document -->		
		<xsl:call-template name="render_template_top">
			<xsl:with-param name="uri_params_lang_delims" select="$uri_params_lang_delims"/>
			<xsl:with-param name="template_row" select="."/>
			<xsl:with-param name="placeholders" select="$xml_placeholder[(@placement = 'head') or (@placement = 'bg')]"/>
			<xsl:with-param name="parent_node_uri" select="$parent_node_uri"/>
			<xsl:with-param name="preUri" select="$preUri"/>
			<xsl:with-param name="env" select="$env"/>
		</xsl:call-template>
		
		<!-- render template placeholders -->
		<xsl:call-template name="render_placeholder">
			<xsl:with-param name="uri_params_lang_delims" select="$uri_params_lang_delims"/>
			<xsl:with-param name="xml_placeholder" select="$xml_placeholder[@placement = 'body']"/>
			<xsl:with-param name="uri_id" select="$parent_node_uri/@uri_id"/>
			<xsl:with-param name="content_type" select="@content_type"/>
		</xsl:call-template>
		
		<!-- render end of document -->
		<xsl:call-template name="render_template_bottom">
			<xsl:with-param name="uri_params_lang_delims" select="$uri_params_lang_delims"/>
			<xsl:with-param name="template_row" select="."/>
			<xsl:with-param name="placeholders" select="$xml_placeholder[@placement = 'foot']"/>
			<xsl:with-param name="parent_node_uri" select="$parent_node_uri"/>
			<xsl:with-param name="preUri" select="$preUri"/>
		</xsl:call-template>		
		
	</xsl:for-each>
	
</xsl:template>


<xsl:template name="render_template_top">
<xsl:param name="uri_params_lang_delims" as="xs:string*" select="('/','','en','','','')" />
<xsl:param name="parent_node_uri" select="." />
<xsl:param name="template_row" select="." />
<xsl:param name="placeholders" select="." />
<xsl:param name="preUri" select="." />
<xsl:param name="env" as="xs:string*" select="('env','app')" />

<xsl:choose>
	<xsl:when test="$template_row[1]/@content_type = 'text/html'">
<xsl:value-of select="concat('&lt;!DOCTYPE html PUBLIC &quot;-//W3C//DTD XHTML 1.0 Transitional//EN&quot; &quot;http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd&quot;&gt;'
		,'&#xA;&lt;html xmlns=&quot;http://www.w3.org/1999/xhtml&quot; xml:lang=&quot;',$lang,'&quot; lang=&quot;',$lang,'&quot;&gt;'
		,'&#xA;&lt;head&gt;'
		,'&#xA;&lt;meta http-equiv=&quot;Content-Type&quot; content=&quot;text/html; charset=UTF-8&quot;/&gt;'
		,'&#xA;&lt;meta http-equiv=&quot;x-ua-compatible&quot; content=&quot;IE=edge&quot;/&gt;'
		)" disable-output-escaping="yes" />

<xsl:value-of select="concat('&#xA;&lt;title&gt;',$parent_node_uri/@title,'&lt;/title&gt;')" disable-output-escaping="yes" />

<!-- core js -->
<xsl:if test="$template_row[1]/@disable_javascript != 1">
	<xsl:call-template name="ywcJavascriptInitialize">
		<xsl:with-param name="preUri" select="$preUri"/>
		<xsl:with-param name="absUri" select="$uri_params_lang_delims[1]"/>
		<xsl:with-param name="env" select="$env"/>
	</xsl:call-template>
</xsl:if>

<xsl:if test="$template_row[1]/@disable_includes != 1">
	<xsl:value-of select="concat(
						string-join(
							ywc:aggregateIncludes( $preUri
								, document('../../../xml/data/include.xml') | document('../../../../../cache/xml/data/include.xml')
								, concat($template_row/@includes,';',$parent_node_uri/@includes)
								, 'top'
							)
						,'')
					,'&#xA;')" disable-output-escaping="yes" />
</xsl:if>

<xsl:call-template name="render_placeholder">
	<xsl:with-param name="uri_params_lang_delims" select="$uri_params_lang_delims"/>
	<xsl:with-param name="xml_placeholder" select="$placeholders[@placement = 'head']"/>
	<xsl:with-param name="uri_id" select="$parent_node_uri/@uri_id"/>
	<xsl:with-param name="content_type" select="$template_row/@content_type"/>
</xsl:call-template>

<xsl:if test="	($template_row[1]/@disable_javascript != 1)
			and (string-length(replace(concat($template_row/@onload,$parent_node_uri/@onload),' ','')) != 0)">
	<xsl:value-of select="concat('&#xA;&lt;script type=&quot;text/javascript&quot;'
						,' id=&quot;ywc-onload&quot;&gt;'
						,' $(function(){ ',$template_row/@onload,$parent_node_uri/@onload,' }); '
						,'&lt;/script&gt;')" disable-output-escaping="yes" />	
</xsl:if>

<xsl:value-of select="concat('&#xA;&lt;/head&gt;&#xA;&lt;body class=&quot;ywc-body&quot;&gt;'
	,'&#xA;&lt;div id=&quot;ywc-bgd&quot; class=&quot;ywc-bgd&quot;&gt;'
	,'')" disable-output-escaping="yes" />
	<xsl:call-template name="render_placeholder">
		<xsl:with-param name="uri_params_lang_delims" select="$uri_params_lang_delims"/>
		<xsl:with-param name="xml_placeholder" select="$placeholders[@placement = 'bg']"/>
		<xsl:with-param name="uri_id" select="$parent_node_uri/@uri_id"/>
		<xsl:with-param name="content_type" select="$template_row/@content_type"/>
	</xsl:call-template>
<xsl:value-of select="concat('&lt;/div&gt;'
	,'&#xA;&lt;div id=&quot;ywc-tpl-',$template_row[1]/@template_id,'&quot; class=&quot;ywc-tpl ',$template_row[1]/@default_classes,'&quot; style=&quot;width:',ywc:setWidth($template_row[1]/@width),';',ywc:setPadding($template_row[1]/@width),'&quot;&gt;&#xA;')" disable-output-escaping="yes" />

	</xsl:when>
	<xsl:when test="$template_row[1]/@content_type = 'text/html*ajax'">
		<xsl:call-template name="render_placeholder">
			<xsl:with-param name="uri_params_lang_delims" select="$uri_params_lang_delims"/>
			<xsl:with-param name="xml_placeholder" select="$placeholders"/>
			<xsl:with-param name="uri_id" select="$parent_node_uri/@uri_id"/>
			<xsl:with-param name="content_type" select="$template_row/@content_type"/>
		</xsl:call-template>	
	</xsl:when>	
	<xsl:when test="$template_row[1]/@content_type = 'text/xml'">
		<xsl:value-of select="'&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;&#xA;&lt;ywc&gt;'" disable-output-escaping="yes" />
	</xsl:when>
	<xsl:when test="$template_row[1]/@content_type = 'text/calendar'">
		<xsl:value-of select="'BEGIN:VCALENDAR&#xA;VERSION:1.0&#xA;BEGIN:VEVENT'" disable-output-escaping="yes" />
	</xsl:when>
</xsl:choose>

</xsl:template>



<xsl:template name="render_template_bottom">
<xsl:param name="uri_params_lang_delims" as="xs:string*" select="('/','','en','','','')" />
<xsl:param name="parent_node_uri" select="." />
<xsl:param name="template_row" select="." />
<xsl:param name="placeholders" select="." />
<xsl:param name="preUri" select="." />

<xsl:choose>
	<xsl:when test="$template_row[1]/@content_type = 'text/html'">
		<xsl:call-template name="render_placeholder">
			<xsl:with-param name="uri_params_lang_delims" select="$uri_params_lang_delims"/>
			<xsl:with-param name="xml_placeholder" select="$placeholders"/>
			<xsl:with-param name="uri_id" select="$parent_node_uri/@uri_id"/>
			<xsl:with-param name="content_type" select="$template_row/@content_type"/>
		</xsl:call-template>
		
		<xsl:if test="$template_row[1]/@disable_includes != 1">
			<xsl:value-of select="concat('&#xA;&lt;/div&gt;&#xA;'
								,string-join(ywc:aggregateIncludes( $preUri
										, document('../../../xml/data/include.xml') | document('../../../../../cache/xml/data/include.xml')
										, concat($template_row/@includes,';',$parent_node_uri/@includes)
										, 'bottom'
									),'')
									)" disable-output-escaping="yes" />
		</xsl:if>

<xsl:if test="$template_row[1]/@disable_javascript != 1">
	<script type="text/javascript">
		<xsl:value-of select="concat(' ',unparsed-text('../javascript/javascript-analytics.js'),' ')" disable-output-escaping="yes" />	
	</script>	
</xsl:if>								
		<xsl:value-of select="'&lt;/body&gt;&#xA;&lt;/html&gt;'" disable-output-escaping="yes" />
	</xsl:when>
	<xsl:when test="$template_row[1]/@content_type = 'text/html*ajax'">
		<xsl:call-template name="render_placeholder">
			<xsl:with-param name="uri_params_lang_delims" select="$uri_params_lang_delims"/>
			<xsl:with-param name="xml_placeholder" select="$placeholders"/>
			<xsl:with-param name="uri_id" select="$parent_node_uri/@uri_id"/>
			<xsl:with-param name="content_type" select="$template_row/@content_type"/>
		</xsl:call-template>
	</xsl:when>
	<xsl:when test="$template_row[1]/@content_type = 'text/xml'">
		<xsl:value-of select="'&#xA;&lt;/ywc&gt;'" disable-output-escaping="yes" />
	</xsl:when>
	<xsl:when test="$template_row[1]/@content_type = 'text/calendar'">
		<xsl:value-of select="'END:VEVENT&#xA;END:VCALENDAR'" disable-output-escaping="yes" />
	</xsl:when>
</xsl:choose>

</xsl:template>


<xsl:function name="ywc:setWidth" as="xs:string">
<xsl:param name="width" as="xs:integer" />
<xsl:choose>
	<xsl:when test="$width = 0"><xsl:value-of select="'99.0%'" /></xsl:when>
	<xsl:otherwise><xsl:value-of select="concat($width,'px')" /></xsl:otherwise>
</xsl:choose>
</xsl:function>

<xsl:function name="ywc:setPadding" as="xs:string">
<xsl:param name="width" as="xs:integer" />
<xsl:choose>
	<xsl:when test="$width = 0"><xsl:value-of select="'left:0.5%;'" /></xsl:when>
	<xsl:otherwise><xsl:value-of select="' '" /></xsl:otherwise>
</xsl:choose>
</xsl:function>


<xsl:function name="ywc:getAllInc" as="xs:string*">
	<xsl:param name="inc" />
	<xsl:param name="seq" as="xs:string*"/>
	<xsl:for-each select="$seq">
		<xsl:variable name="thisVal" select="." />
		<xsl:value-of select="$thisVal" />
		<xsl:variable name="dep" as="xs:string*" select="ywc:listToSequence($inc/ywc/include[@name = $thisVal][position() = 1]/@require)" />
		<xsl:for-each select="$dep">
			<xsl:variable name="innerVal" select="." />
			<xsl:if test="$innerVal != '-'">
			<xsl:value-of select="$innerVal" />
			<xsl:variable name="dep2" as="xs:string*" select="ywc:listToSequence($inc/ywc/include[@name = $innerVal][position() = 1]/@require)" />				
			<xsl:for-each select="$dep2">
				<xsl:variable name="innerVal2" select="." />
				<xsl:if test="$innerVal2 != '-'">
				<xsl:value-of select="$innerVal2" />
				<xsl:variable name="dep3" as="xs:string*" select="ywc:listToSequence($inc/ywc/include[@name = $innerVal2][position() = 1]/@require)" />
				<xsl:for-each select="$dep3">
					<xsl:variable name="innerVal3" select="." />
					<xsl:if test="$innerVal3 != '-'">
					<xsl:value-of select="$innerVal3" />
					<xsl:variable name="dep4" as="xs:string*" select="ywc:listToSequence($inc/ywc/include[@name = $innerVal3][position() = 1]/@require)" />
					<xsl:for-each select="$dep4">
						<xsl:variable name="innerVal4" select="." />
						<xsl:if test="$innerVal4 != '-'">
						<xsl:value-of select="$innerVal4" />
						</xsl:if>
					</xsl:for-each>
					</xsl:if>
				</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
	</xsl:for-each>
</xsl:function>




<xsl:function name="ywc:aggregateIncludes" as="xs:string*">
	<xsl:param name="preUri" as="xs:string"/>
	<xsl:param name="inc" />
	<xsl:param name="origStr" as="xs:string"/>
	<xsl:param name="position" as="xs:string"/>
	<xsl:variable name="fullSeq" as="xs:string*" select="distinct-values(ywc:getAllInc($inc,ywc:listToSequence($origStr)))" />
	<xsl:variable name="allIncs" select="$inc/ywc/include[contains(concat('_',string-join($fullSeq,'_'),'_'),concat('_',@name,'_'))]" />
	<!-- exception for overriding jquery-ui-lightness (default) when another theme has been specified -->
	
	<xsl:variable name="includes" select="$inc/ywc/include[@position = $position][contains(concat('_',string-join($fullSeq,'_'),'_'),concat('_',@name,'_'))]" />
	
	<xsl:variable name="initial-includes" select="$includes[string-length(@conditional) &lt;= 1][@async = 0]" />

	
	<xsl:if test="count($initial-includes[@content_type = 'text/javascript']) &gt; 0">
	<xsl:value-of select="'&#xA;&lt;script type=&quot;text/javascript&quot; class=&quot;script-ywc-aggregate&quot; id=&quot;'" />
	<xsl:for-each select="$initial-includes[@content_type = 'text/javascript']">
		<xsl:sort select="@ordering" data-type="number" />
		<xsl:value-of select="concat('script-',@name,';')" />
	</xsl:for-each>	
	<xsl:value-of select="concat('&quot; src=&quot;',$preUri,'inc/js?inc=')" />
	<xsl:for-each select="$initial-includes[@content_type = 'text/javascript']">
		<xsl:sort select="@ordering" data-type="number" />
		<xsl:value-of select="concat(@name,',',@include_id,',',@version,';')" />
	</xsl:for-each>
	<xsl:value-of select="'&quot;&gt;&lt;/script&gt;'" />
	</xsl:if>
	
	<xsl:for-each select="$initial-includes[@content_type = 'text/css']">
		<xsl:sort select="@ordering" data-type="number" />
		<xsl:value-of select="concat('&#xA;&lt;link rel=&quot;stylesheet&quot;'
									,' type=&quot;text/css&quot;'				
									,' id=&quot;link-',@name,'&quot;'
									,' href=&quot;',$preUri,'public/',@uri
										,'?ywc_v=',@version
										, if (@force_update = '1') then concat('&amp;update=',current-time()) else ''								
										,@params,'&quot;'
									,'&gt;&lt;/link&gt;')" />
	</xsl:for-each>
	
	<xsl:for-each select="$includes[contains(@conditional,'browser:ie')][@content_type = 'text/css']">
		<xsl:value-of select="concat('&#xA;&lt;!--[if ',upper-case(substring-after(@conditional,':')),']&gt;&#xA;&lt;link'
								,' rel=&quot;stylesheet&quot;'
								,' type=&quot;text/css&quot;'			
								,' id=&quot;link-',@name,'&quot;'
								,' href=&quot;',$preUri,'public/',@uri
									,'?ywc_v=',@version
									, if (@force_update = '1') then concat('&amp;update=',current-time()) else ''
									,@params,'&quot;'
							,'/&gt;&#xA;&lt;![endif]--&gt;')" disable-output-escaping="yes" />
	</xsl:for-each>		

	
</xsl:function>


</xsl:stylesheet>