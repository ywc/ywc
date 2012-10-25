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
<xsl:include href="../inc/iter-core.xsl" />

<xsl:variable name="preUri" select="ywc:preUri($uri,$lang)" />

<xsl:template match="/">
	
	
	<xsl:call-template name="ywcIntranetAssetListFull">
		<xsl:with-param name="preUri" select="$preUri"/>
		<xsl:with-param name="listName" select="'marketplace'"/>
		<xsl:with-param name="groupSize" select="10"/>
		<xsl:with-param name="uiHeaderColor" select="$uiHeaderColor"/>
		<xsl:with-param name="uiHeaderBgColor" select="$uiHeaderBgColor"/>
		<xsl:with-param name="uiFallbackImage" select="$uiFallbackImage"/>
		<xsl:with-param name="filterByDateTime" select="'ExpirationDate'"/>
	</xsl:call-template>


</xsl:template>

</xsl:stylesheet>
