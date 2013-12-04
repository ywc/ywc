<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:param name="user" as="xs:string" select="''" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../../ywc/1.0/inc/ywc-core.xsl" />
<xsl:include href="../../../ywc/1.0/inc/ywc-convert.xsl" />
<xsl:include href="../inc/ywc-intranet-directory.xsl" />
<xsl:include href="../../../ywc/1.0/ui-elements/ywc-header.xsl" />
<xsl:include href="../../../ywc/1.0/ui-input/ywc-input-all.xsl" />

<xsl:variable name="preUri" select="ywc:getParam('preUri',$params)"/>
<xsl:variable name="listName" select="ywc:getParam('listName',$params)"/>
<xsl:variable name="assetId" select="ywc:getParam('assetId',$params)"/>
<xsl:variable name="srcIdName" select="ywc:getParam('srcIdName',$params)"/>
<xsl:variable name="srcIdVal" select="ywc:getParam('srcIdVal',$params)"/>
<xsl:variable name="popupWidth" select="ywc:getParam('popupWidth',$params)" />
<xsl:variable name="uiHeaderColor" select="ywc:getParam('uiHeaderColor',$params)" />
<xsl:variable name="uiHeaderBgColor" select="ywc:getParam('uiHeaderBgColor',$params)" />
<xsl:variable name="uriUploadFile" select="ywc:getParam('uriUploadFile',$params)" />

<xsl:variable name="fontSize" select="14" />
<xsl:variable name="autoExpire" as="xs:integer" select="
	if ($listName = 'marketplace') then (180*86400*1000)
	else (7*86400*1000)
	" />
	
