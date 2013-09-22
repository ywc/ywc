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
<xsl:include href="../../../ywc-intranet/1.0/news/ywc-intranet-news-full.xsl" />
<xsl:include href="../../../ywc-intranet/1.0/inc/ywc-intranet-retrieve-node.xsl" />
<xsl:include href="../../../ywc/1.0/ui-elements/ywc-header.xsl" />
<xsl:include href="../../../ywc/1.0/ui-input/ywc-input-button.xsl" />

<xsl:variable name="preUri" as="xs:string" select="ywc:getParam('preUri',$params)" />
<xsl:variable name="listName" as="xs:string" select="ywc:getParam('listName',$params)" />
<xsl:variable name="articleId" as="xs:string" select="ywc:getParam('articleId',$params)" />
<xsl:variable name="uiHeaderColor" as="xs:string" select="ywc:getParam('uiHeaderColor',$params)" />
<xsl:variable name="uiHeaderBgColor" as="xs:string" select="ywc:getParam('uiHeaderBgColor',$params)" />
<xsl:variable name="uiFallbackImage" as="xs:string" select="ywc:getParam('uiFallbackImage',$params)" />

<xsl:template match="/">
	
	<xsl:call-template name="ywcIntranetNewsFull">
		<xsl:with-param name="preUri" select="$preUri"/>
		<xsl:with-param name="listName" select="$listName"/>
		<xsl:with-param name="articleId" select="$articleId"/>
		<xsl:with-param name="uiHeaderColor" select="$uiHeaderColor"/>
		<xsl:with-param name="uiHeaderBgColor" select="$uiHeaderBgColor"/>
		<xsl:with-param name="uiFallbackImage" select="$uiFallbackImage"/>
	</xsl:call-template>


</xsl:template>

</xsl:stylesheet>
