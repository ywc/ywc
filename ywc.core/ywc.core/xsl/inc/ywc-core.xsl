<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:variable name="apos" select='"&apos;"' />

<xsl:function name="ywc:prePreUri" as="xs:string">
<xsl:param name="uri" as="xs:string" />
<xsl:variable name="seq" as="xs:string*">
	<xsl:for-each select="tokenize($uri,'/')[position() &gt; 2]">../</xsl:for-each>
</xsl:variable>
<xsl:value-of select="$seq" />
</xsl:function>

<xsl:function name="ywc:preUri" as="xs:string">
<xsl:param name="uri" as="xs:string" />
<xsl:param name="lang" as="xs:string" />
<xsl:variable name="add">
	<xsl:choose>
		<xsl:when test="$lang = 'en'"><xsl:value-of select="' '" /></xsl:when>
		<xsl:otherwise><xsl:value-of select="'../'" /></xsl:otherwise>
	</xsl:choose>
</xsl:variable>
<xsl:value-of select="replace(concat(ywc:prePreUri($uri),$add),' ','')" />
</xsl:function>

<xsl:function name="ywc:uriParams" as="xs:string*">
<xsl:param name="wh" as="xs:string" />
<xsl:param name="paramString" as="xs:string" />
<xsl:choose>
	<xsl:when test="contains($paramString,'&amp;')">
<xsl:for-each select="tokenize($paramString,'&amp;')">
	<xsl:choose>
		<xsl:when test="contains($wh,'key')"><xsl:sequence select="substring-before(.,'=')" /></xsl:when>
		<xsl:otherwise><xsl:sequence select="substring-after(.,'=')" /></xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
</xsl:when>
<xsl:when test="not(contains($paramString,'&amp;')) and contains($paramString,'=')">
	<xsl:choose>
		<xsl:when test="contains($wh,'key')"><xsl:sequence select="substring-before($paramString,'=')" /></xsl:when>
		<xsl:otherwise><xsl:sequence select="substring-after($paramString,'=')" /></xsl:otherwise>
	</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:function>

<xsl:function name="ywc:indByKey" as="xs:integer*">
<xsl:param name="seq" as="xs:string*" />
<xsl:param name="key" as="xs:string" />
<xsl:choose>
	<xsl:when test="count($seq) &gt; 0">
	<xsl:for-each select="$seq">
		<xsl:variable name="this" select="." />
		<xsl:if test="$this = $key">
			<xsl:value-of select="position()" />
		</xsl:if>
	</xsl:for-each>
	</xsl:when>
	<xsl:otherwise><xsl:value-of select="0" /></xsl:otherwise>
</xsl:choose>
</xsl:function>

<xsl:function name="ywc:getParam" as="xs:string">
<xsl:param name="key" as="xs:string" />
<xsl:param name="params" as="xs:string" />
<xsl:choose>
<xsl:when test="contains($params,concat($key,'='))">
	<xsl:variable name="paramKeys" as="xs:string*" select="ywc:uriParams('keys',$params)" />
	<xsl:variable name="paramVals" as="xs:string*" select="ywc:uriParams('vals',$params)" />
	<!--<xsl:variable name="indByKey" as="xs:integer" select="ywc:indByKey($paramKeys,$key)[1]" />-->
	<xsl:value-of select="normalize-space($paramVals[ywc:indByKey($paramKeys,$key)[1]])" />
	</xsl:when>
	<xsl:otherwise><xsl:value-of select="''" /></xsl:otherwise>
</xsl:choose>
</xsl:function>

<xsl:function name="ywc:cacheOrRequest">
<xsl:param name="uri" as="xs:string" />
<xsl:param name="cache_path" as="xs:string" />
<xsl:variable name="cache_filepath" select="concat(substring-before($cache_path,'---'),'/',ywc:checksum(ywc:mcHashUri($uri,$cache_path)),'.xml')" />
<!-- disabled to avoid conflicts with memcached 'ywcmc' caching.
		Reading from disk made it impossible for memcached to be aware
		of the transform as needing to be invalidated  -->
<!--<xsl:variable name="check_cache" select="document($cache_filepath)" />
<xsl:choose>
	<xsl:when test="count($check_cache/*) &gt; 0">
		<xsl:copy-of select="$check_cache" />
	</xsl:when>
	<xsl:otherwise>-->
		<xsl:copy-of select="document(ywc:mcHashUri($uri,$cache_path))" />
<!--	</xsl:otherwise>
</xsl:choose>-->
</xsl:function>

<xsl:template name="writeToCache">
<xsl:param name="doc" select="." />
<xsl:param name="uri" as="xs:string" />
<xsl:param name="cache_path" as="xs:string" />
<xsl:variable name="cache_filepath" select="concat(substring-before($cache_path,'---'),'/',ywc:checksum(ywc:mcHashUri($uri,$cache_path)),'.xml')" />
	<xsl:if test="count(document($cache_filepath)/*) = 0">
		<!-- disabled to avoid conflicts with memcached 'ywcmc' caching.
			Reading from disk made it impossible for memcached to be aware
			of the transform as needing to be invalidated  -->
		<!--<xsl:result-document method="xml" include-content-type="yes" href="{$cache_filepath}"  omit-xml-declaration="no">
			<xsl:value-of select="'&#xA;'" />
			<xsl:copy-of select="$doc" />
		</xsl:result-document>-->
	</xsl:if>
