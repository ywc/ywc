<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="domain" as="xs:string" select="''" />
<xsl:param name="protocol" as="xs:string" select="'http'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="user" as="xs:string" select="''" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../ywc/1.0/inc/ywc-core.xsl" />
<xsl:include href="../../ywc/1.0/inc/ywc-convert.xsl" />
<xsl:include href="../../ywc/1.0/ui-input/ywc-input-text.xsl" />
<xsl:include href="../../ywc/1.0/ui-input/ywc-input-button.xsl" />

<xsl:variable name="title" as="xs:string*" select="(
	'Perma-Link','Add to Outlook','Reply to this Posting','Forward this Posting'			
	)" />
<xsl:variable name="desc" as="xs:string*" select="(
	'The following &quot;Perma-Link&quot; is a reference URL for this posting that will never change. It is useful if you would like to refer to this posting at a later date, or if you need to reference the posting in an external document.'
	,'The following link will allow you to add this event to your Outlook calendar.'
	,'Send a quick reply to the person that posted this message by typing your message into the box below:'
	,'Please provide a recipient e-mail address below. A copy of this posting (formatted just like the posting displayed above) will be forwarded to the given address.'			
	)" />
	
<xsl:variable name="action" as="xs:integer" select="xs:integer(ywc:getParam('action',$params))" />	
	<xsl:variable name="assetId" as="xs:string" select="ywc:getParam('assetId',$params)" />
<xsl:variable name="preUri" as="xs:string" select="ywc:getParam('preUri',$params)" />

<xsl:template match="/">

	<xsl:variable as="xs:string" name="cacheId">
		<xsl:for-each select="ywc/cache[@name=substring-before($assetId,'_')]">
			<xsl:value-of select="@cache_id" />
		</xsl:for-each>
	</xsl:variable>

	<div class="ywc-container-popup-utility" id="ywc-container-popup-utility-xxxxxx">
		
		<div class="utility-title"><xsl:value-of select="$title[$action]" /></div>
		<div class="utility-desc"><xsl:value-of select="$desc[$action]" /></div>
		
		<div class="utility-body">
			<xsl:choose>
				<xsl:when test="$action = 1">
					
					<xsl:variable name="link" select="concat(
						$protocol,'://',$domain,'/ywc/intranet/link/'
						,substring-before($assetId,'_'),'/',substring-after($assetId,'_')
						)" />
					
					<div style="position:relative;width:110%;clear:both;font-weight:bold;margin-top:10px;text-align:center;">
					<xsl:call-template name="ywcInputText">
						<xsl:with-param name="preUri" select="$preUri"/>
						<xsl:with-param name="id" select="'asset-utility-1'"/>
						<xsl:with-param name="fontSize" select="10"/>
						<xsl:with-param name="style" select="'text-align:center;'"/>
						<xsl:with-param name="value" select="$link"/>
						<xsl:with-param name="readOnly" select="1"/>
						<xsl:with-param name="autoFocus" select="1"/>
						<xsl:with-param name="icon" select="'lib/ywc-image/bttn/link/blue-01.png'"/>
					</xsl:call-template>
					</div>
					
					<div style="position:relative;width:99%;clear:both;font-weight:bold;text-align:center;padding:10px 0px;"><!--
					-->Copy / paste the link above, or click the link below:<!--
					--></div>
					
					<div style="position:relative;width:99%;clear:both;font-weight:bold;text-align:center;">
						<a href="{$link}" target="_blank"><xsl:value-of select="$link" /></a>
					</div>
					
				</xsl:when>
				
				<xsl:when test="$action = 2">
				
					<xsl:variable name="link" select="'https://tida.oist.jp/ywc/vcal'" />
				
					<div style="position:relative;width:99%;clear:both;font-weight:bold;text-align:center;"><a href="{$link}" target="_blank"><xsl:value-of select="$link" /></a></div>
				</xsl:when>
								
				<xsl:when test="$action = 3">
					
					<div style="position:relative;width:110%;clear:both;font-weight:bold;margin-top:10px;text-align:center;">
					<xsl:call-template name="ywcInputText">
						<xsl:with-param name="preUri" select="$preUri"/>
						<xsl:with-param name="id" select="'asset-utility-3'"/>
						<xsl:with-param name="fontSize" select="14"/>
						<xsl:with-param name="type" select="'textarea'"/>
						<xsl:with-param name="richText" select="0"/>
						<xsl:with-param name="placeholder" select="'Please type your message here...'"/>
						<xsl:with-param name="autoFocus" select="0"/>
						<xsl:with-param name="eraseBttn" select="1"/>
					</xsl:call-template>
					</div>

				<div style="position:relative;width:99%;clear:both;padding:10px 0px;font-weight:bold;text-align:center;">Your message will be sent by email to the author of the post.</div>

				<div style="position:relative;width:99%;clear:both;padding:5px 0px;font-weight:bold;text-align:right;">
					<xsl:call-template name="ywcInputButton">
						<xsl:with-param name="id" select="'asset-utility-3-submit'" />
						<xsl:with-param name="label" select="'Send my Reply'" />
						<xsl:with-param name="fontSize" select="18" />
						<xsl:with-param name="onClickJs" select='concat("alert(","&apos;submitted&apos;",")")' />
					</xsl:call-template>
				</div>
													
				</xsl:when>

				<xsl:when test="$action = 4">
					
					
					<xsl:variable name="assetTitle" as="xs:string" select="ywc:getParam('assetTitle',$params)" />
					
					<xsl:variable name="onSubmitJs" as="xs:string" select='concat(
						"YWC.f.intranetPostEmailForward("
							,"&apos;",ywc:escApos(substring-before($assetId,"_")),"&apos;"
							,",&apos;",ywc:escApos(substring-after($assetId,"_")),"&apos;"
							,",YWC.input.value.text[&apos;asset-utility-4&apos;]"
							,");"
						)' />
					
					<div class="ywc-intranet-popup-utility-row" style="width:113%;">
						
					<xsl:call-template name="ywcInputText">
						<xsl:with-param name="preUri" select="$preUri"/>
						<xsl:with-param name="id" select="'asset-utility-4'"/>
						<xsl:with-param name="fontSize" select="16"/>
						<xsl:with-param name="value" select="''"/>
						<xsl:with-param name="placeholder" select="'E-mail Address of the Recipient...'"/>
						<xsl:with-param name="autoFocus" select="0"/>
						<xsl:with-param name="eraseBttn" select="1"/>
						<xsl:with-param name="icon" select="'lib/ywc-image/bttn/mail/envelope-01.png'"/>
						<xsl:with-param name="onReturnKeyJs" select='$onSubmitJs'/>
					</xsl:call-template>
					</div>
					
							<div class="warning" style="display:none;"><!--
								-->Please make sure you have entered<br />a valid e-mail address.<!--
							--></div>
					
					<div class="ywc-intranet-popup-utility-row" style="width:60%;float:right;left:1%;">
						
					<xsl:call-template name="ywcInputButton">
						<xsl:with-param name="id" select="'forward-posting'" />
						<xsl:with-param name="label" select="'Send E-mail'" />
						<xsl:with-param name="labelAlreadyClicked" select="'One Moment Please...'" />
						<xsl:with-param name="fontSize" select="18" />
						<xsl:with-param name="onClickJs" select='$onSubmitJs' />
					</xsl:call-template>
					
					</div>
				
					
				</xsl:when>
				
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</div>

	</div>

</xsl:template>

</xsl:stylesheet>