<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">

<xsl:template name="ywcIntranetFooterNav">
<xsl:param name="font-size" as="xs:integer" select="18" />
<xsl:param name="labels" as="xs:string*" select="()" />
<xsl:param name="links" as="xs:string*" select="()" />
	
	<div class="ywc-intranet-nav-footer" style="font-size:{$font-size}px;">
		<xsl:for-each select="$labels">
		<xsl:variable name="pos" select="position()" />
		
		<xsl:if test="$labels[$pos] != ''">
			<xsl:choose>
				<xsl:when test="$links[$pos] != ''">
						<a class="ywc-footer-nav-item" href="{$links[$pos]}">
							<xsl:value-of select="." />
						</a>
				</xsl:when>
				<xsl:otherwise>
					<a class="ywc-footer-nav-item">
						<xsl:value-of select="." />
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		</xsl:for-each>
	</div>

</xsl:template>
</xsl:stylesheet>