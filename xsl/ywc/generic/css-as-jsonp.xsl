<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../ywc/inc/ywc-core.xsl" />
<xsl:include href="../../ywc/inc/ywc-convert.xsl" />

<xsl:variable name="includeName" select="lower-case(substring-after($uri,'/css-as-jsonp/'))" />

<xsl:template match="/">
	
	<xsl:for-each select="	(	document('../../../ywc.core/ywc.core/xml/data/include.xml')
							| 	document('../../../cache/xml/data/include.xml')
							)/ywc/include[@name = $includeName][@content_type = 'text/css']"><!--
		-->if ((typeof $ != 'undefined')<!--
		--> <xsl:value-of select="'&amp;&amp;'" disable-output-escaping="yes"/><!--
		--> ($('#link-<xsl:value-of select="$includeName" />, link.link-ywc-aggregate[id*=link-<xsl:value-of select="$includeName" />\\;]').length == 0)<!--
		-->) {<!--
		--> $('head').append('<style type="text/css" id="link-{$includeName}"><!--
		--> <xsl:value-of select="concat(' ',replace(ywc:escApos(unparsed-text(concat('../../../ywc.',@uri))),'&#xA;',''),' ')" /><!--
		--></style>'); }<!--
	--></xsl:for-each>

</xsl:template>

</xsl:stylesheet>