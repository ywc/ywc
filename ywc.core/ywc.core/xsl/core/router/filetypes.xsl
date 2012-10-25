<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:param name="ext" />
<xsl:param name="return" />
<xsl:output method="text" />

<xsl:template match="/types">

	<xsl:variable name="ext_" select="lower-case($ext)" />

	<xsl:variable name="output" as="xs:string*">
		<xsl:for-each select="type[lower-case(@ext) = $ext_]">
			<xsl:sequence select="(@mime,@convert,@type)" />
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:choose>
		<xsl:when test="(string-length($output[1]) &gt; 0) and ($return = 'mime')"><xsl:value-of select="$output[1]" /></xsl:when>
		<xsl:when test="$return = 'mime'"><xsl:value-of select="'text/html'" /></xsl:when>
		<xsl:when test="(string-length($output[2]) &gt; 0) and ($return = 'convert')"><xsl:value-of select="$output[2]" /></xsl:when>
		<xsl:when test="$return = 'convert'"><xsl:value-of select="'imagemagick'" /></xsl:when>
		<xsl:when test="(string-length($output[3]) &gt; 0) and ($return = 'type')"><xsl:value-of select="$output[3]" /></xsl:when>
		<xsl:when test="$return = 'type'"><xsl:value-of select="'doc'" /></xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
		
</xsl:template>

</xsl:stylesheet>