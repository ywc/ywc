<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:output method="text" />

<xsl:template match="/datatypes">

	<xsl:for-each select="datatype">
		<xsl:value-of select="concat(@value,'&#10;')" />
	</xsl:for-each>
		
</xsl:template>

</xsl:stylesheet>