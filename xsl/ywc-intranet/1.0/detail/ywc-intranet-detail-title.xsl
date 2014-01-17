<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="domain" as="xs:string" select="''" />
<xsl:param name="protocol" as="xs:string" select="'http'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../ywc/1.0/inc/ywc-core.xsl" />
<xsl:include href="../../ywc/1.0/inc/ywc-convert.xsl" />

<!-- get list and post id from URL pattern -->
<xsl:variable name="listName" select="substring-before(substring-after(substring-after($uri,'ywc/intranet/'),'/'),'/')"/>
<xsl:variable name="srcIdVal" select="substring-after(substring-after(substring-after($uri,'ywc/intranet/'),'/'),'/')"/>

<xsl:template match="/">

	<xsl:variable as="xs:string" name="ywcListTitle">
		<xsl:for-each select="ywc/cache[lower-case(@name)=lower-case($listName)]">
			<xsl:value-of select="@title" />
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable as="xs:string" name="ywcCacheId">
		<xsl:for-each select="ywc/cache[lower-case(@name)=lower-case($listName)]">
			<xsl:value-of select="@cache_id" />
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="srcXml" select="
				document(concat('../../../cache/xml/'
				,if (contains($ywcCacheId,'..')) then 'core/blank'
				else concat('cache/',$ywcCacheId)
				,'.xml'))" />
	
	<xsl:for-each select="
			(	$srcXml/nodes/node
			|	$srcXml/rs:data/z:row
				)[
					(ywc:getNodeValue(.,'id') = $srcIdVal)
				or 	(ywc:getNodeValue(.,'nid') = $srcIdVal)
				]
			">
		<xsl:value-of select="concat($ywcListTitle,': ',ywc:getNodeValue(.,'title'))" />
	</xsl:for-each>
	
</xsl:template>

</xsl:stylesheet>
