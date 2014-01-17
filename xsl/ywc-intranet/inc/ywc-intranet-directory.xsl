<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">
	
	
	<!-- should add internal function for fetching node to be used in both functions here, to consolidate the code...-->
	
	<xsl:function name="ywc:directoryUserFullName" as="xs:string">
		<xsl:param name="uid" />
		<xsl:param name="fallbackValue" />
		
		<xsl:variable as="xs:string" name="ywcCacheId">
			<xsl:for-each select="document('../../../cache/xml/data/cache.xml')/ywc/cache[lower-case(@name)='directory']">
				<xsl:value-of select="@cache_id" />
			</xsl:for-each>
		</xsl:variable>

		<!-- fetches xml cache file, or blank if it suspects an invalid path -->
		<xsl:variable name="srcXml" select="
			document(concat('../../../cache/xml/'
				,if (contains($ywcCacheId,'..')) then 'core/blank' else concat('cache/',$ywcCacheId)
			,'.xml'))/users/user[(string-length(string-join((*|@*),'')) &gt; 0)]" />
		
		<xsl:variable name="userNodes" select="$srcXml[lower-case(@uid) = lower-case(concat('',$uid))][position() = 1]" />
		
		<xsl:choose>
			<xsl:when test="count($userNodes) = 0">
				<xsl:value-of select="$fallbackValue" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$userNodes">
					<xsl:value-of select="@cn" />
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xsl:function name="ywc:directoryUserEmail" as="xs:string">
		<xsl:param name="uid" />
		
		<xsl:variable as="xs:string" name="ywcCacheId">
			<xsl:for-each select="document('../../../cache/xml/data/cache.xml')/ywc/cache[lower-case(@name)='directory']">
				<xsl:value-of select="@cache_id" />
			</xsl:for-each>
		</xsl:variable>

		<!-- fetches xml cache file, or blank if it suspects an invalid path -->
		<xsl:variable name="srcXml" select="
			document(concat('../../../cache/xml/'
				,if (contains($ywcCacheId,'..')) then 'core/blank' else concat('cache/',$ywcCacheId)
			,'.xml'))/users/user[(string-length(string-join((*|@*),'')) &gt; 0)]" />
		
		<xsl:variable name="userNodes" select="$srcXml[lower-case(@uid) = lower-case(concat('',$uid))][position() = 1]" />
		
		<xsl:choose>
			<xsl:when test="count($userNodes) = 0">
				<xsl:variable name="userNodesAlt" select="$srcXml[lower-case(concat(@lastname,' ',@firstname)) = lower-case(concat('',$uid))][position() = 1]" />
				<xsl:choose>
					<xsl:when test="count($userNodesAlt) = 0">
						<xsl:value-of select="' '" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="$userNodesAlt">
							<xsl:value-of select="@mail" />
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>				
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$userNodes">
					<xsl:value-of select="@mail" />
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>	
	

</xsl:stylesheet>