</xsl:template>

<xsl:function name="ywc:mcHashUri" as="xs:string">
<xsl:param name="uri" as="xs:string"/>
<xsl:param name="cache_path" as="xs:string"/>
	<xsl:choose>
	<xsl:when test="contains($uri,'?')">
		<xsl:value-of select="concat($uri,'&amp;ywcmc=',substring-after($cache_path,'---'))" />
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="concat($uri,'?ywcmc=',substring-after($cache_path,'---'))" />
	</xsl:otherwise>
	</xsl:choose>
</xsl:function>

<xsl:function name="ywc:checksum" as="xs:integer">
	<xsl:param name="str" as="xs:string"/>
	<xsl:variable name="codepoints" select="string-to-codepoints($str)"/>
	<xsl:value-of select="ywc:fletcher16($codepoints, count($codepoints), 1, 0, 0)"/>
</xsl:function>

<xsl:function name="ywc:fletcher16">
	<xsl:param name="str" as="xs:integer*"/>
	<xsl:param name="len" as="xs:integer" />
	<xsl:param name="index" as="xs:integer" />
	<xsl:param name="sum1" as="xs:integer" />
	<xsl:param name="sum2" as="xs:integer"/>
	<xsl:choose>
		<xsl:when test="$index ge $len">
			<xsl:sequence select="$sum2 * 256 + $sum1"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="newSum1" as="xs:integer" select="($sum1 + $str[$index]) mod 255"/>
			<xsl:sequence select="ywc:fletcher16($str, $len, $index + 1, $newSum1, ($sum2 + $newSum1) mod 255)" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:function>

<xsl:function name="ywc:listToSequence" as="xs:string*">
	<xsl:param name="str" as="xs:string"/>
	<xsl:for-each select="tokenize($str,';')">
		<xsl:variable name="this" as="xs:string" select="replace(.,' ','')" />
		<xsl:if test="string-length($this) != 0">
			<xsl:value-of select="$this" />
		</xsl:if>
	</xsl:for-each>
</xsl:function>


<xsl:function name="ywc:limitLength" as="xs:string">
	<xsl:param name="str" as="xs:string"/>
	<xsl:param name="lim" as="xs:integer"/>
	<xsl:choose>
		<xsl:when test="string-length($str) &gt; $lim"><xsl:value-of select="concat(substring($str,1,$lim - 2),'...')" /></xsl:when>
		<xsl:otherwise><xsl:value-of select="$str" /></xsl:otherwise>
	</xsl:choose>
</xsl:function>


<xsl:function name="ywc:unixTime" as="xs:double">
<xsl:value-of select="round(1000 * (current-dateTime() - xs:dateTime('1970-01-01T00:00:00Z')) div xs:dayTimeDuration('PT1S'))" />
</xsl:function>

<xsl:function name="ywc:diffTime" as="xs:string">
<xsl:param name="then" as="xs:double" />
	
<xsl:variable name="diff">
	<xsl:choose>
		<xsl:when test="($then &lt; 10000000000)"><xsl:value-of select="(ywc:unixTime() - ($then * 1000))" /></xsl:when>
		<xsl:otherwise><xsl:value-of select="(ywc:unixTime() - $then)" /></xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="secs" select="($diff div 1000)" />
<xsl:variable name="mins" select="($secs div 60)" />
<xsl:variable name="hours" select="($mins div 60)" />
<xsl:variable name="days" select="($hours div 24)" />
<xsl:variable name="weeks" select="($days div 7)" />
<xsl:variable name="months" select="($days div 30)" />

<xsl:choose>
	<xsl:when test="$months &gt; 1"><xsl:value-of select="concat(round($months),' month(s)')" /></xsl:when>
	<xsl:when test="$weeks &gt; 1"><xsl:value-of select="concat(round($weeks),' week(s)')" /></xsl:when>
	<xsl:when test="$days &gt; 1"><xsl:value-of select="concat(round($days),' day(s)')" /></xsl:when>
	<xsl:when test="$hours &gt; 1"><xsl:value-of select="concat(round($hours),' hour(s)')" /></xsl:when>
	<xsl:otherwise><xsl:value-of select="concat(round($mins),' minute(s)')" /></xsl:otherwise>
</xsl:choose>

</xsl:function>



<xsl:function name="ywc:returnYwcCache">
<xsl:param name="name" as="xs:string" />
	
	<xsl:variable name="cache-path" select="document('../../../../ywc.cache/xml/data/cache.xml')/ywc/cache[@name = $name]" />
	<xsl:for-each select="$cache-path">
		<xsl:copy-of select="document(concat('../../../../ywc.cache/xml/cache/',@cache_id,'.xml'))" />
	</xsl:for-each>

</xsl:function>



</xsl:stylesheet>