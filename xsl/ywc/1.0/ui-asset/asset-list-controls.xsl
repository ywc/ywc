<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">

<xsl:include href="../ui-input/ywc-input-text.xsl" />
	
<xsl:template name="ywcAssetListControls">
<xsl:param name="show" as="xs:integer" select="1" />
<xsl:param name="listName" as="xs:string" select="'listname'" />
<xsl:param name="listHumanName" as="xs:string" select="'This List'" />
<xsl:param name="cacheId" as="xs:string" select="''" />
<xsl:param name="preUri" as="xs:string" select="'/'" />
<xsl:param name="showBttnAdd" as="xs:integer" select="1" />
<xsl:param name="showBttnSubscribe" as="xs:integer" select="1" />
<xsl:param name="showBttnArchive" as="xs:integer" select="1" />
<xsl:param name="searchAutoFocus" as="xs:integer" select="0" />
<xsl:param name="filterByDateTime" as="xs:string" select="''" />
	
	<div class="ywc-crnr-5 ywc-crnr-t-off ywc-container-list-controls">
		<xsl:if test="$show = 0"><xsl:attribute name="style" select="'display:none;'" /></xsl:if>

		<xsl:if test="$showBttnAdd = 1">
			<img src="{$preUri}lib/ywc-image/1.0/bttn/misc/add-item-01.png" class="bttn-add-item" onClick="YWC.f.intranetCheckAuth(function(){'{'}YWC.f.intranetPopupPostEdit('{$listName}');{'}'});" onLoad="YWC.f.uiSetHoverBulge(this,10,'hz',true)" />
		</xsl:if>

		<div class="asset-list-search {
			if (($showBttnAdd = 0) and ($showBttnSubscribe = 0) and ($showBttnArchive = 0)) then 'asset-list-search-wide'
			else if (($showBttnAdd = 0) and ($showBttnSubscribe = 0) and ($showBttnArchive = 1)) then 'asset-list-search-left-wide'
			else if (($showBttnAdd = 0) and ($showBttnSubscribe = 1) and ($showBttnArchive = 1)) then 'asset-list-search-left'
			else ''
		}">
			<xsl:call-template name="ywcInputText">
				<xsl:with-param name="preUri" select="$preUri"/>
				<xsl:with-param name="type" select="'text'"/>
				<xsl:with-param name="id" select="concat('asset-list-',$listName)"/>
				<xsl:with-param name="placeholder" select="concat('search ',lower-case($listHumanName),'...')"/>
				<xsl:with-param name="fontSize" select="10"/>
				<xsl:with-param name="eraseBttn" select="1"/>
				<xsl:with-param name="autoFocus" select="$searchAutoFocus"/>
				<xsl:with-param name="eraseBttnJs" select='concat(
						"YWC.f.assetSearchReset(&apos;",$listName,"&apos;"
						,if (string-length($filterByDateTime) &gt; 0) then concat(",{&apos;dateTime&apos;:&apos;",$filterByDateTime,"&apos;}") else ""
						,");")'/>
				<xsl:with-param name="icon" select="'lib/ywc-image/1.0/bttn/misc/search-01.png'"/>
				<xsl:with-param name="onTypeJs" select='concat("YWC.f.assetPagingGo(&apos;",$listName,"&apos;);")'/>
				<xsl:with-param name="onTypeJsMinLength" select="2"/>
			</xsl:call-template>
		</div>

		<xsl:if test="$showBttnArchive = 1">
			<img src="{$preUri}lib/ywc-image/1.0/bttn/misc/books-01.png" class="bttn-archive {
				if (($showBttnAdd = 0) and ($showBttnSubscribe = 0) and ($showBttnArchive = 1)) then 'bttn-archive-right' else ''
				}" id="ywc-list-controls-bttn-archive-{$listName}" onClick="YWC.f.intranetPostArchivePopup('{$listName}');" onLoad="YWC.f.uiSetHoverBulge(this,4,'hz',true)" />
		</xsl:if>
		
		<xsl:if test="$showBttnSubscribe = 1">
			<img src="{$preUri}lib/ywc-image/1.0/bttn/mail/envelope-01.png" class="bttn-subscribe" id="ywc-list-controls-bttn-subscribe-{$listName}" onClick="YWC.f.intranetCheckAuth(function(){'{'}YWC.f.intranetSubscribePopup('{$listName}');{'}'});" onLoad="YWC.f.uiSetHoverBulge(this,4,'hz',true)" />
		</xsl:if>

	</div>

</xsl:template>





</xsl:stylesheet>