<xsl:template match="/">
	
	<table class="ywc-intranet-asset-edit">

	
	<xsl:for-each select="ywc/cache[@name=$listName]">
		<tr>
			<td colspan="2">
				<xsl:call-template name="ywcHeader">
					<xsl:with-param name="preUri" select="$preUri"/>
					<xsl:with-param name="text" select="lower-case(@title)"/>
					<xsl:with-param name="width" select="120"/>
					<xsl:with-param name="fontsize" select="36"/>
					<xsl:with-param name="color" select="$uiHeaderColor"/>
					<xsl:with-param name="bg-color" select="$uiHeaderBgColor"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:for-each>


	
	<xsl:call-template name="ywcInputHidden">
		<xsl:with-param name="id" select="concat($listName,'-author')" />
		<xsl:with-param name="value" select="
					if (string-length(ywc:getNodeValue(.,'author')) = 0) then $user
					else ywc:getNodeValue(.,'author')
					" />
	</xsl:call-template>
	
	
	<xsl:variable as="xs:string" name="ywcCacheId">
		<xsl:for-each select="ywc/cache[lower-case(@name)=lower-case($listName)]">
			<xsl:value-of select="@cache_id" />
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="srcXml" select="
				document(concat('../../../../cache/xml/'
				,if (contains($ywcCacheId,'..')) then 'core/blank'
				else concat('cache/',$ywcCacheId)
				,'.xml'))" />
				
	
	<xsl:variable name="submitJs" select='concat(
							"YWC.f.intranetPostSubmit("
							,"&apos;",$listName,"&apos;"
							,",&apos;",$assetId,"&apos;"
							,",&apos;",$ywcCacheId,"&apos;"
							,");")' />
	
	
	<xsl:variable name="srcNode" select="
			if (string-length($assetId) &gt; 0) then
			(	$srcXml/nodes/node
			|	$srcXml/rs:data/z:row
			)[	(ywc:getNodeValue(.,'id') = $assetId)
			or 	(ywc:getNodeValue(.,'nid') = $assetId)
			]
			else $srcXml/emptynode
			" />			
	
		
	<!-- Cancel / Submit Buttons -->
		<tr>
			<td colspan="2">
				
				<span style="position:relative;float:right;">
				<xsl:call-template name="ywcInputButton">
					<xsl:with-param name="id" select="concat($listName,'-submit-top')" />
					<xsl:with-param name="label" select="'Save'" />
					<xsl:with-param name="labelAlreadyClicked" select="'Saving...'" />
					<xsl:with-param name="fontSize" select="20" />
					<xsl:with-param name="onClickJs" select='$submitJs' />
				</xsl:call-template>
				</span>
				
				<span style="position:relative;float:right;margin-right:20px;margin-top:12px;">
				<xsl:call-template name="ywcInputButton">
					<xsl:with-param name="id" select="concat($listName,'-cancel-top')" />
					<xsl:with-param name="label" select="'Cancel'" />
					<xsl:with-param name="fontSize" select="14" />
					<xsl:with-param name="onClickJs" select='"YWC.f.popupKill(1);"' />
				</xsl:call-template>
				</span>
				
				
			</td>
		</tr>

		<!-- Title -->
		<tr>
			<td class="label">
				<label style="font-size:{$fontSize}px;"
					for="ywc-input-text-{$listName}-title">
					<xsl:value-of select="
						if (string-length(ywc:getParam('labelTitle',$params)) &gt; 0) then ywc:getParam('labelTitle',$params)
						else 'Title'
					" />:</label>
			</td>
			<td class="input"><div style="width:115%;">
				
				<xsl:call-template name="ywcInputText">
					<xsl:with-param name="preUri" select="$preUri"/>
					<xsl:with-param name="id" select="concat($listName,'-title')"/>
					<xsl:with-param name="placeholder" select="'The title of this posting...'"/>
					<xsl:with-param name="value" select="concat('',
						if (string-length(ywc:getParam('valueTitle',$params)) &gt; 0) then ywc:getParam('valueTitle',$params)
						else if (string-length(ywc:getNodeValue($srcNode,'title')) &gt; 0) then ywc:getNodeValue($srcNode,'title')
						else ''
						)"/>
					<xsl:with-param name="fontSize" select="($fontSize+4)"/>
					<xsl:with-param name="eraseBttn" select="if (contains($listName,'questions')) then 0 else 1"/>
					<xsl:with-param name="readOnly" select="if (contains($listName,'questions')) then 1 else 0"/>
					<xsl:with-param name="eraseBttnJs" select="''"/>
				</xsl:call-template>
			
			</div></td>
		</tr>
		
		
		
		<!-- Type (marketplace / community) -->
		<xsl:if test="($listName = 'marketplace') or ($listName = 'community')">
		<tr>
			<td class="label">
				<label style="font-size:{$fontSize}px;"
					for="ywc-input-text-{$listName}-type">Type:</label>
			</td>
			<td class="input" style="border-bottom:solid 1px #dddddd;">

				<xsl:variable name="valuesType" as="xs:string*" select="
					if ($listName = 'marketplace') then (
						'I am offering or selling something...'
						,'I am searching for something...'
						,'I am recommending something...'
						)
					else if ($listName = 'community') then (
						'Recommendation'
						,'Question'
						,'Other'
					)
					else ()" />
					
				<xsl:variable name="checkedTypeValue" select="	concat('',
					if (string-length(ywc:getParam('valueType',$params)) &gt; 0) then ywc:getParam('valueType',$params)
					else if (string-length(ywc:getNodeValue($srcNode,'type')) &gt; 0) then ywc:getNodeValue($srcNode,'type')
					else ''
					)" />
				
				<xsl:variable name="checkedType" as="xs:integer*">
					<xsl:for-each select="$valuesType">
						<xsl:value-of select="
							if (lower-case(.) = lower-case($checkedTypeValue)) then 1
							else 0
						" />
					</xsl:for-each>
				</xsl:variable>	
					
				<xsl:call-template name="ywcInputCheckBox">
					<xsl:with-param name="type" select="'radio'"/>
					<xsl:with-param name="id" select="concat($listName,'-type')"/>
					<xsl:with-param name="values" select="$valuesType"/>
					<xsl:with-param name="checked" select="$checkedType"/>
				</xsl:call-template>
			
			</td>
		</tr>
		</xsl:if>		



	

		<!-- Category (marketplace) -->
		<xsl:if test="($listName = 'marketplace') or ($listName = 'community')">
		<tr>
			<td class="label">
				<label style="font-size:{$fontSize}px;"
					for="ywc-input-text-{$listName}-category">Category:</label>
			</td>
			<td class="input">
				
				<xsl:variable name="valuesCategory" as="xs:string*" select="
					if ($listName = 'marketplace') then (
						'Housing / Accommodation'
						,'Service(s)'
						,'Vehicle / Accessories'
						,'Other Item(s)'
					)
					else if ($listName = 'community') then (
						'Education'
						,'Cooking'
						,'Housing'
						,'Medical'
						,'Recreation'
						,'Restaurants'
						,'Shopping'
						,'Sports'
						,'Travel'
						,'Other'
					)
					else ()" />
				
				<xsl:variable name="checkedCategoryValue" select="	concat('',
						if (string-length(ywc:getParam('valueCategory',$params)) &gt; 0) then ywc:getParam('valueCategory',$params)
						else if (string-length(ywc:getNodeValue($srcNode,'category')) &gt; 0) then ywc:getNodeValue($srcNode,'category')
						else ''
					)" />
				
				<xsl:variable name="checkedCategory" as="xs:integer*">
					<xsl:for-each select="$valuesCategory">
						<xsl:value-of select="
							if (lower-case(.) = lower-case($checkedCategoryValue)) then 1
							else 0
						" />
					</xsl:for-each>
				</xsl:variable>
				
				<xsl:choose>
				<xsl:when test="$listName = 'marketplace'">
					<xsl:call-template name="ywcInputCheckBox">
						<xsl:with-param name="type" select="'radio'"/>
						<xsl:with-param name="id" select="concat($listName,'-category')"/>
						<xsl:with-param name="values" select="$valuesCategory"/>
						<xsl:with-param name="checked" select="$checkedCategory"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$listName = 'community'">
					<xsl:call-template name="ywcInputSelect">
						<xsl:with-param name="id" select="concat($listName,'-category')"/>
						<xsl:with-param name="values" select="$valuesCategory"/>
						<xsl:with-param name="placeholder" select="'Choose a Category'"/>
						<xsl:with-param name="labels" select="$valuesCategory"/>
						<xsl:with-param name="selected" select="$checkedCategoryValue"/>
						<xsl:with-param name="menuWidth" select="200"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
		</xsl:if>		
		

		<!-- Price -->
		<xsl:if test="$listName = 'marketplace'">
		<tr>
			<td class="label">
				<label style="font-size:{$fontSize}px;"
					for="ywc-input-text-{$listName}-price">Price:</label>
			</td>
			<td class="input">
				
				<xsl:call-template name="ywcInputText">
					<xsl:with-param name="preUri" select="$preUri"/>
					<xsl:with-param name="style" select="'width:33%;'"/>
					<xsl:with-param name="id" select="concat($listName,'-price')"/>
					<xsl:with-param name="placeholder" select="'Price'"/>
					<xsl:with-param name="value" select="concat('',
						if (string-length(ywc:getParam('valuePrice',$params)) &gt; 0) then ywc:getParam('valuePrice',$params)
						else if (string-length(ywc:getNodeValue($srcNode,'price')) &gt; 0) then ywc:getNodeValue($srcNode,'price')
						else ''
					)"/>
					<xsl:with-param name="fontSize" select="($fontSize+2)"/>
					<xsl:with-param name="eraseBttn" select="1"/>
					<xsl:with-param name="eraseBttnJs" select="''"/>
				</xsl:call-template>
			
			</td>
		</tr>
		</xsl:if>



		<!-- Start Date/Time -->
		<xsl:if test="$listName = 'events'">
		<tr>
			<td class="label">
				<label style="font-size:{$fontSize}px;"
					for="ywc-input-text-{$listName}-start">Start Time:</label>
			</td>
			<td class="input">
				
				<xsl:call-template name="ywcInputDateTime">
					<xsl:with-param name="id" select="concat($listName,'-start')"/>
					<xsl:with-param name="value" select="concat('',
						if (string-length(ywc:getParam('valueStart',$params)) &gt; 0) then ywc:getParam('valueStart',$params)
						else if (string-length(ywc:getNodeValue($srcNode,'start')) &gt; 0) then ywc:getNodeValue($srcNode,'start')
						else if (string-length(ywc:getNodeValue($srcNode,'start-date')) &gt; 0) then ywc:getNodeValue($srcNode,'start-date')
						else xs:string(ywc:unixTime() + 3600*1000)
					)"/>
					<xsl:with-param name="type" select="'datetime'"/>
					<xsl:with-param name="fontSize" select="16"/>
				</xsl:call-template>
			
			</td>
		</tr>
		</xsl:if>
		

		<!-- End Date/Time -->
		<xsl:if test="$listName = 'events'">
		<tr>
			<td class="label">
				<label style="font-size:{$fontSize}px;"
					for="ywc-input-text-{$listName}-end">End Time:</label>
			</td>
			<td class="input">
				
				<xsl:variable name="valueDuration" as="xs:integer" select="xs:integer(ywc:removeSpace(concat('',
					if (string-length(ywc:getParam('valueDuration',$params)) &gt; 0) then ywc:getParam('valueDuration',$params)
					else if (string-length(ywc:getNodeValue($srcNode,'duration')) &gt; 0) then ywc:getNodeValue($srcNode,'duration')
					else xs:string(7200*1000)
				)))" />
				
				<!-- this whole part is rather complicated (duration -> end time) and should be improved as much as possible -->
				
				<xsl:call-template name="ywcInputDateTime">
					<xsl:with-param name="id" select="concat($listName,'-end')"/>
					<xsl:with-param name="value" select="concat('',
						if (string-length(ywc:getParam('valueStart',$params)) &gt; 0)
							then ywc:getParam('valueStart',$params)
						else if (string-length(ywc:getNodeValue($srcNode,'start')) &gt; 0)
							then ywc:getNodeValue($srcNode,'start')
						else if (string-length(ywc:getNodeValue($srcNode,'start_datetime')) &gt; 0)
							then xs:string((xs:integer(ywc:getNodeValue($srcNode,'start_datetime')) + $valueDuration) * 1000)
						else xs:string(ywc:unixTime() + 7200*1000)
					)"/>
					<xsl:with-param name="type" select="'datetime'"/>
					<xsl:with-param name="fontSize" select="16"/>
					<xsl:with-param name="onChangeJs" select='concat(
							"YWC.f.intranetPopupPostEditDurationCheck(&apos;",$listName,"&apos;);")'/>
				</xsl:call-template>
			
			</td>
		</tr>
		</xsl:if>		


		<!-- Location -->
		<xsl:if test="$listName = 'events'">
		<tr>
			<td class="label">
				<label style="font-size:{$fontSize}px;"
					for="ywc-input-text-{$listName}-location">Location:</label>
			</td>
			<td class="input"><div style="width:115%;">
				
				<xsl:call-template name="ywcInputText">
					<xsl:with-param name="preUri" select="$preUri"/>
					<xsl:with-param name="id" select="concat($listName,'-location')"/>
					<xsl:with-param name="placeholder" select="'Does this event have a location?'"/>
					<xsl:with-param name="value" select="concat('',
						if (string-length(ywc:getParam('valueLocation',$params)) &gt; 0) then ywc:getParam('valueLocation',$params)
						else if (string-length(ywc:getNodeValue($srcNode,'location')) &gt; 0) then ywc:getNodeValue($srcNode,'location')
						else ''
					)"/>
					<xsl:with-param name="fontSize" select="($fontSize+2)"/>
					<xsl:with-param name="eraseBttn" select="1"/>
					<xsl:with-param name="eraseBttnJs" select="''"/>
				</xsl:call-template>
			
			</div></td>
		</tr>
		</xsl:if>		
		
		
		<!-- Body Text -->
		<tr>
			<td class="label">
				<label style="font-size:{$fontSize}px;"
					for="ywc-input-text-{$listName}-body">
					<xsl:value-of select="
						if (string-length(ywc:getParam('labelBody',$params)) &gt; 0) then ywc:getParam('labelBody',$params)
						else 'Description'
					" />:</label>
			</td>
			<td class="input">
				
				<xsl:call-template name="ywcInputText">
					<xsl:with-param name="preUri" select="$preUri"/>
					<xsl:with-param name="type" select="'textarea'"/>
					<xsl:with-param name="id" select="concat($listName,'-body')"/>
					<xsl:with-param name="richText" select="if (contains($listName,'questions')) then 0 else 1"/>
					<xsl:with-param name="fontSize" select="$fontSize"/>
					
 					<xsl:with-param name="value" select="concat('',ywc:removeNewLine(
						if (string-length(ywc:getParam('valueBody',$params)) &gt; 0) then ywc:getParam('valueBody',$params)
						else if (string-length(ywc:getNodeValue($srcNode,'body')) &gt; 0) then ywc:getNodeValue($srcNode,'body')
						else ''
					))"/>

				</xsl:call-template>

			</td>
		</tr>
		

		<!-- Attachment Input -->
		<xsl:if test="not(contains($listName,'questions'))">
		<tr>
			<td class="label">
				<span style="display:none;">.</span>
			</td>
			<td class="input">
				<xsl:value-of select="concat(''
					,'&lt;div class=&quot;'
						,'ywc-container-vertical-list ywc-container-vertical-list-attachments-',$listName,'-edit'
						,'&quot;&gt;&lt;/div&gt;'
					)" disable-output-escaping="yes" />
				<script type="text/javascript"><!--
					-->$(function(){<!--
						-->YWC.input.value.file['<xsl:value-of select="ywc:escApos($listName)" />-upload'] = [];<!--
						-->YWC.f.intranetPostEditAttachmentsList(<!--
							-->'<xsl:value-of select="ywc:escApos($listName)" />'<!--
							-->,'<xsl:value-of select="ywc:escApos($assetId)" />'<!--
							-->,false<!--
						-->);<!--
					-->});<!--
				--></script>
			</td>
		</tr>

		<tr>
			<td class="label">
				<label style="font-size:{$fontSize}px;"
					for="ywc-input-text-{$listName}-upload">Upload:</label>
			</td>
			<td class="input">
				
				<xsl:call-template name="ywcInputFileUpload">
					<xsl:with-param name="preUri" select="$preUri" />
					<xsl:with-param name="id" select="concat($listName,'-upload')"/>
					<xsl:with-param name="onSuccessJs" select='concat(
								"YWC.f.intranetPostEditAttachmentsList("
									,"&apos;",$listName,"&apos;"
									,",&apos;",$assetId,"&apos;"
									,",true);")' />
					<xsl:with-param name="targetUri" select="$uriUploadFile" />				
					<xsl:with-param name="paramNames" select="('listName','assetId')" />
					<xsl:with-param name="paramValues" select="($listName,$assetId)" />
				</xsl:call-template>
			
			</td>
		</tr>
		</xsl:if>


		<!-- Expiration Date -->
		<xsl:if test="not(contains($listName,'questions')) and not(contains($listName,'events'))">
		<tr>
			<td class="label">
				<label style="font-size:{$fontSize}px;"
					for="ywc-input-text-{$listName}-expires">Visible Until:</label>
			</td>
			<td class="input">
				
				<xsl:call-template name="ywcInputDateTime">
					<xsl:with-param name="id" select="concat($listName,'-expires')"/>
					<xsl:with-param name="value" select="concat('',
						if (string-length(ywc:getParam('valueExpires',$params)) &gt; 0) then ywc:getParam('valueExpires',$params)
						else if (string-length(ywc:getNodeValue($srcNode,'expires')) &gt; 0) then ywc:getNodeValue($srcNode,'expires')
						else xs:string(ywc:unixTime() + $autoExpire)
					)"/>
					<xsl:with-param name="type" select="'date'"/>
					<xsl:with-param name="fontSize" select="16"/>
				</xsl:call-template>
			
			</td>
		</tr>
		</xsl:if>


		<!-- Cancel / Submit Buttons -->
		<tr>
			<td colspan="2" style="border-bottom:solid 1px #dddddd;padding-bottom:5px;">

				<span style="position:relative;float:right;">
					<xsl:call-template name="ywcInputButton">
						<xsl:with-param name="id" select="concat($listName,'-submit-bottom')" />
						<xsl:with-param name="label" select="'Save'" />
						<xsl:with-param name="labelAlreadyClicked" select="'Saving...'" />
						<xsl:with-param name="fontSize" select="20" />
						<xsl:with-param name="onClickJs" select='$submitJs' />
					</xsl:call-template>
				</span>
				
				<span style="position:relative;float:right;margin-right:20px;margin-top:12px;">
					<xsl:call-template name="ywcInputButton">
						<xsl:with-param name="id" select="concat($listName,'-cancel-bottom')" />
						<xsl:with-param name="label" select="'Cancel'" />
						<xsl:with-param name="fontSize" select="14" />
						<xsl:with-param name="onClickJs" select='"YWC.f.popupKill(1);"' />
					</xsl:call-template>
				</span>


			</td>
		</tr>


	</table>
	
	
				
				
<!--
	<xsl:for-each select="
			(	$srcXml/nodes/node
			|	$srcXml/rs:data/z:row
			)/(*|@*)[
				(lower-case(name())=lower-case($srcIdName)) or (lower-case(substring-after(name(),'ows_'))=lower-case($srcIdName))
			][.=$srcIdVal]/..
		">

	<xsl:variable name="srcXmlProfile" select="
			if (count($srcXml/nodes) &gt; 0) then 'drupal'
			else if (count($srcXml/rs:data) &gt; 0) then 'sharepoint'
			else if (count($srcXml/users) &gt; 0) then 'directory'
			else ''
			" />
		
	</xsl:for-each>
-->

	
	

</xsl:template>

</xsl:stylesheet>
