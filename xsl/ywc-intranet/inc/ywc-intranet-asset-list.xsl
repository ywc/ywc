<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">

<xsl:include href="../../ywc/ui-asset/asset-list-item.xsl" />
<xsl:include href="../../vendor/xcal-calendar/1.0/xcal-calendar.xsl" />
	
<xsl:template name="ywcIntranetAssetList">
<xsl:param name="listName" as="xs:string" select="''" /><!-- system name of list (can be matched to a ywcCacheId) -->
<xsl:param name="listTarget" as="xs:string" select="''" /><!--asset list target (where to draw the list) -->
<xsl:param name="groupSize" as="xs:integer" select="6" />
<xsl:param name="groupCurr" as="xs:integer" select="0" />
<xsl:param name="sortBy" as="xs:string" select="''" />
<xsl:param name="sortOrder" as="xs:string" select="'descending'" />
<xsl:param name="sortByType" as="xs:string" select="'text'" />
<xsl:param name="searchTerm" as="xs:string" select="''" />
<xsl:param name="filterByDateTime" as="xs:string" select="''" />
<xsl:param name="uiFallbackImage" as="xs:string" select="''" />
	
	<xsl:variable name="listTarget_" select="if (string-length($listTarget) = 0) then $listName else $listTarget" />
	
	<xsl:variable name="cacheXml" select="document(
						'../../../cache/xml/data/cache.xml'
						)/ywc/cache[lower-case(@name)=lower-case($listName)]" />
	
	<xsl:variable as="xs:string" name="ywcCacheId">
		<xsl:for-each select="$cacheXml">
			<xsl:value-of select="@cache_id" />
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable as="xs:string" name="listHumanName">
		<xsl:for-each select="$cacheXml">
			<xsl:value-of select="@title" />
		</xsl:for-each>
	</xsl:variable>

	<!-- constructs path for xml cache file, or blank if it suspects an invalid path -->
	<xsl:variable name="srcXmlPath" select="
		concat('../../../cache/xml/'
			,if (contains($ywcCacheId,'..')) then 'core/blank'
			else concat('cache/',$ywcCacheId)
		,'.xml')" />

	<xsl:variable name="srcXml" select="
			if ($listName = 'calendar') then ywc:iCalxCal(unparsed-text($srcXmlPath))
			else document($srcXmlPath)
		" />
		
	<!-- aggregates xml input based on multiple possible xml structures (Drupal and Sharepoint, LDAP) -->
	<xsl:variable name="srcXmlAggr" select="
		(	$srcXml/nodes/node
		|	$srcXml/rs:data/z:row
		|	$srcXml/users/user
		|	$srcXml/vcalendar/vevent
		)[
			(string-length(string-join((*|@*),'')) &gt; 0)
		]" />	
		
	<!-- filter xml by searchTerm-->
	<xsl:variable name="srcXml_" select="
		if (string-length($searchTerm) = 0) then 
			$srcXmlAggr
		else 
			$srcXmlAggr[	
				contains(lower-case(string-join((*|@*),' ')),lower-case($searchTerm))
			]
		" />
	
	<!-- filter xml by date param (optional)-->
	<xsl:variable name="currDateTime" select="current-dateTime()" />
	<xsl:variable name="divDateTime" select="xs:dayTimeDuration('PT1M')" />
	<xsl:variable name="srcXml__" select="
		if (string-length($filterByDateTime) = 0) then
				$srcXml_
		else 
			$srcXml_[
				(((xs:dateTime(ywc:getNodeValue(.,$filterByDateTime)) - $currDateTime) div $divDateTime) &gt; 0)
			]
		" />		
		
		<xsl:variable name="srcXmlProfile" select="
			if (count($srcXml/nodes) &gt; 0) then 'drupal'
			else if (count($srcXml/rs:data) &gt; 0) then 'sharepoint'
			else if (count($srcXml/users) &gt; 0) then 'directory'
			else if (count($srcXml/vcalendar) &gt; 0) then 'ical'
			else ''" />
		
		<xsl:value-of select='"$(function(){"' />
		
		<xsl:value-of select='if ($groupCurr &gt; 0) then "" else concat(
					"YWC.list.list[&apos;",$listTarget_,"&apos;]=[];"
					)' />
		
		<xsl:variable name="sortOrder_" select="if (string-length($sortOrder)!=0) then $sortOrder else 'descending'" />
		<xsl:variable name="sortByType_" select="if (string-length($sortByType)!=0) then $sortByType else 'text'" />
		<xsl:variable name="sortBy_" select="if (string-length($sortBy)!=0) then $sortBy else 'nid'" />

		<xsl:for-each select="$srcXml__">
			<xsl:sort data-type="{$sortByType}" order="{$sortOrder_}" select="(*|@*)[name()=$sortBy_]" />
			<!-- this sort fallback could be improved to not always fallback on Drupal structure... -->
				
			<xsl:if test="	(position() &gt; ($groupSize*$groupCurr))
				and (position() &lt;= ($groupSize*($groupCurr+1)))
				">
				
				
				<xsl:variable name="assetId" select="concat($listName,'_',
					if (string-length(nid) &gt; 0) then nid
					else if (string-length(ywc:getNodeValue(.,'id')) &gt; 0) then ywc:getNodeValue(.,'id')
					else if (string-length(ywc:getNodeValue(.,'uid')) &gt; 0) then replace(ywc:getNodeValue(.,'uid'),'\.','_')
					else position()
					)" />
				
				<xsl:variable name="userFullName" select="
					if ($srcXmlProfile = 'drupal') then ywc:directoryUserFullName(ywc:getNodeValue(.,'author'),'Unknown User')
					else if ($srcXmlProfile = 'sharepoint') then substring-after(ywc:getNodeValue(.,'author'),';#')
					else if ($srcXmlProfile = 'directory') then concat(
						ywc:getNodeValue(.,'firstname'),' ',ywc:getNodeValue(.,'lastname')
						)
					else if ($srcXmlProfile = 'ical') then 'your mom'
					else ywc:getNodeValue(.,'author')
					" />
				
				<xsl:variable name="parsedAttachments" select="
							ywc:getImgUrl(ywc:getNodeValue(.,'attachments'),1)
						" />
						
				<xsl:variable name="parsedImages" select='
						if (string-length(ywc:getNodeValue(.,"images")) &gt; 0)
							then ywc:getImgUrl(ywc:getNodeValue(.,"images"),1)
						else if (string-length(ywc:getNodeValue(.,"image")) &gt; 0)
							then ywc:getImgUrlFromHtml(ywc:getNodeValue(.,"image"))
						else ""
						' />						
				
				<xsl:variable name="thmbUri" select='
					if ($srcXmlProfile = "directory") then ywc:getNodeValue(.,"thumbnailUrl")
					else if (string-length($parsedImages) &gt; 0) then $parsedImages
					else if (string-length($parsedAttachments) &gt; 0) then $parsedAttachments
					else if ($listName = "news") then $uiFallbackImage
					else ""
					' />
				
				<xsl:call-template name="ywcStoreObjectAsJavascript">
					<xsl:with-param name="node" select="."/>
					<xsl:with-param name="assetId" select="$assetId"/>
					<xsl:with-param name="omit" select="('body','bodytext')"/>
				</xsl:call-template>
				
				<xsl:value-of select="'&#xA;'" />
				
				<xsl:call-template name="ywcAssetListItem">
					<xsl:with-param name="listName" select="$listTarget_"/>
					<xsl:with-param name="assetId" select="$assetId"/>
					<xsl:with-param name="cssClasses" select="concat('ywc-intranet-list-',$listTarget_)"/>
					
					<xsl:with-param name="title" select="
						if ($srcXmlProfile = 'directory') then $userFullName
						else if ($srcXmlProfile = 'ical') then ywc:getNodeValue(.,'summary')
						else ywc:getNodeValue(.,'title')
					"/>
					
					<xsl:with-param name="thmb" select="$thmbUri"/>
					<xsl:with-param name="thmbSquareType" select="'border-radius'"/>
					
					<xsl:with-param name="clickAction" select='concat("",
							if ($srcXmlProfile = "directory") then
								concat("window.open(&apos;mailto:"
									,ywc:directoryUserEmail(ywc:getNodeValue(.,"uid"))
								,"&apos;);")
							else concat(
								"YWC.f.intranetPostPopup(&apos;",$listName,"&apos;,&apos;",$assetId,"&apos;,&apos;"
									,if ($srcXmlProfile = "drupal") then ywc:getNodeValue(.,"nid")
									else if ($srcXmlProfile = "sharepoint") then ywc:getNodeValue(.,"id")
									else if ($srcXmlProfile = "ical") then replace(ywc:getNodeValue(.,"uid"),"\.","_")
									else ""
								,"&apos;)")
							)'/>

					<xsl:with-param name="metaLabel" select='
						if ($srcXmlProfile = "directory") then ""
						else if (contains($listName,"events")) then "When"
						else if ($srcXmlProfile = "drupal") then ""
						else if ($srcXmlProfile = "sharepoint") then ""
						else if ($srcXmlProfile = "ical") then ""
						else ""
					'/>
					
					<xsl:with-param name="metaValue" select='
						if ($srcXmlProfile = "directory") then
								concat(ywc:getNodeValue(.,"title")
								," ",if (string-length(ywc:getNodeValue(.,"company")) &gt; 0)
									then concat("(",ywc:getNodeValue(.,"company"),")") else ""
								,"&lt;br /&gt;"
								," ",if (string-length(ywc:getNodeValue(.,"department")) &gt; 0)
									then concat(ywc:getNodeValue(.,"department")," - ") else ""
								," ",if (string-length(ywc:getNodeValue(.,"office")) &gt; 0)
									then concat("Office: ",ywc:getNodeValue(.,"office")) else "" )
						else if (contains($listName,"events")) then concat("YWC.f.dateConvert(&apos;"
							,if ($srcXmlProfile = "drupal") then xs:dateTime(ywc:dateStringProcess(ywc:getNodeValue(.,"start-date")))
							else if ($srcXmlProfile = "sharepoint") then ywc:getNodeValue(.,"expirationdate")
							else ""
							,"&apos;,{&apos;type&apos;:&apos;datetime&apos;,&apos;format&apos;:&apos;local&apos;,&apos;exclude&apos;:&apos;s&apos;})")
						else if (contains($listName,"calendar")) then concat("YWC.f.dateConvert(&apos;"
							,if ($srcXmlProfile = "ical") then ywc:getNodeValue(.,"dtstart")
							else ""
							,"&apos;,{&apos;type&apos;:&apos;datet&apos;,&apos;format&apos;:&apos;local&apos;})")
						else if ($listName = "news") then concat("YWC.f.dateConvert(&apos;"
							,if ($srcXmlProfile = "sharepoint") then ywc:getNodeValue(.,"publishdatetime")
								else if ($srcXmlProfile = "drupal") then ywc:getNodeValue(.,"posted")
								else ""
							,"&apos;,{&apos;type&apos;:&apos;date&apos;,&apos;format&apos;:&apos;local&apos;})")
						else concat("YWC.f.dateConvert(&apos;"
							,if ($srcXmlProfile = "drupal") then
									if ($listName = "news-external") then ywc:getNodeValue(.,"published")
									else ywc:getNodeValue(.,"posted")
								else if ($srcXmlProfile = "sharepoint") then ywc:getNodeValue(.,"created")
								else ""
							,"&apos;,{&apos;type&apos;:&apos;date&apos;,&apos;format&apos;:&apos;local&apos;})")
					'/>
					
					<xsl:with-param name="metaValueAsString" select='
						if ($srcXmlProfile = "directory") then 1
						else if ($srcXmlProfile = "drupal") then 0
						else if ($srcXmlProfile = "sharepoint") then 0
						else if ($srcXmlProfile = "ical") then 0
						else 1
					'/>
					
					<xsl:with-param name="metaAltLabel" select='
						if ($srcXmlProfile = "directory") then ""
						else if (contains($listName,"events")) then "Location"
						else if ($listName = "news-external") then "Source"
						else if ($listName = "marketplace") then "Posted by"
						else if ($listName = "announcements") then "Posted by"
						else if ($listName = "lost-and-found") then "Posted by"
						else if ($listName = "calendar") then ""
						else ""
					'/>
					
					<xsl:with-param name="metaAltValue" select='
						if ($srcXmlProfile = "directory") then
								concat(ywc:getNodeValue(.,"telephone")
								,"&lt;br /&gt;",ywc:getNodeValue(.,"mail"))
						else if (contains($listName,"events")) then
								concat( ywc:getNodeValue(.,"location") , ywc:getNodeValue(.,"eventlocation") )
						else if ($listName = "news-external") then ywc:getNodeValue(.,"source")
						else if ($listName = "marketplace") then $userFullName
						else if ($listName = "announcements") then $userFullName
						else if ($listName = "lost-and-found") then $userFullName
						else if ($listName = "calendar") then ""
						else if ($listName = "community")
							then concat(ywc:getNodeValue(.,"type"),", ",ywc:getNodeValue(.,"category"))
						else ""
					'/>
					<xsl:with-param name="metaAltValueAsString" select='
						if ($srcXmlProfile = "directory") then 1
						else if ($srcXmlProfile = "drupal") then 1
						else if ($srcXmlProfile = "sharepoint") then 1
						else 1
					'/>
						
					<xsl:with-param name="titleMaxLength" select="200"/>
					<xsl:with-param name="metaMaxLength" select="200"/>
					<xsl:with-param name="metaAltMaxLength" select="200"/>
					
				</xsl:call-template>
	
			</xsl:if>
		</xsl:for-each>
		
		<xsl:variable name="listTargetEsc" select="ywc:escApos($listTarget_)" />
		
		<xsl:value-of select='concat(""
			,"YWC.f.assetMetaCount(&apos;",$listTargetEsc,"&apos;,&apos;",count($srcXml__),"&apos;);"
			,"YWC.list.meta[&apos;",$listTargetEsc,"&apos;].groupSize=",$groupSize,";"
			,"YWC.list.meta[&apos;",$listTargetEsc,"&apos;].sortBy=&apos;",ywc:escApos($sortBy_),"&apos;;"
			,"YWC.list.meta[&apos;",$listTargetEsc,"&apos;].sortOrder=&apos;",ywc:escApos($sortOrder_),"&apos;;"
			,"YWC.list.meta[&apos;",$listTargetEsc,"&apos;].sortByType=&apos;",ywc:escApos($sortByType_),"&apos;;"
			,"YWC.list.meta[&apos;",$listTargetEsc,"&apos;].dataSource=function(){"
				,"YWC.f.intranetAssetPagingDataSource(&apos;",ywc:escApos($listName),"&apos;,&apos;",$listTargetEsc,"&apos;);"
			,"};"
		)' disable-output-escaping="yes" />
		
		<xsl:value-of select='concat("YWC.list.meta[&apos;",$listTargetEsc,"&apos;].emptyMessage=&apos;"
			,"no items found in ",lower-case($listHumanName)
			,"&apos;;")' />
		
		<xsl:value-of select='"});"' />

</xsl:template>


</xsl:stylesheet>
