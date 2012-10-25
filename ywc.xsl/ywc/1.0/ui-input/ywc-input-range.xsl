<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">


<xsl:template name="ywcInputRange">
<xsl:param name="id" as="xs:string" select="''" />
<xsl:param name="class" as="xs:string" select="''" />
<xsl:param name="placeholder" as="xs:string" select="''" />
<xsl:param name="values" as="xs:string*" select="()" />
<xsl:param name="labels" as="xs:string*" select="()" />
<xsl:param name="selected" as="xs:string" select="''" />
<xsl:param name="menuWidth" as="xs:integer" select="0" />
<xsl:param name="menuStyle" as="xs:string" select="'popup'" /><!-- other option is 'dropdown' -->
<xsl:param name="onSelectJs" as="xs:string" select="''" />
<xsl:param name="onLoadJs" as="xs:string" select="''" />

<xsl:variable name="a" select='"&apos;"' />

<xsl:value-of select="concat(''
					,''					
					)" disable-output-escaping="yes" />
					
<xsl:value-of select="concat(''
						
					,'&lt;script type=&quot;text/javascript&quot;&gt;'
						,'$(function(){'
					
						,' });'
					,'&lt;/script&gt;'
					
					)" disable-output-escaping="yes" />
</xsl:template>

</xsl:stylesheet>