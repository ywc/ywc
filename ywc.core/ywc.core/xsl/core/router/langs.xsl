<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:param name="abbr" as="xs:string" select="'en'" />
<xsl:output method="text" />

<xsl:template match="/langs">

	<xsl:variable name="abbr_" select="lower-case($abbr)" />
	<xsl:variable name="list" select="lang[@abbr = $abbr_]" />
	
	<xsl:choose>
		<xsl:when test="count($list) &gt; 0">
			<xsl:value-of select="$list[1]/@abbr" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="'en'" />
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>

</xsl:stylesheet>