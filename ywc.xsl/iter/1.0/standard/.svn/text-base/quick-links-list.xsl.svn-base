<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../../ywc/1.0/inc/ywc-core.xsl" />
<xsl:include href="../../../ywc/1.0/inc/ywc-convert.xsl" />
<xsl:include href="../../../ywc/1.0/ui-elements/ywc-header.xsl" />
<xsl:include href="../inc/iter-core.xsl" />

<xsl:variable name="preUri" select="ywc:preUri($uri,$lang)" />

<xsl:template match="/">
	
	<xsl:variable name="listName" select="'links'" />
	
	<xsl:variable as="xs:string" name="ywcCacheId">
		<xsl:for-each select="document('../../../../ywc.cache/xml/data/cache.xml'
							)/ywc/cache[lower-case(@name)=lower-case($listName)]">
			<xsl:value-of select="@cache_id" />
		</xsl:for-each>
	</xsl:variable>

	<!-- fetches xml cache file, or blank if it suspects an invalid path -->
	<xsl:variable name="srcXml" select="
		document(concat('../../../../ywc.cache/xml/'
			,if (contains($ywcCacheId,'..')) then 'core/blank'
			else concat('cache/',$ywcCacheId)
		,'.xml'))" />	

	<!-- aggregates xml input based on multiple possible xml structures (Drupal and Sharepoint, LDAP) -->
	<xsl:variable name="srcXmlAggr" select="
		(	$srcXml/nodes/node
		|	$srcXml/rs:data/z:row
		)[
			(string-length(string-join((*|@*),'')) &gt; 0)
		]" />

	<!-- check if main list or popup -->	
	<xsl:choose>
		<xsl:when test="string-length(ywc:getParam('id', $params)) = 0">
			<!-- in the main list -->
			<xsl:for-each select="ywc/cache[@name=$listName]">
				<xsl:call-template name="ywcHeader">
					<xsl:with-param name="preUri" select="$preUri"/>
					<xsl:with-param name="text" select="lower-case(@title)"/>
					<xsl:with-param name="width" select="120"/>
					<xsl:with-param name="fontsize" select="20"/>
					<xsl:with-param name="color" select="$uiHeaderColor"/>
					<xsl:with-param name="bg-color" select="$uiHeaderBgColor"/>
				</xsl:call-template>
			</xsl:for-each>
			
			<xsl:for-each select="$srcXmlAggr[@ows_Parent = 'Page']">
			<xsl:sort select="@ows_Rank" data-type="number" order="ascending" />
				
				<xsl:variable name="sectionTitle" select="normalize-space(lower-case(ywc:getNodeValue(.,'title')))" />
				
				<xsl:call-template name="ywcHeader">
					<xsl:with-param name="preUri" select="$preUri"/>
					<xsl:with-param name="text" select="$sectionTitle"/>
					<xsl:with-param name="width" select="120"/>
					<xsl:with-param name="fontsize" select="14"/>
					<xsl:with-param name="color" select="$uiHeaderColor"/>
					<xsl:with-param name="bg-color" select="$uiHeaderBgColor"/>
				</xsl:call-template>
				
				<xsl:for-each select="$srcXmlAggr[lower-case(normalize-space(@ows_Parent)) = $sectionTitle]">
				<xsl:sort select="@ows_Rank" data-type="number" order="ascending" />
					
					<xsl:variable name="title" select='lower-case(normalize-space(ywc:getNodeValue(.,"title")))' />
					<xsl:variable name="link" select='lower-case(normalize-space(ywc:getNodeValue(.,"link")))' />
					
					<div class="ywc-intranet-quick-links" onClick='{
						if (@ows_DataType = "Link") then concat("window.open(&apos;",ywc:escApos($link),"&apos;)")
						else if (@ows_DataType = "FormattedInfo") then concat("iterQuickLinksPopup(this,&apos;",@ows_DataType,"&apos;,&apos;",ywc:escApos($link),"&apos;,",@ows__Level,")")
						else concat("iterQuickLinksPopup(this,&apos;",@ows_DataType,"&apos;,&apos;",ywc:escApos($title),"&apos;,",@ows__Level,")")
						}'>
						<div class="on">
							<xsl:value-of select="concat(
								ywc:getNodeValue(.,'title')
								,if (@ows_DataType != 'Link') then ' &gt;&gt;' else ''
								)" disable-output-escaping="yes" />
						</div>
					</div>
					
				</xsl:for-each>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<!-- in the popup -->
			<xsl:variable name="sectionTitle" select="normalize-space(lower-case(ywc:getParam('id', $params)))" />
			
			<xsl:call-template name="ywcHeader">
				<xsl:with-param name="preUri" select="ywc:getParam('preUri', $params)"/>
				<xsl:with-param name="text" select="$sectionTitle"/>
				<xsl:with-param name="width" select="120"/>
				<xsl:with-param name="fontsize" select="14"/>
				<xsl:with-param name="color" select="$uiHeaderColor"/>
				<xsl:with-param name="bg-color" select="$uiHeaderBgColor"/>
			</xsl:call-template>
			
			<xsl:for-each select="$srcXmlAggr[normalize-space(lower-case(@ows_Parent)) = $sectionTitle]">
				<xsl:sort select="@ows_Rank" data-type="number" order="ascending" />
					
					<xsl:variable name="title" select='lower-case(normalize-space(ywc:getNodeValue(.,"title")))' />
					<xsl:variable name="link" select='lower-case(normalize-space(ywc:getNodeValue(.,"link")))' />
					
					
				<div class="ywc-intranet-quick-links" onClick='{
					if (@ows_DataType = "Link") then concat("window.open(&apos;",ywc:escApos(@ows_Link),"&apos;)")
					else if (@ows_DataType = "FormattedInfo") then concat("iterQuickLinksPopup(this,&apos;",@ows_DataType,"&apos;,&apos;",ywc:escApos($link),"&apos;,",@ows__Level,")")
					else concat("iterQuickLinksPopup(this,&apos;",@ows_DataType,"&apos;,&apos;",ywc:escApos($title),"&apos;,",substring-before(@ows_DisplayLevel,")"),")")
					}'>
					<div class="on">
						<xsl:value-of select="concat(
							ywc:getNodeValue(.,'title')
							,if (@ows_DataType != 'Link') then ' &gt;&gt;' else ''
							)" disable-output-escaping="yes" />
					</div>
				</div>
				
			</xsl:for-each>
			
		</xsl:otherwise>
	</xsl:choose>


