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
<xsl:include href="../../../ywc-intranet/1.0/inc/ywc-intranet-asset-list.xsl" />
<xsl:include href="../../../ywc-intranet/1.0/inc/ywc-intranet-directory.xsl" />
<xsl:include href="../../../ywc-intranet/1.0/inc/ywc-intranet-retrieve-node.xsl" />

<xsl:template match="/">
	
	<xsl:call-template name="ywcIntranetAssetList">
		<xsl:with-param name="listName" select="ywc:getParam('listName',$params)"/>
		<xsl:with-param name="listTarget" select="ywc:getParam('listTarget',$params)"/>
		<xsl:with-param name="searchTerm" select="ywc:getParam('searchTerm',$params)"/>
		<xsl:with-param name="sortBy" select="ywc:getParam('sortBy',$params)"/>
		<xsl:with-param name="groupSize" select="xs:integer(ywc:getParam('groupSize',$params))"/>
		<xsl:with-param name="groupCurr" select="xs:integer(ywc:getParam('groupCurr',$params))"/>
		<xsl:with-param name="filterByDateTime" select="ywc:getParam('filterByDateTime',$params)"/>
		<xsl:with-param name="uiFallbackImage" select="ywc:getParam('uiFallbackImage',$params)"/>
	</xsl:call-template>
	
</xsl:template>

</xsl:stylesheet>
