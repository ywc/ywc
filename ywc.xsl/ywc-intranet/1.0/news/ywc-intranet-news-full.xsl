<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">


<xsl:template name="ywcIntranetNewsFull">
<xsl:param name="preUri" as="xs:string" select="'/'" />
<xsl:param name="listName" as="xs:string" select="'news'" />
<xsl:param name="articleId" as="xs:string" select="''" />
<xsl:param name="uiHeaderColor" as="xs:string" select="'bbbbbb'" />
<xsl:param name="uiHeaderBgColor" as="xs:string" select="'444444'" />
<xsl:param name="uiFallbackImage" as="xs:string" select="''" />


<xsl:for-each select="ywc/cache[@name=$listName]">
	
	<xsl:call-template name="ywcHeader">
		<xsl:with-param name="preUri" select="$preUri"/>
		<xsl:with-param name="text" select="lower-case(@title)"/>
		<xsl:with-param name="width" select="120"/>
		<xsl:with-param name="fontsize" select="36"/>
		<xsl:with-param name="color" select="$uiHeaderColor"/>
		<xsl:with-param name="bg-color" select="$uiHeaderBgColor"/>
	</xsl:call-template>

	<xsl:variable name="srcXml" select="document(concat('../../../../ywc.cache/xml/cache/',@cache_id,'.xml'))" />
	
	<xsl:variable name="srcXmlAggr" select="
		(	$srcXml/nodes/node
		|	$srcXml/rs:data/z:row
		)[	(string-length(string-join((*|@*),'')) &gt; 0) ]
		" />
	
	<xsl:variable name="srcXmlProfile" select="
		if (count($srcXml/nodes) &gt; 0) then 'drupal'
		else if (count($srcXml/rs:data) &gt; 0) then 'sharepoint'
		else ''
		" />
	
	<xsl:for-each select="$srcXmlAggr[
			(nid = $articleId)
		or	(@ows_ID = $articleId)
		]">
		
				
	<xsl:variable name="parsedAttachments" select="
				ywc:getImgUrl(ywc:getNodeValue(.,'attachments'),1)
				" />

	<xsl:variable name="parsedImages" select="
			if (string-length(ywc:getNodeValue(.,'images')) &gt; 0)
				then ywc:getImgUrl(ywc:getNodeValue(.,'images'),1)
			else ''
			" />
			
	<xsl:variable name="imgUri" select='
			if (string-length($parsedImages) &gt; 0) then $parsedImages
			else if (string-length($parsedAttachments) &gt; 0) then $parsedAttachments
			else if ($listName = "news") then $uiFallbackImage
			else ""
			' />
		
		
		<span class="ywc-intranet-news-full">
	
		<div style="width:99%;font-size:24px;font-weight:bold;margin-top:24px;text-align:left;">
			<xsl:value-of select="ywc:removeFormatting(ywc:getNodeValue(.,'title'))" disable-output-escaping="yes" />
		</div>

		<div class="news-meta">
			<xsl:value-of select="
				concat('&lt;span&gt;'
				,if (contains(ywc:getNodeValue(.,'author0'),'unspecified')) then ''
					else if (string-length(ywc:getNodeValue(.,'author0')) &gt; 0) then ywc:getNodeValue(.,'author0')
					else if (string-length(ywc:getNodeValue(.,'author')) &gt; 0) then ywc:getNodeValue(.,'author')
					else ''
				,ywc:getNodeValue(.,'source')
				,'&lt;/span&gt;')
				" disable-output-escaping="yes" />
			<span style="float:right;" class="ywc-intranet-date-unformatted-date">
				<xsl:value-of select='
					
					if ($srcXmlProfile = "drupal") then
							if ($listName = "news-external") then ywc:getNodeValue(.,"published")
							else ywc:getNodeValue(.,"posted")
						else if ($srcXmlProfile = "sharepoint") then ywc:getNodeValue(.,"publishdatetime")
						else ""
					' disable-output-escaping="yes" />
			</span>
		</div>

		<div style="width:99%;font-size:14px;margin-top:10px;">
		
			<span class="news-body" style="font-size:12px;text-decoration:none;color:black;clear:left;">
				
				<xsl:if test="string-length($imgUri) &gt; 0">
				<a href="{$imgUri}?size=1024" target="_blank">
					<div class="ywc-thmb" style="position:relative; float:right; padding:none; margin:0px 0px 2px 8px; width:200px; height:200px; border:solid 1px #bbbbbb; overflow:hidden; cursor:pointer;">
						<img src="{$imgUri}" onLoad="YWC.f.uiSetSquImg(this,'fit');" />
					</div>
				</a>
				</xsl:if>
				
			<xsl:value-of select="ywc:getNodeValue(.,'body')" disable-output-escaping="yes" />
			</span>
		
		</div>

		
		
		<div class="news-footer">
			<span style="position:relative;float:right;margin-right:0px;margin-top:12px;">
			<xsl:call-template name="ywcInputButton">	
				<xsl:with-param name="preUri" select="$preUri" />
				<xsl:with-param name="id" select="'news-popup-close'" />
				<xsl:with-param name="label" select="'Close Window'" />
				<xsl:with-param name="fontSize" select="14" />
				<xsl:with-param name="onClickJs" select='"YWC.f.popupKill(1);"' />
			</xsl:call-template>
			</span>
		</div>
		
		</span>
		
		<script type="text/javascript">
			
			<xsl:value-of select='"$(function(){"' />
				
				<!-- load story data into JS object for UI related parsing -->
				<xsl:call-template name="ywcStoreObjectAsJavascript">
					<xsl:with-param name="node" select="."/>
					<xsl:with-param name="assetId" select="concat($listName,'_',$articleId)"/>
				</xsl:call-template>
				
				<xsl:value-of select='concat("YWC.f.intranetPopupNewsRefine("
						,"&apos;",$listName,"&apos;"
						,",&apos;",$articleId,"&apos;);")'/>
				
			<xsl:value-of select='"});"' />
		
		</script>
		
	</xsl:for-each>
	
</xsl:for-each>


</xsl:template>


	
	
</xsl:stylesheet>
