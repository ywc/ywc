<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../ywc/inc/ywc-core.xsl" />

<xsl:template match="/">
	
	<xsl:variable name="httpUserAgent" select="ywc:getParam('HTTP-User-Agent',$params)" />
	
	<xsl:choose>
		<xsl:when test="contains($httpUserAgent,'iPhone') or contains($httpUserAgent,'iPod')">
			<meta name="viewport" content="width=660, initial-scale=0.48, minimum-scale=0.48, user-scalable=1" />
			<meta name="apple-mobile-web-app-capable" content="no" />
			<meta name="apple-mobile-web-app-status-bar-style" content="black" />
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>

</xsl:stylesheet>