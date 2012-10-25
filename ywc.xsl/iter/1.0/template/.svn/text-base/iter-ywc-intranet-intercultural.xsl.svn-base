<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" exclude-result-prefixes="xs xsl ywc dt rs z yweather geo">

<xsl:template name="ywcIntranetListIntercultural">
<xsl:param name="preUri" as="xs:string" select="'/'" />
<xsl:param name="listName" as="xs:string" select="'inter-events'" />

	<xsl:for-each select="document('../../../../ywc.cache/xml/data/cache.xml'
						)/ywc/cache[lower-case(@name)=lower-case($listName)]">
		
	<xsl:variable as="xs:string" name="ywcCacheId">
		<xsl:value-of select="@cache_id" />
	</xsl:variable>
	
	<xsl:variable name="srcXml" select="
		document(concat('../../../../ywc.cache/xml/'
			,if (contains($ywcCacheId,'..')) then 'core/blank'
			else concat('cache/',$ywcCacheId)
		,'.xml'))/rss/channel/item" />
		
	</xsl:for-each>

</xsl:template>

</xsl:stylesheet>
