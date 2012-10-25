<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" exclude-result-prefixes="xs xsl ywc yweather geo">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../../ywc/1.0/inc/ywc-core.xsl" />
<xsl:include href="../../../ywc/1.0/ui-elements/ywc-header.xsl" />
<xsl:include href="../../../ywc-intranet/1.0/widget/ywc-intranet-weather.xsl" />
<xsl:include href="../inc/iter-core.xsl" />

<xsl:variable name="preUri" select="ywc:preUri($uri,$lang)" />

<xsl:template match="/">
	
		<xsl:variable name="flagLocation" select="'//static-1.iter.org/buzz/img/flag/'" />
	
		<xsl:call-template name="ywcHeader">
			<xsl:with-param name="preUri" select="$preUri"/>
			<xsl:with-param name="text" select="'iter worldwide'"/>
			<xsl:with-param name="width" select="120"/>
			<xsl:with-param name="fontsize" select="20"/>
			<xsl:with-param name="font" select="'frutiger'"/>
			<xsl:with-param name="color" select="$uiHeaderColor"/>
			<xsl:with-param name="bg-color" select="$uiHeaderBgColor"/>
		</xsl:call-template>
		

		<xsl:call-template name="ywcIntranetWidgetWeather">
			<xsl:with-param name="preUri" select="$preUri"/>
			<xsl:with-param name="title" select="'iter hq'"/>
			<xsl:with-param name="listName" select="'weather-io'"/>
			<xsl:with-param name="logoImage" select="concat($flagLocation,'flag-io-30.png')"/>
		</xsl:call-template>

		<xsl:call-template name="ywcIntranetWidgetWeather">
			<xsl:with-param name="preUri" select="$preUri"/>
			<xsl:with-param name="title" select="'china'"/>
			<xsl:with-param name="listName" select="'weather-cn'"/>
			<xsl:with-param name="logoImage" select="concat($flagLocation,'flag-cn-30.png')"/>
			<xsl:with-param name="collapsed" select="1"/>
		</xsl:call-template>

		<xsl:call-template name="ywcIntranetWidgetWeather">
			<xsl:with-param name="preUri" select="$preUri"/>
			<xsl:with-param name="title" select="'eu'"/>
			<xsl:with-param name="listName" select="'weather-eu'"/>
			<xsl:with-param name="logoImage" select="concat($flagLocation,'flag-eu-30.png')"/>
			<xsl:with-param name="collapsed" select="1"/>
		</xsl:call-template>

		<xsl:call-template name="ywcIntranetWidgetWeather">
			<xsl:with-param name="preUri" select="$preUri"/>
			<xsl:with-param name="title" select="'india'"/>
			<xsl:with-param name="listName" select="'weather-in'"/>
			<xsl:with-param name="logoImage" select="concat($flagLocation,'flag-in-30.png')"/>
			<xsl:with-param name="collapsed" select="1"/>
		</xsl:call-template>

		<xsl:call-template name="ywcIntranetWidgetWeather">
			<xsl:with-param name="preUri" select="$preUri"/>
			<xsl:with-param name="title" select="'japan'"/>
			<xsl:with-param name="listName" select="'weather-jp'"/>
			<xsl:with-param name="logoImage" select="concat($flagLocation,'flag-jp-30.png')"/>
			<xsl:with-param name="collapsed" select="1"/>
		</xsl:call-template>

		<xsl:call-template name="ywcIntranetWidgetWeather">
			<xsl:with-param name="preUri" select="$preUri"/>
			<xsl:with-param name="title" select="'korea'"/>
			<xsl:with-param name="listName" select="'weather-ko'"/>
			<xsl:with-param name="logoImage" select="concat($flagLocation,'flag-ko-30.png')"/>
			<xsl:with-param name="collapsed" select="1"/>
		</xsl:call-template>

		<xsl:call-template name="ywcIntranetWidgetWeather">
			<xsl:with-param name="preUri" select="$preUri"/>
			<xsl:with-param name="title" select="'russia'"/>
			<xsl:with-param name="listName" select="'weather-ru'"/>
			<xsl:with-param name="logoImage" select="concat($flagLocation,'flag-ru-30.png')"/>
			<xsl:with-param name="collapsed" select="1"/>
		</xsl:call-template>

		<xsl:call-template name="ywcIntranetWidgetWeather">
			<xsl:with-param name="preUri" select="$preUri"/>
			<xsl:with-param name="title" select="'usa'"/>
			<xsl:with-param name="listName" select="'weather-us'"/>
			<xsl:with-param name="logoImage" select="concat($flagLocation,'flag-us-30.png')"/>
			<xsl:with-param name="collapsed" select="1"/>
		</xsl:call-template>
		
		<xsl:call-template name="ywcIntranetWidgetWorldtimeInitialize">
		</xsl:call-template>
		
</xsl:template>

</xsl:stylesheet>
