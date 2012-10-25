<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:param name="user" as="xs:string" select="'guest'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../../ywc/1.0/inc/ywc-core.xsl" />
<xsl:include href="../../../ywc-intranet/1.0/nav/ywc-intranet-nav-footer.xsl" />


<xsl:template match="/">
	
	<xsl:call-template name="ywcIntranetFooterNav">
		<xsl:with-param name="font-size" select="14" />
		<xsl:with-param name="labels" select="('','Logout from Buzz')" />
		<xsl:with-param name="links" select="('', '')" />
	</xsl:call-template>

</xsl:template>

</xsl:stylesheet>
