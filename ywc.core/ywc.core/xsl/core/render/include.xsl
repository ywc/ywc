<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:param name="uri" />
<xsl:param name="params" />
<xsl:output method="text" />

<xsl:variable name="type">
	<xsl:choose>
		<xsl:when test="contains($uri,'inc/js')">text/javascript</xsl:when>
		<xsl:when test="contains($uri,'inc/css')">text/css</xsl:when>
	</xsl:choose>
</xsl:variable>

<xsl:template match="/ywc">
	
	<!-- combine core include.xml with application specific include.xml -->
	<xsl:variable name="all-includes" select="(document('../../../xml/data/include.xml')/ywc | .)/include[@content_type = $type]" />
	
	<xsl:for-each select="tokenize(substring-after($params,'='),';')">
		<xsl:variable name="this-item" select="." />
		<xsl:for-each select="$all-includes[@name = substring-before($this-item,',')]
				[@include_id = substring-before(substring-after($this-item,','),',')]">
		
			<xsl:value-of select="concat('&#xA;&#xA;',unparsed-text(concat('../../../../../public/',@uri)))" />

		</xsl:for-each>
	
	</xsl:for-each>
	
</xsl:template>

</xsl:stylesheet>