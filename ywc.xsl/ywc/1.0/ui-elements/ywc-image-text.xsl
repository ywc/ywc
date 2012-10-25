<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">


<xsl:template name="ywcImageText">
<xsl:param name="preUri" as="xs:string" select="'/'"/>
<xsl:param name="height" as="xs:string" select="''"/>
<xsl:param name="width" as="xs:string" select="''"/>

<xsl:param name="id" as="xs:string" select="''" />
<xsl:param name="class" as="xs:string" select="''" />

<xsl:param name="onclick" as="xs:string" select="''"/>
<xsl:param name="onload" as="xs:string" select="''"/>

<xsl:param name="text" as="xs:string" select="'ywc-header'"/>
<xsl:param name="background" as="xs:string" select="'fffffe'"/>
<xsl:param name="font" as="xs:string" select="'arial'"/>
<xsl:param name="fill" as="xs:string" select="'000000'"/>
<xsl:param name="fontsize" as="xs:integer" select="24"/>
<xsl:param name="stroke" as="xs:string" select="''"/>
<xsl:param name="strokewidth" as="xs:integer" select="1"/>

<!-- these hover options are not currently used... hopefully in an upcoming version... -->
<xsl:param name="hover-fill" as="xs:string" select="''"/>
<xsl:param name="hover-stroke" as="xs:string" select="''"/>
<xsl:param name="hover-background" as="xs:string" select="''"/>
<xsl:param name="hover-class" as="xs:string" select="''"/>

	<xsl:value-of select="concat('&lt;img '
		, if (string-length($id) != 0) then
			concat(' id=&quot;ywc-img-txt-',$id,'&quot;') else ''
		,' class=&quot;ywc-img-txt ywc-unselectable',$class,'&quot;'
		,' src=&quot;',$preUri,'img/text/?text=',replace(encode-for-uri($text),'&quot;','\\&quot;')
			,'&amp;fill=',$fill,'&amp;background=',$background
			,'&amp;font=',$font,'&amp;pointsize=',$fontsize*2
			,'&amp;stroke=',if (string-length($stroke) = 0) then $fill else $stroke
			,'&amp;strokewidth=',$strokewidth
		,'&quot;'
		,' style=&quot;'
			, if (string-length($height) != 0) then concat('height:',$height,';') else ''
			, if (string-length($width) != 0) then concat('width:',$width,';') else ''
		,'&quot;'
		,' alt=&quot;',replace($text,'&quot;','\\&quot;'),'&quot;'
		, if (string-length($onclick) != 0) then
			concat(' onClick=&quot;',replace($onclick,'&quot;','\\&quot;'),'&quot;') else ''
		, if (string-length($onload) != 0) then
			concat(' onLoad=&quot;',replace($onload,'&quot;','\\&quot;'),'&quot;') else ''
		,' unselectable=&quot;on&quot;'
		,' /&gt;')" disable-output-escaping="yes" />

</xsl:template>


</xsl:stylesheet>