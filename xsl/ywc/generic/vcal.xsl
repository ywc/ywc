<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../ywc/inc/ywc-core.xsl" />
<xsl:include href="../../ywc/inc/ywc-convert.xsl" />

<xsl:template match="/">
	
	<xsl:variable name="vcal_offset_hr" select="0" />
	
	
	
	<!--<xsl:variable name="end_time">
	<xsl:choose>
		<xsl:when test="string-length(@ows_EventDuration) != 0">
				<xsl:variable name="start_hr" select="(number(substring-before(substring(@ows_ExpirationDate,12,5),':'))-$vcal_offset_hr)" />
				<xsl:variable name="start_mn" select="number(substring-after(substring(@ows_ExpirationDate,12,5),':'))" />
				<xsl:variable name="dur_hr" select="number(substring-before(@ows_EventDuration,':'))" />
				<xsl:variable name="dur_mn" select="number(substring-after(@ows_EventDuration,':'))" />
			<xsl:choose>
				<xsl:when test="($start_mn + $dur_mn) &gt; 59"><xsl:if test="string-length($start_hr+$dur_hr+1) = 1">0</xsl:if><xsl:value-of select="$start_hr + $dur_hr + 1" />:<xsl:if test="string-length($start_mn+$dur_mn-60) = 1">0</xsl:if><xsl:value-of select="$start_mn + $dur_mn - 60" /></xsl:when>
				<xsl:otherwise><xsl:if test="string-length($start_hr+$dur_hr) = 1">0</xsl:if><xsl:value-of select="$start_hr + $dur_hr" />:<xsl:if test="string-length($start_mn+$dur_mn) = 1">0</xsl:if><xsl:value-of select="$start_mn+$dur_mn" /></xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>	
	</xsl:variable>-->
	
	<xsl:variable name="title" select="normalize-space(ywc:getParam('title',$params))" />
	<xsl:variable name="location" select="normalize-space(ywc:getParam('location',$params))" />
	<xsl:variable name="body" select="normalize-space(ywc:getParam('body',$params))" />
	<xsl:variable name="priority" select="normalize-space(ywc:getParam('priority',$params))" />
	
	<xsl:variable name="dateStart" select="''" />
	<xsl:variable name="timeStart" select="''" />
	<xsl:variable name="dateEnd" select="''" />
	<xsl:variable name="timeEnd" select="''" />
	
		
<xsl:value-of select="concat(''
	,'&#xA;DTSTART:'
		,$dateStart
		,'T'
		,$timeStart
		,'00Z'
	,'&#xA;DTEND:'
		,$dateEnd
		,'T'
		,$timeEnd
		,'00Z'
	,'&#xA;SUMMARY:'
		,if (string-length($title) = 0) then 'Untitled Event' else $title
	,'&#xA;LOCATION:'
		,if (string-length($location) = 0) then '' else $location
	,'&#xA;DESCRIPTION:'
		,if (string-length($body) = 0) then '' else $body
	,'&#xA;PRIORITY:'
		,if (string-length($priority) = 0) then '3' else $priority
	)"/>
<!--<xsl:value-of select="concat(
	'BEGIN:VCALENDAR'
	,'&#xA;VERSION:2.0'
	,'&#xA;PRODID:-//hacksw/handcal//NONSGML v1.0//EN'
	,'&#xA;BEGIN:VEVENT'
	,'&#xA;DTSTART:',$dateStart,'T',$timeStart,'00Z'
	,'&#xA;DTEND:',$dateEnd,'T',$timeEnd,'00Z'
	,'&#xA;SUMMARY:',$title
	,'&#xA;LOCATION:',$location
	,'&#xA;DESCRIPTION:',$desc
	,'&#xA;PRIORITY:3'
	,'&#xA;END:VEVENT'
	,'&#xA;END:VCALENDAR'
	)"/>-->

</xsl:template>

</xsl:stylesheet>