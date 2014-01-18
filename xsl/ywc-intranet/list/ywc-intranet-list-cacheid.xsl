<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="user" as="xs:string" select="'guest'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../ywc/inc/ywc-core.xsl" />

<xsl:variable name="listName" select="ywc:getParam('listName',$params)"/>

<xsl:template match="/">
	
	<xsl:for-each select="ywc/cache[lower-case(@name)=lower-case($listName)]">
		<xsl:value-of select="concat(
					'&#xA;&lt;cache id=&quot;'
						,@cache_id
					,'&quot; /&gt;'
					)" disable-output-escaping="yes" />
	</xsl:for-each>
	
</xsl:template>

</xsl:stylesheet>
