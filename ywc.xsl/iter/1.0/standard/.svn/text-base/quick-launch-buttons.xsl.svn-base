<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" exclude-result-prefixes="xs xsl ywc yweather geo">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../../ywc/1.0/inc/ywc-core.xsl" />


<xsl:template match="/">

	<xsl:variable name="preUri" select="ywc:preUri($uri,$lang)" />

	<div class="ywc-intranet-quick-launch-buttons">

		<img style="left:5%;" class="page-buttons" onClick="iterQuickLaunchPopup('safety-numbers')" src="//static-1.iter.org/buzz/img/quicklaunch/button/safety-01.png" onLoad="YWC.f.uiSetHoverBulge(this,6,'hz',false)" />

		<img style="left:25%;" class="page-buttons" onClick="iterQuickLaunchPopup('safety')" src="//static-1.iter.org/buzz/img/quicklaunch/button/safety-02.png" onLoad="YWC.f.uiSetHoverBulge(this,6,'hz',false)" />

		<img style="left:45%;" class="page-buttons" onClick="iterQuickLaunchPopup('suggestions')" src="//static-1.iter.org/buzz/img/quicklaunch/button/idea-01.png" onLoad="YWC.f.uiSetHoverBulge(this,6,'hz',false)" />

		<img style="left:63%;" class="page-buttons" onClick="iterWebcamPopup()" src="//static-1.iter.org/buzz/img/quicklaunch/button/broadcast-01.png" onLoad="YWC.f.uiSetHoverBulge(this,6,'hz',false)" />
		
		<img style="left:80%;" onClick="YWC.f.intranetPopupDirectory(this,'right');" class="page-buttons" src="{$preUri}lib/ywc-image/1.0/bttn/misc/search-02.png" onLoad="YWC.f.uiSetHoverBulge(this,6,'hz',false)" />

	</div>
	
	<div class="ywc-intranet-quick-launch-buttons">
		<img style="left:10%;width:80%;top:10px;" class="page-buttons" src="//static-1.iter.org/buzz/img/quicklaunch/button/improve-01.png" onClick="iterImproveItPopup();" onLoad="YWC.f.uiSetHoverBulge(this,15,'hz',false)" />
	</div>
		
</xsl:template>

</xsl:stylesheet>
