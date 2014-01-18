<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="user" as="xs:string" select="'guest'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../ywc/inc/ywc-core.xsl" />
<xsl:include href="../../ywc/ui-input/ywc-input-button.xsl" />

<xsl:variable name="preUri" as="xs:string" select="ywc:getParam('preUri',$params)" />

<xsl:variable name="siteTitle" as="xs:string" select="ywc:getParam('siteTitle',$params)" />
<xsl:variable name="accountType" as="xs:string" select="ywc:getParam('accountType',$params)" />
<xsl:variable name="onClickJs" as="xs:string" select="ywc:getParam('onClickJs',$params)" />

<xsl:template match="/">

<div style="font-size:16px;margin-bottom:20px;text-align:center;"><!--
	-->Some features<!--
	--><xsl:if test="(string-length($siteTitle) &gt; 0)"> on <xsl:value-of select="$siteTitle"/></xsl:if><!--
	--> require that<!--
	--><br />you log-in<!--
	--><xsl:if test="(string-length($accountType) &gt; 0)"> to your <xsl:value-of select="$accountType"/> account</xsl:if><!--
	-->.<!--
	--><br /><br />We have noticed that you<!--
	--><br />are <span style="font-weight:bold;">not</span> currently logged-in.<!--
	--><br /><br />This will only take a moment.<!--
	--></div>

<xsl:call-template name="ywcInputButton">
	<xsl:with-param name="id" select="'ywc-intranet-auth-popout'" />
	<xsl:with-param name="label" select="'Log-in'" />
	<xsl:with-param name="labelAlreadyClicked" select="'Logging-in...'" />
	<xsl:with-param name="fontSize" select="22" />
	<xsl:with-param name="onClickJs" select='$onClickJs' />
</xsl:call-template>


</xsl:template>

</xsl:stylesheet>