</xsl:template>



<!-- 

<xsl:template name="quicklinks">
<xsl:param name="quicklinks_xml" select="."/>
<xsl:param name="quicklinks_id" select="."/>
<xsl:param name="wdth" select="."/>
<xsl:param name="search" select="."/>
	
	<xsl:variable name="apos" select='"&apos;"' />
	
	<xsl:variable name="quicklinks_title">
		<xsl:for-each select="$quicklinks_xml[@ows_ID = $quicklinks_id]"><xsl:value-of select="@ows_Title" /></xsl:for-each>
	</xsl:variable>
	
	<div class="quicklink_section">
	

	<xsl:call-template name="ywcHeader">
		<xsl:with-param name="text" select="lower-case($quicklinks_title)"/>
		<xsl:with-param name="width" select="120"/>
		<xsl:with-param name="fontsize" select="14"/>
		<xsl:with-param name="color" select="$uiHeaderColor"/>
		<xsl:with-param name="bg-color" select="$uiHeaderBgColor"/>
	</xsl:call-template>



	<xsl:variable name="quicklinks_popup_type">
		<xsl:for-each select="$quicklinks_xml[@ows_ID = $quicklinks_id]">
			<xsl:choose>
				<xsl:when test="@ows_Parent != 'Page'">popup_within_popup_quicklinks_<xsl:value-of select="$quicklinks_id" /></xsl:when>
				<xsl:otherwise>popup_box_container_univ_left</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:variable name="quicklinks_popup_position">
		<xsl:for-each select="$quicklinks_xml[@ows_ID = $quicklinks_id]">
			<xsl:choose>
				<xsl:when test="@ows_Parent != 'Page'">0</xsl:when>
				<xsl:otherwise><xsl:value-of select="(round(@ows_ItemRank) - 1) * 100" /></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>	
	
	<xsl:for-each select="$quicklinks_xml[(@ows_ID = $quicklinks_id) and (@ows_Parent != 'Page')]">
		<div class="popup_holder" id="popup_within_popup_quicklinks_{$quicklinks_id}"></div>
	</xsl:for-each>
	
	<xsl:for-each select="$quicklinks_xml[@ows_Parent = $quicklinks_title]">
	<xsl:sort select="@ows_Rank" data-type="number" order="ascending" />
		
		<div class="quicklink">
			<div class="quicklink_on">
			<xsl:attribute name="onClick">
				<xsl:choose>
					<xsl:when test="@ows_DataType = 'Popup'">req_popup_setup('html','quicklinks-<xsl:value-of select="@ows_ID" />','255','160','<xsl:value-of select="$quicklinks_popup_position" />','buzz','hard');</xsl:when>
					<xsl:when test="@ows_DataType = 'Widget'">req_popup_setup('html','widget-<xsl:value-of select="@ows_Link" />-','360','160','<xsl:value-of select="$quicklinks_popup_position" />','buzz','hard');</xsl:when>
					<xsl:when test="@ows_DataType = 'Link'">window.open('<xsl:value-of select="@ows_Link" />');</xsl:when>
					<xsl:when test="@ows_DataType = 'FormattedInfo'">req_popup_setup('popups','buzz-<xsl:value-of select="@ows_Link" />','580','200','<xsl:value-of select="$quicklinks_popup_position" />','buzz','hard');</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		
			<xsl:value-of select="@ows_Title" /><xsl:if test="@ows_DataType = 'Popup'"> &gt;&gt;</xsl:if>
			
			<xsl:choose>
				<xsl:when test="@ows_DataType = 'Popup'"><input type="hidden" id="popup_box_location_html_quicklinks-{@ows_ID}" value="{$quicklinks_popup_type}" /></xsl:when>
				<xsl:when test="@ows_DataType = 'Widget'"><input type="hidden" id="popup_box_location_html_widget-{@ows_Link}-" value="{$quicklinks_popup_type}" /></xsl:when>
				<xsl:when test="@ows_DataType = 'FormattedInfo'"><input type="hidden" id="popup_box_location_popups_buzz-{@ows_Link}" value="{$quicklinks_popup_type}" /></xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
			</div>
			
			<xsl:if test="(string-length($search) != 0) and ($search != 'x')
						and not(contains(	
							translate(concat(@ows_Title,' ',@ows_Description,' ',@ows_Link)
								,'ABCDEFGHIJKLMNOPQRSTUVWXYZ./- ','abcdefghijklmnopqrstuvwxyz./- ')
							,translate($search
								,'ABCDEFGHIJKLMNOPQRSTUVWXYZ./- ','abcdefghijklmnopqrstuvwxyz./- ')
				))">
				<div id="quicklink_cover_{@ows_ID}" class="quicklink_off"></div>
			</xsl:if>
			
		</div>
		
	</xsl:for-each>
	
	</div>

</xsl:template>
 -->

</xsl:stylesheet>
