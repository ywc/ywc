<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">


<xsl:template name="ywcInputKudos">
<xsl:param name="preUri" as="xs:string" select="'/'" />
<xsl:param name="id" as="xs:string" select="''" />
<xsl:param name="class" as="xs:string" select="''" />
<xsl:param name="style" as="xs:string" select="''" />
<xsl:param name="fontSize" as="xs:integer" select="0" />
<xsl:param name="onClickJs" as="xs:string" select="''" />
<xsl:param name="isClickable" as="xs:integer" select="1" />
<xsl:param name="isUnClickable" as="xs:integer" select="0" />
<xsl:param name="isAlreadyClicked" as="xs:integer" select="0" />
<xsl:param name="label" as="xs:string" select="''" />
<xsl:param name="labelCircle" as="xs:string" select="''" />
<xsl:param name="labelAlreadyClicked" as="xs:string" select="''" />
<xsl:param name="labelCircleAlreadyClicked" as="xs:string" select="''" />
<xsl:param name="classAlreadyClicked" as="xs:string" select="''" />
<xsl:param name="classToggleOnHover" as="xs:string" select="''" />

	<xsl:variable name="a" select='"&apos;"' />
	
	<xsl:variable name="bttnId" select=" if (string-length($id) &gt; 0) then $id
		else concat('_',replace(replace(substring-before(xs:string(current-time()),'-'),'\.',''),':',''))" />
	
	<!-- some defaults with many possible values are set here to avoid putting verbose fallback logic elsewhere in the ywc core -->
	<!-- set default label text -->
	<xsl:variable name="labelDefault" select="if (string-length($label) &gt; 0) then $label else 'Submit'" />
	<!-- set default label font size -->
	<xsl:variable name="labelFontSize" select="if ($fontSize = 0) then 24 else $fontSize" />
	<!-- set default css class for clicked state -->
	<xsl:variable name="classOnClick" select="if (string-length($classAlreadyClicked) &gt; 0) then $classAlreadyClicked else 'ywc-gradient-gray-02'" />	
	<!-- set toggled css class for mouse hover -->	
	<xsl:variable name="classOnHover" select="if (string-length($classToggleOnHover) &gt; 0) then $classToggleOnHover else 'ywc-gradient-gray-01'" />
	<!-- pre calculate vertical padding for button -->
	<xsl:variable name="padding" select="round($labelFontSize div 2)" />
<!-- 		
	<div id="ywc-input-button-{$bttnId}" 
		class="ywc-unselectable ywc-crnr-5 ywc-shdw-box-ccc ywc-shdw-txt-fff ywc-gradient-gray-01 {
			if ($isAlreadyClicked = 1) then $classOnClick else ''
			} ywc-input-button {$class} ywc-gradient" 
		style="padding:0px {$labelFontSize}px;height:{2*$labelFontSize}px;{
			if ($isClickable = 0) then 'cursor:default;' else ''
			}{$style};" 
		onMouseOver="{if ($isClickable = 1) then concat('YWC.f.uiDoClassToggle(this,',$a,$classOnHover,$a,')') else ''}"
		onMouseOut="{if ($isClickable = 1) then concat('YWC.f.uiDoClassToggle(this,',$a,$classOnHover,$a,')') else ''}"
		onClick="if(YWC.f.inputButtonClick(this)){'{'}{replace($onClickJs,'&quot;','\\&quot;')};{'}'}">
				<span class="ywc-input-button-label {if ($isAlreadyClicked = 1) then 'ywc-input-button-label-on' else ''}"
					style="{if (string-length($labelCircle) &gt; 0)
						then concat('left:-',(($labelFontSize + $padding) * .6),'px;') else ''}font-size:{$labelFontSize}px;">
					<xsl:value-of select="
						if (($isAlreadyClicked = 0) or (string-length($labelAlreadyClicked) = 0))
							then $labelDefault else $labelAlreadyClicked" />
				</span>
		
		<xsl:if test="(string-length($labelCircle) &gt; 0)">
			<div class="ywc-input-button-circle"
				style="height:{($labelFontSize + $padding)}px;width:{($labelFontSize + $padding)}px;top:{($padding - round($padding div 2))}px;">
				<img src="{$preUri}public/ywc-image/bttn/ywc/circle-gray-01{
					if ($isAlreadyClicked = 1) then '_' else ''
				}.png" />
				<div style="font-size:{round($labelFontSize * .6)}px;top:{round(($labelFontSize + $padding) * .33)}px;">
					<xsl:value-of select="if (($isAlreadyClicked = 0) or (string-length($labelCircleAlreadyClicked) = 0)) then $labelCircle else $labelCircleAlreadyClicked" />
				</div>
			</div>
		</xsl:if>
	
	</div>
	
	<xsl:value-of select="concat(''
		,'&lt;script type=&quot;text/javascript&quot;&gt;'
		,'$(function(){'
			
			,'YWC.input.value.button[&quot;',replace($bttnId,'&quot;','\\&quot;'),'&quot;]='
					,if ($isAlreadyClicked = 1) then 'true' else 'false',';'
			
			,'if(YWC.input.meta.button==null){YWC.input.meta.button={};}'
			,'YWC.input.meta.button[&quot;',replace($bttnId,'&quot;','\\&quot;'),'&quot;]={'
				,'&quot;isUnClickable&quot;:',if ($isUnClickable = 1) then 'true' else 'false'
				,',&quot;isClickable&quot;:',if ($isClickable = 1) then 'true' else 'false'
				,',&quot;label&quot;:['
					,'&quot;',replace($labelDefault,'&quot;','\\&quot;'),'&quot;'
					,',&quot;',replace($labelAlreadyClicked,'&quot;','\\&quot;'),'&quot;'
				,']'
				,',&quot;labelCircle&quot;:['
					,'&quot;',replace($labelCircle,'&quot;','\\&quot;'),'&quot;'
					,',&quot;',replace($labelCircleAlreadyClicked,'&quot;','\\&quot;'),'&quot;'
				,']'
				,',&quot;classAlreadyClicked&quot;:&quot;',replace($classOnClick,'&quot;','\\&quot;'),'&quot;'
			,'};'
			
		,'});'
	,'&lt;/script&gt;'
	
	)" disable-output-escaping="yes" />
	 -->
</xsl:template>

</xsl:stylesheet>