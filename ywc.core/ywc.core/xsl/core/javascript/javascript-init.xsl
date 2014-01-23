<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:template name="ywcJavascriptInitialize">
<xsl:param name="preUri" as="xs:string" select="'/'" />
<xsl:param name="absUri" as="xs:string" select="'/'" />
<xsl:param name="publicUri" as="xs:string" select="'/'" />
<xsl:param name="env" as="xs:string*" select="('env','app','domain','server')" />

<script type="text/javascript"> var YWC={<!--
		-->"uri":{<!--
			-->"pre":"<xsl:value-of select="$preUri"/>","abs":"<xsl:value-of select="$absUri"/>"<!--
			-->,"cdn":"<xsl:value-of select="
					if (string-length($publicUri) &gt; 0) then concat('//',$publicUri,'/')
					else concat($preUri,'public/')
				"/>"<!--
		-->},"popup":{<!--
		-->},"f":{<!--
		-->},"env":{"env":"<xsl:value-of select="$env[1]"/>","app":"<xsl:value-of select="$env[2]"/>","domain":"<xsl:value-of select="$env[3]"/>","server":"<xsl:value-of select="$env[4]"/>"<!--
		-->},"map":{<!--
		-->},"ui":{<!--
		-->},"store":{<!--
		-->},"intranet":{<!--
		-->},"list":{<!--
			-->"data":{},"meta":{},"list":{}<!--
		-->},"input":{<!--
			-->"value":{<!--
				-->"text":{},"select":{},"checkbox":{},"file":{},"datetime":{},"hidden":{},"button":{},"custom":{}<!--
			-->},"meta":{<!--
				-->"jsBlock":{},"valueLength":{}<!--
				-->,"validation":{"required":{},"type":{}}<!--
				-->,"dateTime":[{"format":{}}]<!--
				-->,"lastValue":{"text":{},"select":{},"checkbox":{},"file":{},"datetime":{},"hidden":{}}<!--
			-->}<!--
		-->},"track":{<!--	-->"google":{"appId":"","domain":"","meta":{}}<!--
		-->},"api":{<!--	"ipinfodb":{},"geonames":{},"foursquare":{}
		-->},"user":{<!--
			-->"id":"","name":"","email":"","scope":"","role":"","geo":{"lat":0,"lng":0},"date":{"now":0,"zone":{}}<!--
		-->},"social":{<!--
			-->"facebook":{"appId":null,"onload":null,"var":["FB"],"doInit":true,"srcUri":[],"srcParams":[]}<!--
			-->,"twitter":{"appId":null,"onload":null,"var":["twttr"],"doInit":true,"srcUri":[],"srcParams":[]}<!--
			-->,"googleplus":{"appId":null,"onload":null,"var":["gapi"],"doInit":true,"srcUri":[],"srcParams":[]}<!--
			-->,"pinterest":{"appId":null,"onload":null,"var":["gapi"],"doInit":true,"srcUri":[],"srcParams":[]}<!--
		-->}<!--
	-->}; </script>
</xsl:template>

</xsl:stylesheet>