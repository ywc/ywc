<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../../ywc/inc/ywc-core.xsl" />
<xsl:include href="ywc-input-all.xsl" />

<xsl:variable name="template" select="substring-after($uri,'ywc/ui-input/')" />

<xsl:template match="/">

	<xsl:if test="string-length(ywc:getParam('message',$params)) &gt; 0">
		<div class="ywc-input-message" style="font-size:{ywc:getParam('fontSize',$params)}px;">
			<xsl:value-of select="ywc:getParam('message',$params)" disable-output-escaping="yes" />
		</div>
	</xsl:if>

	<xsl:choose>

		<xsl:when test="$template = 'text'">
		
			<xsl:call-template name="ywcInputText">
				<xsl:with-param name="preUri" select="ywc:getParam('preUri',$params)"/>
				<xsl:with-param name="type" select="if (string-length(ywc:getParam('type',$params)) &gt; 0) then ywc:getParam('type',$params) else 'text'"/>
				<xsl:with-param name="id" select="ywc:getParam('id',$params)"/>
				<xsl:with-param name="class" select="ywc:getParam('class',$params)"/>
				<xsl:with-param name="value" select="ywc:getParam('value',$params)"/>
				<xsl:with-param name="placeholder" select="ywc:getParam('placeholder',$params)"/>
				<xsl:with-param name="fontSize" select="if (string-length(ywc:getParam('fontSize',$params)) &gt; 0) then xs:integer(ywc:getParam('fontSize',$params)) else 18"/>
				<xsl:with-param name="eraseBttn" select="if (ywc:getParam('eraseBttn',$params) = '1') then 1 else 0"/>
				<xsl:with-param name="eraseBttnJs" select="ywc:getParam('eraseBttnJs',$params)"/>
				<xsl:with-param name="onLoadJs" select="ywc:getParam('onLoadJs',$params)"/>
				<xsl:with-param name="onTypeJs" select="ywc:getParam('onTypeJs',$params)"/>
				<xsl:with-param name="onTypeJsDelay" select="if (string-length(ywc:getParam('onTypeJsDelay',$params)) &gt; 0) then xs:integer(ywc:getParam('onTypeJsDelay',$params)) else 250"/>
				<xsl:with-param name="onTypeJsMinLength" select="if (string-length(ywc:getParam('onTypeJsMinLength',$params)) &gt; 0) then xs:integer(ywc:getParam('onTypeJsMinLength',$params)) else 3"/>
				<xsl:with-param name="onReturnKeyJs" select="ywc:getParam('onReturnKeyJs',$params)"/>
				<xsl:with-param name="onEscapeKeyJs" select="ywc:getParam('onEscapeKeyJs',$params)"/>
				<xsl:with-param name="readOnly" select="if (ywc:getParam('readOnly',$params) = '1') then 1 else 0"/>
				<xsl:with-param name="autoFocus" select="if (ywc:getParam('autoFocus',$params) = '1') then 1 else 0"/>
				<xsl:with-param name="richText" select="if (string-length(ywc:getParam('richText',$params)) &gt; 0) then xs:integer(ywc:getParam('richText',$params)) else 1"/>
				<xsl:with-param name="icon" select="ywc:getParam('icon',$params)"/>
				<xsl:with-param name="onFocusJs" select="ywc:getParam('onFocusJs',$params)" />
				<xsl:with-param name="onBlurJs" select="ywc:getParam('onBlurJs',$params)"/>
				<xsl:with-param name="onClearJs" select="ywc:getParam('onClearJs',$params)"/>
				<xsl:with-param name="isRequired" select="ywc:getParam('isRequired',$params)"/>
			</xsl:call-template>		
			
		</xsl:when>
		
		<xsl:when test="$template = 'button'">
			
			<xsl:call-template name="ywcInputButton">
				<xsl:with-param name="preUri" select="ywc:getParam('preUri',$params)"/>
				<xsl:with-param name="id" select="ywc:getParam('id',$params)" />
				<xsl:with-param name="class" select="ywc:getParam('class',$params)" />
				<xsl:with-param name="style" select="ywc:getParam('style',$params)" />
				<xsl:with-param name="fontSize" select="if (string-length(ywc:getParam('fontSize',$params)) &gt; 0) then xs:integer(ywc:getParam('fontSize',$params)) else 0"/>
				<xsl:with-param name="onClickJs" select="ywc:getParam('onClickJs',$params)" />
				<xsl:with-param name="isClickable" select="if (ywc:getParam('isClickable',$params) = '0') then 0 else 1"/>
				<xsl:with-param name="isUnClickable" select="if (ywc:getParam('isUnClickable',$params) = '1') then 1 else 0"/>
				<xsl:with-param name="isAlreadyClicked" select="if (ywc:getParam('isAlreadyClicked',$params) = '1') then 1 else 0"/>
				<xsl:with-param name="label" select="ywc:getParam('label',$params)" />
				<xsl:with-param name="labelCircle" select="ywc:getParam('labelCircle',$params)" />				
				<xsl:with-param name="labelAlreadyClicked" select="ywc:getParam('labelAlreadyClicked',$params)" />
				<xsl:with-param name="labelCircleAlreadyClicked" select="ywc:getParam('labelCircleAlreadyClicked',$params)" />
				<xsl:with-param name="classAlreadyClicked" select="ywc:getParam('classAlreadyClicked',$params)" />
			</xsl:call-template>
			
		</xsl:when>
		
		<xsl:when test="$template = 'datetime'">
			
			<xsl:call-template name="ywcInputDateTime">
				<xsl:with-param name="id" select="ywc:getParam('id',$params)" />
				<xsl:with-param name="class" select="ywc:getParam('class',$params)" />
				<xsl:with-param name="type" select="if (string-length(ywc:getParam('type',$params)) &gt; 0) then ywc:getParam('type',$params) else 'datetime'"/>
				<xsl:with-param name="value" select="if (string-length(ywc:getParam('value',$params)) &gt; 0) then ywc:getParam('value',$params) else xs:string(ywc:unixTime())"/>
				<xsl:with-param name="fontSize" select="if (string-length(ywc:getParam('fontSize',$params)) &gt; 0) then xs:integer(ywc:getParam('fontSize',$params)) else 18"/>
				<xsl:with-param name="onChangeJs" select="ywc:getParam('onChangeJs',$params)" />
				<xsl:with-param name="isRequired" select="ywc:getParam('isRequired',$params)"/>
			</xsl:call-template>
			
		</xsl:when>
		
		<xsl:when test="$template = 'checkbox'">
			
			<xsl:variable name="checked" as="xs:integer*">
				<xsl:for-each select="tokenize(ywc:getParam('checked',$params),';')">
					<xsl:value-of select="xs:integer(.)" /></xsl:for-each>
			</xsl:variable>

			<xsl:variable name="values" as="xs:string*">
				<xsl:for-each select="tokenize(replace(ywc:getParam('values',$params),'%26','&amp;'),';')">
					<xsl:value-of select="replace(.,'%3B',';')" /></xsl:for-each>
			</xsl:variable>
			<xsl:variable name="labels" as="xs:string*">
				<xsl:for-each select="tokenize(replace(ywc:getParam('labels',$params),'%26','&amp;'),';')">
					<xsl:value-of select="replace(.,'%3B',';')" /></xsl:for-each>
			</xsl:variable>
			<xsl:variable name="checked" as="xs:integer*">
				<xsl:for-each select="tokenize(ywc:getParam('checked',$params),';')">
					<xsl:value-of select="xs:integer(.)" /></xsl:for-each>
			</xsl:variable>
		
			<xsl:call-template name="ywcInputCheckBox">
				<xsl:with-param name="id" select="ywc:getParam('id',$params)" />
				<xsl:with-param name="class" select="ywc:getParam('class',$params)" />
				<xsl:with-param name="type" select="if (string-length(ywc:getParam('type',$params)) &gt; 0) then ywc:getParam('type',$params) else 'checkbox'"/>
				<xsl:with-param name="fontSize" select="if (string-length(ywc:getParam('fontSize',$params)) &gt; 0) then xs:integer(ywc:getParam('fontSize',$params)) else 16"/>
				<xsl:with-param name="onChangeJs" select="ywc:getParam('onChangeJs',$params)" />
				<xsl:with-param name="onLoadJs" select="ywc:getParam('onLoadJs',$params)" />
				<xsl:with-param name="values" select="$values"/>
				<xsl:with-param name="labels" select="$labels"/>
				<xsl:with-param name="checked" select="$checked"/>
				<xsl:with-param name="isRequired" select="ywc:getParam('isRequired',$params)"/>
			</xsl:call-template>
			
		</xsl:when>
		
		<xsl:when test="$template = 'hidden'">
			
			<xsl:call-template name="ywcInputHidden">
				<xsl:with-param name="id" select="ywc:getParam('id',$params)" />
				<xsl:with-param name="class" select="ywc:getParam('class',$params)" />
				<xsl:with-param name="value" select="ywc:getParam('value',$params)" />
			</xsl:call-template>
			
		</xsl:when>
		
		<xsl:when test="$template = 'select'">
			
			<xsl:variable name="values" as="xs:string*">
				<xsl:for-each select="tokenize(replace(ywc:getParam('values',$params),'%26','&amp;'),';')">
					<xsl:value-of select="replace(.,'%3B',';')" /></xsl:for-each>
			</xsl:variable>
			<xsl:variable name="labels" as="xs:string*">
				<xsl:for-each select="tokenize(replace(ywc:getParam('labels',$params),'%26','&amp;'),';')">
					<xsl:value-of select="replace(.,'%3B',';')" /></xsl:for-each>
			</xsl:variable>			
			
			<xsl:call-template name="ywcInputSelect">
				<xsl:with-param name="id" select="ywc:getParam('id',$params)" />
				<xsl:with-param name="class" select="ywc:getParam('class',$params)" />
				<xsl:with-param name="placeholder" select="ywc:getParam('placeholder',$params)" />
				<xsl:with-param name="values" select="$values" />
				<xsl:with-param name="labels" select="$labels" />
				<xsl:with-param name="selected" select="ywc:getParam('selected',$params)" />
				<xsl:with-param name="menuWidth" select="
					if (string-length(ywc:getParam('menuWidth',$params)) &gt; 0)
						then xs:integer(ywc:getParam('menuWidth',$params))
					else 0" />
				<xsl:with-param name="menuStyle" select="
					if (string-length(ywc:getParam('menuStyle',$params)) &gt; 0)
						then ywc:getParam('menuStyle',$params)
					else 'popup'" />
				<xsl:with-param name="onSelectJs" select="ywc:getParam('onSelectJs',$params)" />
				<xsl:with-param name="onLoadJs" select="ywc:getParam('onLoadJs',$params)" />
				<xsl:with-param name="isRequired" select="ywc:getParam('isRequired',$params)"/>
			</xsl:call-template>

		</xsl:when>
		
		<xsl:when test="$template = 'fileupload'">
			

			<!-- file upload template -->
			
		</xsl:when>
		
		<xsl:otherwise>
			<xsl:value-of select="'YWC: No/Invalid Input Type Specified'" />
		</xsl:otherwise>
		
	</xsl:choose>



</xsl:template>

</xsl:stylesheet>