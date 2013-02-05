<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">

<xsl:include href="../../../xcal-calendar/1.0/xcal-calendar.xsl" />

<xsl:template name="ywcIntranetAssetDetailDraw">
<xsl:param name="listName" as="xs:string" select="''" />
<xsl:param name="assetId" as="xs:string" select="''" />
<xsl:param name="srcIdVal" as="xs:string" select="''" />
<xsl:param name="boxWidth" as="xs:integer" select="600" />
<xsl:param name="cssStyle" as="xs:string" select="''" />
<xsl:param name="bodyCssStyle" as="xs:string" select="'font-size:67% !important;'" />
<xsl:param name="useJavascript" as="xs:integer" select="1" />
<xsl:param name="toggleImages" as="xs:integer" select="1" />
<xsl:param name="domain" as="xs:string" select="''" />
<xsl:param name="protocol" as="xs:string" select="'http'" />
<xsl:param name="currentUser" as="xs:string" select="''" />
<xsl:param name="preUri" as="xs:string" select="'/'" />
	

	<xsl:variable as="xs:string" name="ywcCacheId">
		<xsl:for-each select="ywc/cache[lower-case(@name)=lower-case($listName)]">
			<xsl:value-of select="@cache_id" />
		</xsl:for-each>
	</xsl:variable>

	<!-- constructs path for xml cache file, or blank if it suspects an invalid path -->
	<xsl:variable name="srcXmlPath" select="
		concat('../../../../ywc.cache/xml/'
			,if (contains($ywcCacheId,'..')) then 'core/blank'
			else concat('cache/',$ywcCacheId)
		,'.xml')" />

	<xsl:variable name="srcXml" select="
			if ($listName = 'calendar') then ywc:iCalxCal(unparsed-text($srcXmlPath))
			else document($srcXmlPath)
		" />

	<xsl:variable name="srcXmlProfile" select="
			if (count($srcXml/nodes) &gt; 0) then 'drupal'
			else if (count($srcXml/rs:data) &gt; 0) then 'sharepoint'
			else if (count($srcXml/users) &gt; 0) then 'directory'
			else if (count($srcXml/vcalendar) &gt; 0) then 'ical'
			else ''" />
				
	<xsl:variable name="srcIdName" select="
			if ($srcXmlProfile = 'drupal') then 'nid'
			else if ($srcXmlProfile = 'sharepoint') then 'id'
			else if ($srcXmlProfile = 'directory') then 'uid'
			else if ($srcXmlProfile = 'ical') then 'uid'
			else ''" />

	<xsl:for-each select="
			(	$srcXml/nodes/node
			|	$srcXml/rs:data/z:row
			|	$srcXml/vcalendar/vevent
			)/(*|@*)[
						(lower-case(name())=$srcIdName)
				or 	(lower-case(substring-after(name(),'ows_'))=$srcIdName)
			][
						(.=$srcIdVal)
				or 	(replace(.,'\.','_')=$srcIdVal)
			]/..
		">
		
		<xsl:variable name="dateCreated" as="xs:dateTime" select="
				if (string-length(ywc:getNodeValue(.,'created')) &gt; 0)
					then xs:dateTime(ywc:getNodeValue(.,'created'))
				else if (string-length(ywc:getNodeValue(.,'posted')) &gt; 0)
					then (xs:dateTime('1970-01-01T00:00:00Z') + xs:double(ywc:getNodeValue(.,'posted')) * xs:dayTimeDuration('PT1S'))
				else xs:dateTime('1970-01-01T00:00:00Z')
			" />

		<xsl:variable name="dateExpiration" as="xs:dateTime" select="
				if (string-length(ywc:getNodeValue(.,'start_datetime')) &gt; 0)
					then (xs:dateTime('1970-01-01T00:00:00Z')
							+ xs:double(ywc:removeSpace(ywc:getNodeValue(.,'start_datetime'))) * xs:dayTimeDuration('PT1S')
						)
							
				else if (string-length(ywc:getNodeValue(.,'expirationdate')) &gt; 0)
					then xs:dateTime(ywc:removeSpace(ywc:getNodeValue(.,'expirationdate')))

				else if (string-length(ywc:getNodeValue(.,'start-date')) &gt; 0)
					then xs:dateTime(ywc:dateStringProcess(ywc:getNodeValue(.,'start-date')))

				else xs:dateTime('1970-01-01T00:00:00Z')
			" />

		<xsl:variable name="duration" as="xs:integer" select="
				if (string-length(ywc:getNodeValue(.,'duration')) &gt; 0)
					then xs:integer(round(xs:double(ywc:removeSpace(ywc:getNodeValue(.,'duration')))))

				else if (string-length(ywc:getNodeValue(.,'end-date')) &gt; 0) then
					if (contains(lower-case(ywc:getNodeValue(.,'end-date')),'all day'))
						then -1
					else xs:integer((xs:dateTime(ywc:dateStringProcess(ywc:getNodeValue(.,'end-date'))) - $dateExpiration) div xs:dayTimeDuration('PT1S'))

				else 0 " />
				
		<xsl:variable name="dateEnd" as="xs:dateTime" select="
			if ($duration &gt; 0)
				then ( $dateExpiration + ($duration * xs:dayTimeDuration('PT1S')) )
			else $dateExpiration
			" />
		
		<xsl:variable name="meta1" select="
			if ($srcXmlProfile = 'drupal') then 
				if (string-length(ywc:getNodeValue(.,'authorname')) != 0) then ywc:directoryUserFullName(ywc:getNodeValue(.,'authorname'),'')
				else ywc:directoryUserFullName(ywc:getNodeValue(.,'author'),'')
			else if ($srcXmlProfile = 'sharepoint') then substring-after(ywc:getNodeValue(.,'author'),';#')
			else if ($srcXmlProfile = 'ical') then 'calendar'
			else ywc:getNodeValue(.,'author')
			" />
			
		<xsl:variable name="meta2" select="
			if (string-length(ywc:getNodeValue(.,'price')) &gt; 0) then ywc:getNodeValue(.,'price')
			else if ($dateExpiration &gt; xs:dateTime('1970-01-01T00:00:00Z')) then
				if ($duration &lt; 86400)
					then concat(
						'&lt;span class=&quot;ywc-intranet-date-unformatted-date&quot;&gt;'
						,if ($useJavascript = 1) then $dateExpiration else substring-before(concat('',$dateExpiration),'T')
						,'&lt;/span&gt;')
				else concat(
					'&lt;span class=&quot;ywc-intranet-date-unformatted-date&quot;&gt;'
					,if ($useJavascript = 1) then $dateExpiration else substring-before(concat('',$dateExpiration),'T')
					,'&lt;/span&gt;'
					,' at '
					,'&lt;span class=&quot;ywc-intranet-date-unformatted-time&quot;&gt;'
					,if ($useJavascript = 1) then $dateExpiration else substring(concat('',$dateExpiration),12,5)
					,'&lt;/span&gt;'
					)
					
			else concat(
					'&lt;span class=&quot;ywc-intranet-date-unformatted-date&quot;&gt;'
					,if ($useJavascript = 1) then $dateCreated else substring-before(concat('',$dateCreated),'T')
					,'&lt;/span&gt;'
				)
				" />
			
		<xsl:variable name="meta3" select="
			if (string-length(ywc:getNodeValue(.,'type')) &gt; 0) then ywc:getNodeValue(.,'type')
			else if (string-length(ywc:getNodeValue(.,'location')) &gt; 0) then ywc:getNodeValue(.,'location')
			else if (string-length(ywc:getNodeValue(.,'category')) &gt; 0) then ywc:getNodeValue(.,'category')
			else ''" />
			
		<xsl:variable name="meta4" select="
			if ($duration &gt; 0) then 
				if ($duration &lt; 86400)
						then concat(
							'&lt;span class=&quot;ywc-intranet-date-unformatted-time&quot;&gt;'
							,if ($useJavascript = 1) then $dateExpiration else substring(concat('',$dateExpiration),12,5)
							,'&lt;/span&gt;'
							,' - '
							,'&lt;span class=&quot;ywc-intranet-date-unformatted-time&quot;&gt;'
								,if ($useJavascript = 1) then $dateEnd else substring(concat('',$dateEnd),12,5)
								,'&lt;/span&gt;'
								,' ('
									,'&lt;span class=&quot;ywc-intranet-duration-unformatted&quot;&gt;'
									,$duration,'&lt;/span&gt;'
								,')'
							)
				else concat('until '
					,'&lt;span class=&quot;ywc-intranet-date-unformatted-date&quot;&gt;'
						,if ($useJavascript = 1) then $dateEnd else substring-before(concat('',$dateEnd),'T')
					,'&lt;/span&gt;'
					,' at '
					,'&lt;span class=&quot;ywc-intranet-date-unformatted-time&quot;&gt;'
						,if ($useJavascript = 1) then $dateEnd else substring(concat('',$dateEnd),12,5)
					,'&lt;/span&gt;'
					)			

			else if ($duration = -1) then 'All Day'
					
					
			else if (string-length(ywc:getNodeValue(.,'category')) &gt; 0) then ywc:getNodeValue(.,'category')
			else ''" />

		<xsl:variable name="metaLabel1" select="if (string-length($meta1) != 0) then 'Posted by' else ''" />
		<xsl:variable name="metaLabel2" select="
			if (string-length(ywc:getNodeValue(.,'price')) &gt; 0) then 'Price'
			else if ($dateExpiration &gt; xs:dateTime('1970-01-01T00:00:00Z')) then ''
			else if (string-length(concat(ywc:getNodeValue(.,'created'),ywc:getNodeValue(.,'posted'))) &gt; 0) then 'Created'
			else ''" />
		<xsl:variable name="metaLabel3" select="
			if (string-length(ywc:getNodeValue(.,'type')) &gt; 0) then 'Type'
			else if (string-length(ywc:getNodeValue(.,'location')) &gt; 0) then 'Location'
			else if (string-length(ywc:getNodeValue(.,'category')) &gt; 0) then 'Category'
			else ''" />
		<xsl:variable name="metaLabel4" select="
			if ($duration &gt; 0) then ''
			else if ($duration = -1) then ''
			else if (string-length(ywc:getNodeValue(.,'category')) &gt; 0) then 'Category'
			else ''" />
		
		<xsl:call-template name="ywcIntranetAssetDetail">
			<xsl:with-param name="show" select="1"/>
			<xsl:with-param name="preUri" select="$preUri"/>
			<xsl:with-param name="cssStyle" select="$cssStyle"/>
			<xsl:with-param name="bodyCssStyle" select="$bodyCssStyle"/>
			<xsl:with-param name="listName" select="$listName"/>
			<xsl:with-param name="cacheId" select="$ywcCacheId"/>
			<xsl:with-param name="assetId" select="$assetId"/>
			<xsl:with-param name="width" select="$boxWidth"/>
			<xsl:with-param name="title" select="
					if ($srcXmlProfile = 'ical') then ywc:getNodeValue(.,'summary')
					else ywc:getNodeValue(.,'title')
				"/>
			<xsl:with-param name="thmb" select="
						ywc:getImgUrl(ywc:getNodeValue(.,'attachments'),1)
					"/>
			<xsl:with-param name="thmbLink" select="concat(ywc:getImgUrl(ywc:getNodeValue(.,'attachments'),1),'?size=2048')"/>
			<xsl:with-param name="body" select="
					if ($srcXmlProfile = 'ical') then ywc:getNodeValue(.,'summary')
					else ywc:removeImages(ywc:getNodeValue(.,'body'))
				"/>
			<xsl:with-param name="meta" select="($meta1,$meta2,$meta3,$meta4)" />
			<xsl:with-param name="metaLabels" select="($metaLabel1,$metaLabel2,$metaLabel3,$metaLabel4)" />
			<xsl:with-param name="useJavascript" select="$useJavascript" />
			<xsl:with-param name="toggle-thmb" select="$toggleImages" />
			<xsl:with-param name="domain" select="$domain"/>
			<xsl:with-param name="protocol" select="$protocol"/>
			<xsl:with-param name="currentUser" select="$currentUser"/>
			<xsl:with-param name="author" select="ywc:getNodeValue(.,'author')"/>
			<xsl:with-param name="replyEmail" select="ywc:directoryUserEmail(
				if ($srcXmlProfile = 'drupal') then
					if (string-length(ywc:getNodeValue(.,'authorname')) != 0) then ywc:getNodeValue(.,'authorname')
					else ywc:getNodeValue(.,'author')
				else if ($srcXmlProfile = 'sharepoint') then substring-after(ywc:getNodeValue(.,'author'),';#')
				else ywc:getNodeValue(.,'author')
				)"/>
		</xsl:call-template>
		
		<xsl:if test="$useJavascript = 1">
		<script type="text/javascript"><!--
			-->$(function(){<!--
			--> YWC.f.intranetPostPopupRefine('<xsl:value-of select="$listName" />','<xsl:value-of select="$assetId" />'); <!--
			-->});<!--
		--></script>
		</xsl:if>
	</xsl:for-each>


</xsl:template>

</xsl:stylesheet>