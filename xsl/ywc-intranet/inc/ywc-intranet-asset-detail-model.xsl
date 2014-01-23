<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">

<xsl:template name="ywcIntranetAssetDetail">
<xsl:param name="preUri" as="xs:string" select="'/'" />
<xsl:param name="domain" as="xs:string" select="'/'" />
<xsl:param name="protocol" as="xs:string" select="'http'" />
<xsl:param name="show" as="xs:integer" select="0" />
<xsl:param name="useJavascript" as="xs:integer" select="1" />
<xsl:param name="cssStyle" as="xs:string" select="''" />
<xsl:param name="bodyCssStyle" as="xs:string" select="''" />
<xsl:param name="listName" as="xs:string" select="''" />
<xsl:param name="cacheId" as="xs:string" select="''" />
<xsl:param name="assetId" as="xs:string" select="''" />
<xsl:param name="currentUser" as="xs:string" select="''" />
<xsl:param name="author" as="xs:string" select="''" />
<xsl:param name="title" as="xs:string" select="''" />
<xsl:param name="thmb" as="xs:string" select="''" />
<xsl:param name="thmbLink" as="xs:string" select="''" />
<xsl:param name="body" as="xs:string" select="''" />
<xsl:param name="width" as="xs:integer" select="600" />
<xsl:param name="toggle-thmb" as="xs:integer" select="1" />
<xsl:param name="toggle-gallery" as="xs:integer" select="1" />
<xsl:param name="toggle-controls" as="xs:integer" select="1" />
<xsl:param name="toggle-controls-each" as="xs:integer*" select="(1,0,1,1)" />
<xsl:param name="meta" as="xs:string*" select="('','','','')" />
<xsl:param name="metaLabels" as="xs:string*" select="('','','','')" />
<xsl:param name="attachments" as="xs:string*" select="()" />
<xsl:param name="replyEmail" as="xs:string" select="''" />
	
	<xsl:variable as="xs:string*" name="adminUsers" select="
			tokenize(
			replace(
			unparsed-text(concat('../../../config/',ywc:getAppName(),'/admin_users'))
			,'&#xD;','')
			,'&#xA;')
		" />

	<xsl:variable name="ywcPublicCdn" select="ywc:getAppSetting('ywc.public.uri')" />
	
	<div class="{
			if ($show = 0) then 'ywc-popup-detail-model'
 			else concat('ywc-container-popup-detail ywc-container-popup-detail-',$listName,'-',$assetId)
		}"
		style="{concat('font-size:18px !important;'
				,' font-family:Arial,sans-serif !important;'
				,' width:',$width,'px;'
			)}{$cssStyle}{
			if ($show = 0) then 'display:none !important;' else ''
		}">
		
		<div class="ywc-popup-detail" id="ywc-popup-detail-{$listName}-{$assetId}">

		<xsl:variable as="xs:integer" name="isReadOnly" select="if (contains(document('../../../cache/xml/data/cache.xml')/ywc/cache[@name = $listName]/@properties,'read-only,')) then 1 else 0" />
		
		<xsl:variable name="currentEnv" select="ywc:getAppSetting('ywc.env.env')" />

 		<xsl:if test="
 				($isReadOnly = 0) and ($useJavascript = 1)
				and (
					( 	(string-length($currentUser) &gt; 1) and ($currentUser = $author) ) 
					or 	exists(index-of($adminUsers,lower-case($currentUser)))
					or 	($currentEnv = 'development')
				)
				"> 
			<!-- we don't need inline styles here because the edit controls should only be available on main intranet page -->

			<div class="ywc-popup-detail-edit-bttns">
 				<div class="bttn-edit ywc-crnr-5 bttn-edit-lf"
					onClick="YWC.f.intranetCheckAuth(function(){'{'}YWC.f.intranetPopupPostEdit('{$listName}','{substring-after($assetId,concat($listName,'_'))}');{'}'});">
					<img src="{
						if (string-length($ywcPublicCdn) &gt; 0) then concat('//',$ywcPublicCdn,'/')
								else concat($preUri,'public/')
						}ywc-image/bttn/misc/edit-01.png" />
					<span>Click here to edit the content of this item...</span>
				</div> 
				<div class="bttn-edit ywc-crnr-5 bttn-edit-rt"
					onClick="YWC.f.intranetPostDelete('{$listName}','{substring-after($assetId,concat($listName,'_'))}','{$cacheId}');">
					<img src="{
						if (string-length($ywcPublicCdn) &gt; 0) then concat('//',$ywcPublicCdn,'/')
								else concat($preUri,'public/')
						}ywc-image/bttn/misc/trash-01.png" />
					<span>...or here to delete it.</span>
				</div>

			</div>

 		</xsl:if>
		
		<!-- header container -->
		<div style="position:relative; font-size:100%; float:left; border:none; height:auto; width:99%; clear:both; padding-bottom:10px; margin-bottom:5px;">

			<!-- asset title -->
			<div style="font-weight:bold; font-size:115%; padding:0px; color:black;">	
				<xsl:value-of select="
					if (string-length($title) &gt; 0) then ywc:removeFormatting($title)
					else '&lt;span style=&quot;display:none !important;&quot;&gt;Title&lt;/span&gt;'
					" disable-output-escaping="yes" />
			</div>
			
			<!-- asset meta container -->
			<div style="font-weight:bold; font-size:75%; width:100%; clear:both; border:none; height:auto; padding:8px 0px;">
				
				<!-- meta #2, top right -->
				<span style="position:relative; float:right; text-align:right; clear:right; color:black; padding:0px 0px 3px 0px;">
					<xsl:value-of select="
						if (string-length($metaLabels[2]) &gt; 0) then concat($metaLabels[2],': ')
						else ''" disable-output-escaping="yes" />
					<xsl:value-of select="
					if (string-length($meta[2]) &gt; 0) then $meta[2]
					else '&lt;span style=&quot;display:none !important;&quot;&gt;Meta #2&lt;/span&gt;'
						" disable-output-escaping="yes" />
					</span>
				<!-- meta #1, top left -->
				<span style="position:relative; float:left; text-align:left; clear:left; color:black; padding:0px 0px 3px 0px;">
					<xsl:value-of select="
						if (string-length($metaLabels[1]) &gt; 0) then concat($metaLabels[1],': ')
						else ''" disable-output-escaping="yes" />
					<xsl:value-of select="
					if (string-length($meta[1]) &gt; 0) then ywc:removeFormatting($meta[1])
					else '&lt;span style=&quot;display:none !important;&quot;&gt;Meta #1&lt;/span&gt;'
					" disable-output-escaping="yes" />
					</span>
				<!-- meta #4, bottom right -->
				<span style="position:relative; float:right; text-align:right; clear:right; color:black; padding:{
					if (string-length($metaLabels[4]) &gt; 0) then '3' else '0'
					}px 0px 0px 0px;">
					<xsl:value-of select="
						if (string-length($metaLabels[4]) &gt; 0) then concat($metaLabels[4],': ')
						else ''" disable-output-escaping="yes" />
					<xsl:value-of select="
					if (string-length($meta[4]) &gt; 0) then $meta[4]
					else '&lt;span style=&quot;display:none !important;&quot;&gt;Meta #4&lt;/span&gt;'
					" disable-output-escaping="yes" />
					</span>
				<!-- meta #3, bottom left -->
				<span style="position:relative; float:left; text-align:left; clear:left; color:black; padding:{
					if (string-length($metaLabels[3]) &gt; 0) then '3' else '0'
					}px 0px 0px 0px;">
					<xsl:value-of select="
						if (string-length($metaLabels[3]) &gt; 0) then concat($metaLabels[3],': ')
						else ''" disable-output-escaping="yes" />
					<xsl:value-of select="
					if (string-length($meta[3]) &gt; 0) then ywc:removeFormatting($meta[3])
					else '&lt;span style=&quot;display:none !important;&quot;&gt;Meta #3&lt;/span&gt;'
					" disable-output-escaping="yes" />
					</span>
					
			</div>
		</div>	
		
		<div class="ywc-popup-detail-body" style="position:relative; float:left; border:none; height:auto; clear:both; border-top:solid 1px #cccccc; padding:8px 0px; overflow:hidden; color:black; width:{
			if ($width &gt; 0) then concat($width,'px') else '99%'
		};">

			<xsl:if test="($toggle-thmb = 1) and (string-length($thmb) &gt; 0)">
				<xsl:variable name="apos" select='"&apos;"' />
				<xsl:value-of select="concat(
					'&lt;a href=&quot;',$thmbLink,'&quot; target=&quot;_blank&quot;&gt;'
					,'&lt;div class=&quot;ywc-thmb ywc-popup-detail-body-thmb&quot;'
					,' style=&quot;'
						,'position:relative; float:right; top:0px; '
						,'width:',round($width div 3),'px; height:',round($width div 3),'px;'
						,'left:0px; border:none; margin:0px 0px 5px 8px;'
						,'overflow:hidden; cursor:pointer;'
					,'&quot;&gt;'
						
						,'&lt;img src=&quot;',$thmb,'?size=',round($width div 3),'&quot;'
							,' onLoad=&quot;YWC.f.uiSetSquImg(this,',$apos,'fit',$apos,')&quot;'
							,' style=&quot;float:right;'
								,if ($useJavascript = 0) then concat(
									'max-height:',round($width div 3),'px;'
									,'max-width:',round($width div 3),'px;'
									) else ''
								,'&quot;'
							,' /&gt;'
						
					,'&lt;/div&gt;'
					,'&lt;/a&gt;'
					)" disable-output-escaping="yes" />
					
					<!--
					To use after .NET is also able to ingest images...
					<xsl:value-of select="concat(
							'&lt;a href=&quot;',$thmbLink,'&quot; target=&quot;_blank&quot;&gt;'

							,'&lt;img src=&quot;',$thmb,'?size=',round($width div 3),'&quot;'
								,' style=&quot;',$thmbCss,'&quot;'
								,' onLoad=&quot;&quot; /&gt;'

							,'&lt;/a&gt;'
							)" disable-output-escaping="yes" />
					-->
					
					
			</xsl:if>
			
			<span class="ywc-popup-detail-body-content" style="color:black;{$bodyCssStyle}">
				<xsl:value-of select="
					if (string-length($body) &gt; 0) then
						replace(normalize-space(replace($body,'&amp;nbsp;',' ')),'&lt;p&gt; &lt;/p&gt;','')
					else '&lt;span style=&quot;display:none !important;&quot;&gt;Body&lt;/span&gt;'
				" disable-output-escaping="yes" />
			</span>
		
		</div>
		
		<xsl:if test="($toggle-gallery = 1) and ($useJavascript = 1)">
			<xsl:value-of select="concat('&lt;div class=&quot;ywc-popup-detail-attachments&quot;&gt;'
				,'&lt;div class=&quot;'
					,'ywc-container-vertical-list ywc-container-vertical-list-attachments-',$listName,'-',$assetId
					,'&quot;&gt;&lt;/div&gt;'
				,'&lt;div class=&quot;'
					,'ywc-container-stack-list ywc-container-stack-list-gallery-',$listName,'-',$assetId
					,'&quot;&gt;&lt;/div&gt;'
				,'&lt;/div&gt;')" disable-output-escaping="yes" />
		</xsl:if>	
			
		<xsl:if test="$toggle-controls = 1">
			
			<xsl:variable name="bttnDivCss"
				select="'position:relative; float:left; border:none; text-align:center; height:auto; cursor:pointer; padding:3px 0px;'" />
			
			<xsl:variable name="bttnImgCss"
				select="'position:relative; clear:both; margin-left:auto; margin-right:auto; width:45px; height:45px; border:solid 1px #dddddd;'" />
			<xsl:variable name="bttnLblCss"
				select="'position:relative; clear:both; width:80%; border:none; margin:3px 10%; font-size:67%; font-weight:bold;'" />
			
			<!-- special controls container -->
			<div class="ywc-popup-detail-controls ywc-unselectable" style="position:relative; float:left; border:none; height:auto; width:100%; clear:both; padding:8px 0px;">	
				
			<xsl:if test="$toggle-controls-each[1] = 1">
			<a href='{
				if ($useJavascript = 0) then concat(
					$protocol,"://",$domain,"/"
					,"ywc/intranet/link/",$listName,"/",substring-after($assetId,concat($listName,"_"))
				)
				else concat("javascript:YWC.f.intranetPopupDetailUtility("
					,"&apos;",$listName,"&apos;,&apos;",$assetId,"&apos;,1)")
				}'>
				<div class="ywc-popup-detail-controls-bttn"
					id="ywc-container-popup-detail-{$listName}-{$assetId}-1"
					style="{$bttnDivCss} width:{ round( 99 div sum($toggle-controls-each) ) }%;">
					<xsl:if test="$toggle-thmb = 1">
						<img src="{
								if (string-length($ywcPublicCdn) &gt; 0) then concat('//',$ywcPublicCdn,'/')
									else concat($preUri,'public/')
								}ywc-image/bttn/link/blue-01.png"
							id="ywc-container-popup-detail-{$listName}-{$assetId}-img-1"
							style="{$bttnImgCss}" 
							class="ywc-crnr-5"
							onLoad="{ if ($useJavascript = 1) then 'YWC.f.uiSetHoverImageToggle(this)' else '' }" />
					</xsl:if>
					<div style="{$bttnLblCss}">Perma-Link</div>
				</div>	
			</a>
			</xsl:if>
			<xsl:if test="$toggle-controls-each[2] = 1">
			<a href='{
				if ($useJavascript = 0) then concat(
					" "," "
				)
				else concat("javascript:YWC.f.intranetPopupDetailUtility("
					,"&apos;",$listName,"&apos;,&apos;",$assetId,"&apos;,2)")
				}'>
				<div class="ywc-popup-detail-controls-bttn"
					id="ywc-container-popup-detail-{$listName}-{$assetId}-2"
					style="{$bttnDivCss} width:{ round( 99 div sum($toggle-controls-each) ) }%;">
					<xsl:if test="$toggle-thmb = 1">
						<img src="{
								if (string-length($ywcPublicCdn) &gt; 0) then concat('//',$ywcPublicCdn,'/')
									else concat($preUri,'public/')
								}ywc-image/bttn/event/calendar-blue-01.png"
							id="ywc-container-popup-detail-{$listName}-{$assetId}-img-2"
							style="{$bttnImgCss}"
							class="ywc-crnr-5"
							onLoad="{ if ($useJavascript = 1) then 'YWC.f.uiSetHoverImageToggle(this)' else '' }" />
					</xsl:if>
					<div style="{$bttnLblCss}">Add to Calendar</div>
				</div>
			</a>
			</xsl:if>
			<xsl:if test="$toggle-controls-each[3] = 1">
			<a href='{
				if (($useJavascript = 0)
					or ($useJavascript = 1))
					then concat(
					"mailto:",$replyEmail
					,"?subject=",encode-for-uri(concat("Re: ",ywc:removeFormatting($title)))
					,"&amp;body=%20%0A----------"
					,"%0A",encode-for-uri(concat("This is an e-mail response to a posting on ",$domain))
					,"%0A",encode-for-uri("The original posting can be viewed in its entirety here:")
					,"%0A",encode-for-uri(concat($protocol,"://",$domain,"/ywc/intranet/link/",$listName,"/",substring-after($assetId,"_")))
				)
				else concat("javascript:YWC.f.intranetPopupDetailUtility("
					,"&apos;",$listName,"&apos;,&apos;",$assetId,"&apos;,3)")
				}'>
				<div class="ywc-popup-detail-controls-bttn"
					id="ywc-container-popup-detail-{$listName}-{$assetId}-3"
					style="{$bttnDivCss} width:{ round( 99 div sum($toggle-controls-each) ) }%;">
					<xsl:if test="$toggle-thmb = 1">
						<img src="{
								if (string-length($ywcPublicCdn) &gt; 0) then concat('//',$ywcPublicCdn,'/')
									else concat($preUri,'public/')
								}ywc-image/bttn/mail/reply-01.png"
							id="ywc-container-popup-detail-{$listName}-{$assetId}-img-3"
							style="{$bttnImgCss}"
							class="ywc-crnr-5"
							onLoad="{ if ($useJavascript = 1) then 'YWC.f.uiSetHoverImageToggle(this)' else '' }" />
					</xsl:if>
					<div style="{$bttnLblCss}">Reply</div>
				</div>
			</a>
			</xsl:if>
			<xsl:if test="$toggle-controls-each[4] = 1">
			<a href='{
				if ($useJavascript = 0)
					then concat(
					"mailto:"
					,"?subject=",encode-for-uri(concat("Fwd: ",ywc:removeFormatting($title)))
					,"&amp;body=%20%0A----------"
					,"%0A",encode-for-uri(concat("This is an e-mail forwarding for a posting on ",$domain))
					,"%0A",encode-for-uri("The original posting can be viewed in its entirety here:")
					,"%0A",encode-for-uri(concat($protocol,"://",$domain,"/ywc/intranet/link/",$listName,"/",substring-after($assetId,"_")))
				)
				else concat("javascript:"
					,"YWC.f.intranetCheckAuth(function(){"
					,"YWC.f.intranetPopupDetailUtility("
					,"&apos;",$listName,"&apos;,&apos;",$assetId,"&apos;,4);"
					,"});"
					)
			}'>
				<div class="ywc-popup-detail-controls-bttn"
					id="ywc-container-popup-detail-{$listName}-{$assetId}-4"
					style="{$bttnDivCss} width:{ round( 99 div sum($toggle-controls-each) ) }%;">
					<xsl:if test="$toggle-thmb = 1">
						<img src="{
								if (string-length($ywcPublicCdn) &gt; 0) then concat('//',$ywcPublicCdn,'/')
									else concat($preUri,'public/')
								}ywc-image/bttn/mail/forward-01.png"
							id="ywc-container-popup-detail-{$listName}-{$assetId}-img-4"
							style="{$bttnImgCss}" 
							class="ywc-crnr-5"
							onLoad="{ if ($useJavascript = 1) then 'YWC.f.uiSetHoverImageToggle(this)' else '' }" />
					</xsl:if>
					<div style="{$bttnLblCss}">Forward</div>
				</div>
			</a>
			</xsl:if>
		</div>
		</xsl:if>
		
		</div>
	<!--	
		<xsl:value-of select="concat($author,' - ',$currentUser)" />
	-->
	</div>

</xsl:template>

</xsl:stylesheet>