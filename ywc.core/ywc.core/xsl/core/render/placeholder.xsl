<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">

<xsl:include href="../render/transform.xsl" />

<xsl:template name="render_placeholder">
<xsl:param name="uri_params_lang_delims" as="xs:string*" select="('/','','en','','','')" />
<xsl:param name="xml_placeholder" select="." />
<xsl:param name="uri_id" as="xs:string" select="'aaaaaa'" />
<xsl:param name="content_type" as="xs:string" select="'text/html'" />

<xsl:variable name="xml_transform" select="(document('../../../xml/data/transform.xml') | document('../../../../../ywc.cache/xml/data/transform.xml'))/ywc/transform[@uri_id = $uri_id]" />
	
	<xsl:for-each select="$xml_placeholder">
		<xsl:sort data-type="number" select="@top_left_y" />
		<xsl:sort data-type="number" select="@top_left_x" />
		<!--<xsl:sort data-type="number" select="@top_left_y" />-->
		
		<xsl:variable name="placeholder_id" select="@placeholder_id" />
		
		<xsl:choose>
			<xsl:when test="contains($content_type,'text/html')">
				<xsl:choose>
				<xsl:when test="contains($content_type,'*ajax')">
					<xsl:call-template name="render_transform">
						<xsl:with-param name="uri_params_lang_delims" select="$uri_params_lang_delims"/>
						<xsl:with-param name="xml_transform" select="$xml_transform[@placeholder_id = $placeholder_id]"/>
						<xsl:with-param name="fallback_xml_xsl" select="(@default_xml,@default_xsl)"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="@placement = 'body'">
				<div id="ywc-plh-{@placeholder_id}" class="ywc-plh {@default_classes}">
					<xsl:attribute name="style">
						<xsl:value-of select="concat('min-height:',(@bttm_right_y - @top_left_y),'px;')" />
						<xsl:value-of select="concat('width:',(0.99 * (@bttm_right_x - @top_left_x)),'%;')" />
						<xsl:if test="@top_left_x = 0">
							<xsl:choose>
								<xsl:when test="@bttm_right_x = 100">clear:both;</xsl:when>
								<xsl:otherwise>clear:left;</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:value-of select="ywc:plhVertOffset()" />
						<xsl:value-of select="@inline_styles" />
					</xsl:attribute>
						
					<xsl:call-template name="render_transform">
						<xsl:with-param name="uri_params_lang_delims" select="$uri_params_lang_delims"/>
						<xsl:with-param name="xml_transform" select="$xml_transform[@placeholder_id = $placeholder_id]"/>
						<xsl:with-param name="fallback_xml_xsl" select="(@default_xml,@default_xsl)"/>
					</xsl:call-template>
				</div>
				</xsl:when>
				<xsl:when test="@placement = 'foot'">
					<div id="ywc-plh-{@placeholder_id}" class="ywc-plh ywc-footer {@default_classes}">
						<xsl:attribute name="style">
							<xsl:value-of select="concat('min-height:',(@bttm_right_y - @top_left_y),'px;')" />
							<xsl:value-of select="concat('width:',(0.99 * (@bttm_right_x - @top_left_x)),'%;')" />
							<xsl:if test="@top_left_x = 0">
								<xsl:choose>
									<xsl:when test="@bttm_right_x = 100">clear:both;</xsl:when>
									<xsl:otherwise>clear:left;</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:value-of select="@inline_styles" />
						</xsl:attribute>
				<xsl:call-template name="render_transform">
					<xsl:with-param name="uri_params_lang_delims" select="$uri_params_lang_delims"/>
					<xsl:with-param name="xml_transform" select="$xml_transform[@placeholder_id = $placeholder_id]"/>
					<xsl:with-param name="fallback_xml_xsl" select="(@default_xml,@default_xsl)"/>
				</xsl:call-template>
				</div>
				</xsl:when>
				<xsl:otherwise>
				<xsl:call-template name="render_transform">
					<xsl:with-param name="uri_params_lang_delims" select="$uri_params_lang_delims"/>
					<xsl:with-param name="xml_transform" select="$xml_transform[@placeholder_id = $placeholder_id]"/>
					<xsl:with-param name="fallback_xml_xsl" select="(@default_xml,@default_xsl)"/>
				</xsl:call-template>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="render_transform">
					<xsl:with-param name="uri_params_lang_delims" select="$uri_params_lang_delims"/>
					<xsl:with-param name="xml_transform" select="$xml_transform[@placeholder_id = $placeholder_id]"/>
					<xsl:with-param name="fallback_xml_xsl" select="(@default_xml,@default_xsl)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:for-each>

</xsl:template>


<xsl:function name="ywc:plhVertOffset" as="xs:string">
	
<xsl:value-of select="'top:0px;'" />

</xsl:function>


</xsl:stylesheet>