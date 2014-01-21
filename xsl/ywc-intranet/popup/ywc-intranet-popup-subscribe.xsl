<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:param name="user" as="xs:string" select="'guest'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../ywc/inc/ywc-core.xsl" />
<xsl:include href="../../ywc/inc/ywc-convert.xsl" />
<xsl:include href="../../ywc/ui-input/ywc-input-text.xsl" />
<xsl:include href="../../ywc/ui-input/ywc-input-button.xsl" />

<xsl:variable name="username" select="''"/>
<xsl:variable name="me-xml" select="document('../../../cache/xml/cache/ldap.xml')/users/user[@uid=$user]" />

<xsl:variable name="preUri" as="xs:string" select="ywc:getParam('preUri',$params)" />

<xsl:variable name="ywcPublicCdn" select="ywc:getAppSetting('ywc.public.uri')" />
<xsl:variable name="ywcPublicUri" select="if (string-length($ywcPublicCdn) &gt; 0) then concat('//',$ywcPublicCdn,'/') else concat($preUri,'public/')" />

<xsl:variable name="listName" as="xs:string" select="ywc:getParam('listName',$params)" />

<xsl:template match="/">
	
	<xsl:variable as="xs:string" name="listHumanName">
		<xsl:for-each select="ywc/cache[lower-case(@name)=lower-case($listName)]">
			<xsl:value-of select="@title" />
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:variable as="xs:string" name="listId">
		<xsl:for-each select="ywc/cache[lower-case(@name)=lower-case($listName)]">
			<xsl:value-of select="if (contains(substring-after(@properties,'subscribe_id='),','))
					then substring-before(substring-after(@properties,'subscribe_id='),',')
					else substring-after(@properties,'subscribe_id=')
				" />
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:variable name="buttonToggleJs" select='"YWC.f.inputButtonClick(YWC.f.inputGetById(&apos;intranet-subscribe-submit&apos;,&apos;button&apos;),true);"' />
	<xsl:variable name="submitJs" select='concat("YWC.f.intranetSubscribeConfirm(&apos;",$listId,"&apos;,&apos;",$listName,"&apos;);")' />
	
	<div class="ywc-container-popup-utility">
		<div class="utility-title">Receive e-mail notifications for<br />&apos;<xsl:value-of select="$listHumanName" />&apos;</div>
		<div class="utility-desc">If you would prefer to be notified by e-mail, please submit your e-mail address below.</div>
		
		<div class="utility-body">
			<div style="position:relative;width:110%;clear:both;font-weight:bold;margin-top:10px;text-align:center;">
			<xsl:call-template name="ywcInputText">
				<xsl:with-param name="preUri" select="$preUri"/>
				<xsl:with-param name="id" select="'intranet-subscribe-email'"/>
				<xsl:with-param name="fontSize" select="14"/>
				<xsl:with-param name="placeholder" select="'Enter your e-mail address..'"/>
				<xsl:with-param name="autoFocus" select="0"/>
				<xsl:with-param name="eraseBttn" select="1"/>
				<xsl:with-param name="icon" select="concat($ywcPublicUri,'ywc-image/bttn/mail/envelope-01.png')"/>
			<!--	<xsl:with-param name="value" select="ywc:rtrnUserEmail($user)"/>-->	
				<xsl:with-param name="onReturnKeyJs" select='concat($buttonToggleJs,$submitJs)'/>
			</xsl:call-template>
			</div>
			
			<div class="warning" style="display:none;"><!--
				-->Please make sure you have entered<br />a valid e-mail address.<!--
			--></div>
			
			<div style="position:relative;float:right;margin-top:10px;width:75%;">
			
			<xsl:call-template name="ywcInputButton">
				<xsl:with-param name="id" select="'intranet-subscribe-submit'" />
				<xsl:with-param name="label" select="'Subscribe by E-mail'" />
				<xsl:with-param name="labelAlreadyClicked" select="'Please wait a moment...'" />
				<xsl:with-param name="fontSize" select="18" />
				<xsl:with-param name="onClickJs" select='$submitJs' />
			</xsl:call-template>
			
			</div>
			
		</div>
		
		<!--
		<hr style="position:relative;clear:both;top:15px;" />
		
		<br />
		<br />
		<div class="utility-title">Subscribe to this list by RSS</div>
		<div class="utility-desc">If you would prefer to be notified by rss feed, you may use the link below.</div>
		
		<div class="utility-body">
			<div style="position:relative;width:99%;clear:both;font-weight:bold;text-align:center;"><a href="https://tida.oist.jp/feed/{$listName}" target="_blank"><xsl:value-of select="concat('https://tida.oist.jp/feed/',$listName)" /></a></div>
		</div>	
			-->
	</div>

</xsl:template>

</xsl:stylesheet>
