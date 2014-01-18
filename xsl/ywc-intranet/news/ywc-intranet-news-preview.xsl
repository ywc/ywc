<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">


<xsl:template name="ywcIntranetNewsPreview">
<xsl:param name="preUri" as="xs:string" select="'/'" />
<xsl:param name="listName" as="xs:string" select="'news'" />
<xsl:param name="articleId" as="xs:string" select="''" />
<xsl:param name="sortBy" as="xs:string" select="'posted'" />
<xsl:param name="uiHeaderColor" as="xs:string" select="'bbbbbb'" />
<xsl:param name="uiHeaderBgColor" as="xs:string" select="'444444'" />

	<xsl:for-each select="ywc/cache[@name=$listName]">
		
		<xsl:call-template name="ywcHeader">
			<xsl:with-param name="preUri" select="$preUri"/>
			<xsl:with-param name="text" select="lower-case(@title)"/>
			<xsl:with-param name="width" select="120"/>
			<xsl:with-param name="fontsize" select="20"/>
			<xsl:with-param name="color" select="$uiHeaderColor"/>
			<xsl:with-param name="bg-color" select="$uiHeaderBgColor"/>
		</xsl:call-template>
	
		<xsl:variable name="srcXml" select="document(concat('../../../../cache/xml/cache/',@cache_id,'.xml'))" />
		
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
		
		<xsl:for-each select="$srcXmlAggr">
			<xsl:sort data-type="text" select="
				if (string-length($sortBy)!=0) then *[name()=$sortBy]
				else nid" order="descending" />
			
			<xsl:if test="position() &lt;= 2">
				
				<xsl:variable name="storyId" select='
					if ($srcXmlProfile = "drupal") then nid
						else if ($srcXmlProfile = "sharepoint") then @ows_ID
						else nid
					' />	
			
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
					
									
			<xsl:choose>
				<xsl:when test="position() = 1">
			
					<div class="ywc-intranet-news-preview-title">
						<a href="javascript:YWC.f.intranetPopupNews('news','{$storyId}');">
							<xsl:value-of select="ywc:removeFormatting(ywc:getNodeValue(.,'title'))" disable-output-escaping="yes" />
						</a>
					</div>

					<div class="ywc-intranet-news-preview-body">
						<span class="ywc-intranet-news-preview-body">
							<div class="ywc-thmb ywc-intranet-news-preview-thmb" onClick="YWC.f.intranetPopupNews('news','{$storyId}');">
						
								<img src="{$imgUri}" onLoad="YWC.f.uiSetSquImg(this,'border-radius');" />
							</div>
							<xsl:value-of select="
								ywc:limitLength(ywc:removeFormatting(ywc:getNodeValue(.,'body')),700)
								" disable-output-escaping="yes" />
						</span>
					</div>
		
				</xsl:when>
				<xsl:otherwise>
				
					<div class="ywc-intranet-news-history">
					
						<div class="ywc-intranet-news-history-header">
							<xsl:call-template name="ywcHeader">
								<xsl:with-param name="preUri" select="$preUri"/>
								<xsl:with-param name="text" select="'last featured story'"/>
								<xsl:with-param name="width" select="120"/>
								<xsl:with-param name="fontsize" select="14"/>
								<xsl:with-param name="color" select="$uiHeaderColor"/>
								<xsl:with-param name="bg-color" select="$uiHeaderBgColor"/>
							</xsl:call-template>
						</div>
					
						<div class="ywc-crnr-5 ywc-asset-list ywc-vertical-list ywc-intranet-news-history-story"
							 onClick="YWC.f.intranetPopupNews('news','{ywc:escApos($storyId)}');">
					
							<div class="ywc-thmb asset-thmb">
								<img src="{$imgUri}" alt="" onLoad="YWC.f.uiSetSquImg(this,'border-radius')" />
							</div>
							
							<span class="asset-title">
								<xsl:value-of select="ywc:removeFormatting(ywc:getNodeValue(.,'title'))" disable-output-escaping="yes" />
							</span>
							
							<span class="asset-meta">
								<span style="display:none;">Date</span>
							</span>
							
							<script type="text/javascript"><!--
							-->$(function(){<!--
								-->$('div.ywc-intranet-news-history-story span.asset-meta')<!--
								-->.html(YWC.f.dateConvert('<xsl:value-of select='
									if (string-length(ywc:getNodeValue(.,"posted")) &gt; 0) then ywc:getNodeValue(.,"posted")
									else ywc:getNodeValue(.,"created")
								' />'<!--
								-->,{'type':'date','format':'local'}))<!--
							-->});<!--
							--></script>
						</div>
						
						<div class="ywc-crnr-5 ywc-asset-list ywc-vertical-list ywc-intranet-news-controls">
							
							<img src="{$preUri}lib/ywc-image/bttn/misc/books-01.png"
								class="bttn bttn-archive" onLoad="YWC.f.uiSetHoverBulge(this,4,'hz',true)"
								id="ywc-list-controls-bttn-archive-news"
								onClick="YWC.f.intranetPostArchivePopup('news',{'{'}sortBy:'{$sortBy}'{'}'});" />
								
							<img src="{$preUri}lib/ywc-image/bttn/mail/envelope-01.png"
								class="bttn bttn-subscribe" onLoad="YWC.f.uiSetHoverBulge(this,4,'hz',true)"
								id="ywc-list-controls-bttn-subscribe-news"
								onClick="YWC.f.intranetCheckAuth(function(){'{'}YWC.f.intranetSubscribePopup('news');{'}'});" />
								
						</div>
				
				</div>
				
				</xsl:otherwise>
				</xsl:choose>
			
			</xsl:if>
			
		</xsl:for-each>
	
	</xsl:for-each>

</xsl:template>


	
	
</xsl:stylesheet>
