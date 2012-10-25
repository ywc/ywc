<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">


<xsl:variable name="uiHeaderColor" select="'fdbb30'" />
<xsl:variable name="uiHeaderBgColor" select="'919bc6'" />

<xsl:variable name="uiFallbackImage" select="'/buzz/lib/iter/1.0/img/logo/iter-logo-01.jpg'" />




<xsl:function name="ywc:rtrnUserEmail" as="xs:string">
	<xsl:param name="uid" as="xs:string" />
	
	<xsl:variable name="userNode" select="document('../../../../ywc.cache/xml/cache/ldap.xml')/users/user[lower-case(@uid) = lower-case(concat('',$uid))][position() = 1]" />
	
	<xsl:choose>
		<xsl:when test="count($userNode) &gt; 0"><xsl:value-of select="$userNode/@mail" /></xsl:when>
		<xsl:otherwise><xsl:value-of select="'-'" /></xsl:otherwise>
	</xsl:choose>
	
</xsl:function>


</xsl:stylesheet>