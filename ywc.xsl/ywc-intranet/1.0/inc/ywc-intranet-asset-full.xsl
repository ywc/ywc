<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">
	
<xsl:template name="ywcIntranetAssetListFull">
<xsl:param name="preUri" as="xs:string" select="'/'" />
<xsl:param name="listName" as="xs:string" select="''" /><!-- system name of list (can be matched to a ywcCacheId) -->
<xsl:param name="listTarget" as="xs:string" select="''" /><!--asset list target (where to draw the list) -->
<xsl:param name="preTitle" as="xs:string" select="''" />
<xsl:param name="groupSize" as="xs:integer" select="6" />
<xsl:param name="showButtonAdd" as="xs:integer" select="1" />
<xsl:param name="showButtonSubscribe" as="xs:integer" select="1" />
<xsl:param name="showButtons" as="xs:integer" select="1" />
<xsl:param name="showSearch" as="xs:integer" select="1" />
<xsl:param name="searchAutoFocus" as="xs:integer" select="0" />
<xsl:param name="showPaging" as="xs:integer" select="1" />
<xsl:param name="uiHeaderColor" as="xs:string" select="'bbbbbb'" />
<xsl:param name="uiHeaderBgColor" as="xs:string" select="'444444'" />
<xsl:param name="uiHeaderFont" as="xs:string" select="'frutiger75'" />
<xsl:param name="filterByDateTime" as="xs:string" select="''" />
<xsl:param name="sortBy" as="xs:string" select="''" />
<xsl:param name="sortOrder" as="xs:string" select="'descending'" />
<xsl:param name="uiFallbackImage" as="xs:string" select="''" />
	
	<xsl:variable name="listTarget_" select="if (string-length($listTarget) = 0) then $listName else $listTarget" />
	
	<xsl:for-each select="ywc/cache[@name=$listName]">
		
		<xsl:call-template name="ywcHeader">
			<xsl:with-param name="preUri" select="$preUri"/>
			<xsl:with-param name="text" select="lower-case(concat($preTitle,@title))"/>
			<xsl:with-param name="width" select="120"/>
			<xsl:with-param name="fontsize" select="20"/>
			<xsl:with-param name="color" select="$uiHeaderColor"/>
			<xsl:with-param name="bg-color" select="$uiHeaderBgColor"/>
			<xsl:with-param name="font" select="$uiHeaderFont"/>
		</xsl:call-template>
		
		<xsl:if test="$showSearch = 1">
			<xsl:call-template name="ywcAssetListControls">
				<xsl:with-param name="preUri" select="$preUri"/>
				<xsl:with-param name="listName" select="$listTarget_"/>
				<xsl:with-param name="listHumanName" select="lower-case(concat($preTitle,@title))"/>
				<xsl:with-param name="showBttnAdd" select="if ($showButtonAdd = 1) then $showButtons else $showButtonAdd"/>
				<xsl:with-param name="showBttnSubscribe" select="if ($showButtonSubscribe = 1) then $showButtons else $showButtonSubscribe"/>
				<xsl:with-param name="showBttnArchive" select="$showButtons"/>
				<xsl:with-param name="searchAutoFocus" select="$searchAutoFocus"/>
				<xsl:with-param name="filterByDateTime" select="$filterByDateTime"/>
			</xsl:call-template>
		</xsl:if>
		
	</xsl:for-each>
		
	<div class="ywc-container-vertical-list ywc-container-vertical-list-{$listTarget_}">
		<span style="display:none;"><xsl:value-of select="$listTarget_" /></span>
	</div>
	
	<script type="text/javascript">
		
		<xsl:call-template name="ywcIntranetAssetList">
			<xsl:with-param name="listName" select="$listName"/>
			<xsl:with-param name="listTarget" select="$listTarget_"/>
			<xsl:with-param name="groupSize" select="$groupSize"/>
			<xsl:with-param name="filterByDateTime" select="$filterByDateTime"/>
			<xsl:with-param name="sortBy" select="$sortBy"/>
			<xsl:with-param name="sortOrder" select="$sortOrder"/>
			<xsl:with-param name="uiFallbackImage" select="$uiFallbackImage"/>
		</xsl:call-template>
	
		<xsl:value-of select='concat("$(function(){"
			,"YWC.list.meta[&apos;",$listTarget_,"&apos;].groupCurr=0;"
			, if ($showPaging = 0) then concat("YWC.list.meta[&apos;",$listTarget_,"&apos;].showPaging=false;") else ""
			,"YWC.f.assetDrawList(&apos;",$listTarget_,"&apos;,false,false);"
		,"});")' disable-output-escaping="yes" />
	
	</script>
	
</xsl:template>


</xsl:stylesheet>
