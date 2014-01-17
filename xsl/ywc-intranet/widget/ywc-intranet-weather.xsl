<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" exclude-result-prefixes="xs xsl ywc dt rs z yweather geo">

<xsl:template name="ywcIntranetWidgetWeather">
<xsl:param name="preUri" as="xs:string" select="'/'" />
<xsl:param name="title" as="xs:string" select="'ywc'" />
<xsl:param name="listName" as="xs:string" select="'weather'" />
<xsl:param name="logoImage" as="xs:string" select="''" />
<xsl:param name="collapsed" as="xs:integer" select="0" />
	
	<xsl:for-each select="document('../../../cache/xml/data/cache.xml'
							)/ywc/cache[lower-case(@name)=lower-case($listName)]">
			
			<xsl:variable as="xs:string" name="ywcCacheId">
				<xsl:value-of select="@cache_id" />
			</xsl:variable>
			
			 <xsl:variable name="srcXml" select="
		document(concat('../../../cache/xml/'
			,if (contains($ywcCacheId,'..')) then 'core/blank'
			else concat('cache/',$ywcCacheId)
		,'.xml'))/rss/channel/item" />
		
		<xsl:call-template name="ywcIntranetWidgetWeatherHeader">
			<xsl:with-param name="preUri" select="$preUri"/>
			<xsl:with-param name="title" select="$title"/>
			<xsl:with-param name="listName" select="concat('location-',substring-after($listName,'weather-'))"/>
			<xsl:with-param name="logoImage" select="$logoImage"/>
		</xsl:call-template>
		
		<xsl:variable name="locationId" select="substring-after(@name,'-')" />
	
		<div class="ywc-clmn-block ywc-intranet-widget-weather ywc-crnr-5 ywc-crnr-t-off ywc-unselectable" id="ywc-intranet-widget-weather-header-{$locationId}" onClick="window.open('{substring-after($srcXml/link,'*')}');"
			style="{if ($collapsed = 1) then 'height:0px;border:none;border-top:none;padding:0px 0px;' else ''}">
		<table>
			<tr>
			<td class="lf" style="">
			<span style="font-weight:bold;"><xsl:value-of select="concat($srcXml/yweather:condition/@temp,'&#176;C')" /><br />
			<xsl:value-of select="ywc:limitLength(concat('',$srcXml/yweather:condition/@text),16)" /></span>
			<br /><img class="forecast" src="{concat($preUri,'url/',substring-after(substring-before($srcXml/description,'&quot;/&gt;'),'&quot;http://'))}" alt="{$srcXml/yweather:condition/@text}" />
			</td>
			<td class="rt" style="">
			<span style="font-weight:bold;">24h forecast:</span><br /><xsl:value-of select="concat($srcXml/yweather:forecast[1]/@low,'&#176;C - ',$srcXml/yweather:forecast[1]/@high,'&#176;C')" />
			<br /><span><xsl:value-of select="ywc:limitLength(concat('',$srcXml/yweather:forecast[1]/@text),16)" /></span>
			<br /><br /><span style="font-weight:bold;">48h forecast:</span><br /><xsl:value-of select="concat($srcXml/yweather:forecast[2]/@low,'&#176;C - ',$srcXml/yweather:forecast[2]/@high,'&#176;C')" />
			<br /><span><xsl:value-of select="ywc:limitLength(concat('',$srcXml/yweather:forecast[2]/@text),16)" />
			</span>
			</td>
			</tr>
			<tr>
			<td colspan="2" style="text-align:center;font-weight:bold;font-size:14px;">click for more info...

			</td>
			</tr>
		</table>
		</div>
	</xsl:for-each>

</xsl:template>




<xsl:template name="ywcIntranetWidgetWeatherHeader">
<xsl:param name="preUri" as="xs:string" select="'/'" />
<xsl:param name="listName" as="xs:string" select="'weather'" />
<xsl:param name="logoImage" as="xs:string" select="''" />
<xsl:param name="title" as="xs:string" select="'ywc'" />

	<xsl:for-each select="document('../../../cache/xml/data/cache.xml'
							)/ywc/cache[lower-case(@name)=lower-case($listName)]">
			
		<xsl:variable as="xs:string" name="ywcCacheId">
			<xsl:value-of select="@cache_id" />
		</xsl:variable>
			
		<xsl:variable name="srcXml" select="
			document(concat('../../../cache/xml/'
				,if (contains($ywcCacheId,'..')) then 'core/blank'
				else concat('cache/',$ywcCacheId)
				,'.xml'))/geonames/timezone" />
		
		<xsl:variable name="locationId" select="substring-after(@name,'-')" />
		
		
		<script type="text/javascript">$(function(){<!--
			-->YWC.f.coreSetDefault("intranet", ["worldtime", "<xsl:value-of select="$locationId" />", "timezoneOffset"], <xsl:value-of select="$srcXml/dstOffset" />);<!--
		-->});</script>
		
		<div class="ywc-clmn-block ywc-crnr-5 ywc-crnr-b-off ywc-intranet-widget-weather-header" id="ywc-intranet-widget-weather-header-{$locationId}" onClick="YWC.f.intranetWeatherDisplay(this)">
			<table>
				<tr>
					<td class="title"><span><xsl:value-of select="$title"/>:</span></td>
					<xsl:if test="string-length($logoImage) &gt; 0">
						<td class="logo"><img src="{$logoImage}" /></td>
					</xsl:if>
					<td class="time"><xsl:value-of select="'&lt;span&gt;&lt;/span&gt;'" disable-output-escaping="yes" /></td>
				</tr>
			</table>
		</div>
		
	</xsl:for-each>

</xsl:template>


<xsl:template name="ywcIntranetWidgetWorldtimeInitialize">
	
	<script type="text/javascript">$(function(){ YWC.exec.setQueue("YWC.f.intranetWorldtimeUpdate();"); });</script>

</xsl:template>


</xsl:stylesheet>
