<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="user" as="xs:string" select="'guest'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../../ywc/1.0/inc/ywc-core.xsl" />
<xsl:include href="../../../ywc/1.0/inc/ywc-convert.xsl" />
<xsl:include href="../../../ywc/1.0/ui-asset/asset-list-controls.xsl" />
<xsl:include href="../../../ywc-intranet/1.0/inc/ywc-intranet-asset-list.xsl" />
<xsl:include href="../../../ywc-intranet/1.0/inc/ywc-intranet-asset-full.xsl" />
<xsl:include href="../../../ywc-intranet/1.0/inc/ywc-intranet-directory.xsl" />
<xsl:include href="../../../ywc-intranet/1.0/inc/ywc-intranet-retrieve-node.xsl" />
<xsl:include href="../../../ywc/1.0/ui-elements/ywc-header.xsl" />

<xsl:variable name="listName" as="xs:string" select="ywc:getParam('listName',$params)" />
<xsl:variable name="uiHeaderColor" as="xs:string" select="ywc:getParam('uiHeaderColor',$params)" />
<xsl:variable name="uiHeaderBgColor" as="xs:string" select="ywc:getParam('uiHeaderBgColor',$params)" />
<xsl:variable name="uiFallbackImage" as="xs:string" select="ywc:getParam('uiFallbackImage',$params)" />
<xsl:variable name="sortBy" as="xs:string" select="ywc:getParam('sortBy',$params)" />
<xsl:variable name="sortOrder" as="xs:string" select="ywc:getParam('sortOrder',$params)" />
<xsl:variable name="preUri" as="xs:string" select="ywc:getParam('preUri',$params)" />

<xsl:template match="/">
	
	
	<xsl:call-template name="ywcIntranetAssetListFull">
		<xsl:with-param name="preUri" select="$preUri"/>
		<xsl:with-param name="listName" select="$listName"/>
		<xsl:with-param name="listTarget" select="concat($listName,'-archive')"/>
		<xsl:with-param name="preTitle" select="'archive: '"/>
		<xsl:with-param name="groupSize" select="9"/>
		<xsl:with-param name="showButtons" select="0"/>
		<xsl:with-param name="uiHeaderColor" select="$uiHeaderColor"/>
		<xsl:with-param name="uiHeaderBgColor" select="$uiHeaderBgColor"/>
		<xsl:with-param name="uiFallbackImage" select="$uiFallbackImage"/>
		<xsl:with-param name="sortBy" select="$sortBy"/>
		<xsl:with-param name="sortByType" select="'number'"/>
		<xsl:with-param name="sortOrder" select="$sortOrder"/>
	</xsl:call-template>
	
	

	
</xsl:template>

</xsl:stylesheet>
