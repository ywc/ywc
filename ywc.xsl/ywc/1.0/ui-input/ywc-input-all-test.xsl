<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../inc/ywc-core.xsl" />
<xsl:include href="../inc/ywc-convert.xsl" />
<xsl:include href="ywc-input-all.xsl" />

<xsl:template match="/">
	
	<style type="text/css">
		.test-button {  }
		.test-button-hover {  }
	</style>
	

	
	
	
	
<!--
	<div style="margin-top:50px;width:350px;margin-left:50px;clear:both;">
	
	<xsl:call-template name="ywcInputButton">
		<xsl:with-param name="id" select="'button-1'" />
		<xsl:with-param name="label" select="'I have not been clicked'" />
		<xsl:with-param name="labelAlreadyClicked" select="'you clicked me'" />
		<xsl:with-param name="class" select="'test-button'" />
		<xsl:with-param name="fontSize" select="18" />
		<xsl:with-param name="onClickJs" select='"console.log(&apos;clicked&apos;);"' />
		<xsl:with-param name="isClickable" select="1" />
		<xsl:with-param name="isUnClickable" select="1" />
		<xsl:with-param name="isAlreadyClicked" select="0" />
	</xsl:call-template>
	
	</div>
	
	<div style="margin-top:50px;width:350px;margin-left:50px;clear:both;">
	
	<xsl:call-template name="ywcInputButton">
		
		<xsl:with-param name="id" select="'button-4'" />
		<xsl:with-param name="label" select="'now I am unclicked'" />
		<xsl:with-param name="labelAlreadyClicked" select="'I am already clicked'" />
		<xsl:with-param name="class" select="'test-button'" />
		<xsl:with-param name="fontSize" select="18" />
		<xsl:with-param name="onClickJs" select='"console.log(&apos;clicked&apos;);"' />
		<xsl:with-param name="isClickable" select="1" />
		<xsl:with-param name="isUnClickable" select="1" />
		<xsl:with-param name="isAlreadyClicked" select="1" />
	</xsl:call-template>
	
	</div>


	<div style="margin-top:50px;width:250px;margin-left:50px;clear:both;">
	
	<xsl:call-template name="ywcInputButton">
		
		<xsl:with-param name="id" select="'button-2'" />
		<xsl:with-param name="label" select="'My Button'" />
		<xsl:with-param name="labelAlreadyClicked" select="'I am clicked'" />
		<xsl:with-param name="class" select="'test-button'" />
		<xsl:with-param name="fontSize" select="12" />
		<xsl:with-param name="onClickJs" select='"console.log(&apos;clicked&apos;);"' />
		<xsl:with-param name="isClickable" select="1" />
		<xsl:with-param name="isUnClickable" select="1" />
		<xsl:with-param name="isAlreadyClicked" select="0" />
		<xsl:with-param name="labelCircle" select="'+1'" />
		<xsl:with-param name="labelCircleAlreadyClicked" select="'+2'" />
	</xsl:call-template>
	
	</div>
	
	<div style="margin-top:5px;width:250px;margin-left:50px;clear:both;">
	
	<xsl:call-template name="ywcInputButton">
		
		<xsl:with-param name="id" select="'new-buttn'" />
		<xsl:with-param name="label" select="'My Button'" />
		<xsl:with-param name="labelAlreadyClicked" select="'was clicked'" />
		<xsl:with-param name="class" select="'test-button'" />
		<xsl:with-param name="fontSize" select="28" />
		<xsl:with-param name="onClickJs" select='"console.log(&apos;clicked&apos;);"' />
		<xsl:with-param name="isClickable" select="1" />
		<xsl:with-param name="isUnClickable" select="1" />
		<xsl:with-param name="isAlreadyClicked" select="0" />
		<xsl:with-param name="labelCircle" select="'+1'" />
		<xsl:with-param name="labelCircleAlreadyClicked" select="'+2'" />
	</xsl:call-template>
	
	</div>	
-->

</xsl:template>

</xsl:stylesheet>