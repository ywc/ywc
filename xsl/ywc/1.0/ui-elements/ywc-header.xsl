<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">

<xsl:include href="../ui-elements/ywc-image-text.xsl" />

<xsl:template name="ywcHeader">
<xsl:param name="preUri" as="xs:string" select="'/'"/>
<xsl:param name="text" as="xs:string" select="'ywc-header'"/>
<xsl:param name="fontsize" as="xs:integer" select="24"/>
<xsl:param name="font" as="xs:string" select="'frutiger75'"/>
<xsl:param name="width" as="xs:integer" select="200"/>
<xsl:param name="color" as="xs:string" select="'bbbbbb'"/>
<xsl:param name="bg-color" as="xs:string" select="'444444'"/>
<xsl:param name="useStroke" as="xs:integer" select="1"/>
<xsl:param name="useImgText" as="xs:integer" select="0"/>

<xsl:variable name="stroke" select="concat(substring($color,1,1),'0',substring($color,3,1),'0',substring($color,5,1),'0')" />
		
		<div class="ywc-header ywc-unselectable ywc-crnr-5" style="background-color:#{$bg-color};min-width:{$width}px;height:{$fontsize+5}px;" unselectable="on">
		
		<img class="ywc-header-bg ywc-unselectable ywc-crnr-5 ywc-crnr-r-off" src="{$preUri}img/special/header/{$bg-color}.png" style="height:{$fontsize+5}px;background-color:#{$color};" />
			
		<xsl:choose>
			<xsl:when test="$useImgText = 1">
		 		<xsl:call-template name="ywcImageText">
					<xsl:with-param name="preUri" select="$preUri"/>
					<xsl:with-param name="text" select="$text"/>
					<xsl:with-param name="fill" select='"ffffff"'/>
					<xsl:with-param name="font" select='$font'/>
					<xsl:with-param name="background" select='$color'/>
					<xsl:with-param name="stroke" select='$stroke'/>
					<xsl:with-param name="strokewidth" select='1'/>
					<xsl:with-param name="fontsize" select='$fontsize'/>
					<xsl:with-param name="height" select='concat($fontsize,"px")'/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<span class="ywc-header-txt {$font}" style="font-size:{round($fontsize*0.95)}px;color:#ffffff;padding-top:{2+round(0.05*$fontsize)}px;padding-left:10px;">
					<xsl:value-of select="$text" />
				</span>
			</xsl:otherwise>
		
		</xsl:choose>
		
	</div>
			

</xsl:template>


</xsl:stylesheet>