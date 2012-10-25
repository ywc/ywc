<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:param name="uri" />
<xsl:param name="params" />
<xsl:output method="text" />

<xsl:template match="/ywc">
	<xsl:variable name="if-redirect" select="uri[((@type = 'redirect') or (@type = 'media')) and (@pattern = $uri)]" />
	<xsl:choose>
		<xsl:when test="count($if-redirect) &gt; 0">
			<xsl:for-each select="$if-redirect">
				<xsl:choose>
					<xsl:when test="@type = 'redirect'">
						<xsl:value-of select="@title" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="asset_id" select="@asset_id" />
						<xsl:value-of select="concat('ywc-media-',$asset_id)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="uri[((@pattern = $uri) or matches($uri,@pattern)) and (string-length(@required_params) &gt; 0)][position()=1]">
				<xsl:variable name="first-char" select="substring(@required_params,1,1)" />
				<xsl:variable name="check-for" select="concat(substring-before(@required_params,' else '),'=')" />
				<xsl:choose>
					<xsl:when test="($first-char!='!') and ((string-length($params) = 0) or not(contains($params,$check-for)))">
						<xsl:value-of select="substring-after(@required_params,' else ')" />
					</xsl:when>
					<xsl:when test="($first-char='!') and contains($params,substring($check-for,2))">
						<xsl:value-of select="substring-after(@required_params,' else ')" />
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>