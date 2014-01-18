<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
	
<xsl:template name="ywcAssetListItem">
<xsl:param name="listName" as="xs:string" select="'listname'" />
<xsl:param name="assetId" as="xs:string" select="'assetid'" />
<xsl:param name="title" as="xs:string" select="''" />
<xsl:param name="titleMaxLength" as="xs:integer" select="0" />
<xsl:param name="body" as="xs:string" select="''" />
<xsl:param name="bodyMaxLength" as="xs:integer" select="0" />
<xsl:param name="clickBodyAction" as="xs:string" select="''" />
<xsl:param name="baseHtml" as="xs:string" select="''" />
<xsl:param name="thmb" as="xs:string" select="''" />
<xsl:param name="thmbAlt" as="xs:string" select="''" />
<xsl:param name="thmbSquareType" as="xs:string" select="''" />
<xsl:param name="thmbAltSquareType" as="xs:string" select="''" />
<xsl:param name="thmbCssClasses" as="xs:string" select="''" />
<xsl:param name="thmbAltCssClasses" as="xs:string" select="''" />
<xsl:param name="clickAltLabel" as="xs:string" select="''" />
<xsl:param name="metaLabel" as="xs:string" select="''" />
<xsl:param name="metaValue" as="xs:string" select="''" />
<xsl:param name="metaValueAsString" as="xs:integer" select="1" />
<xsl:param name="metaAltLabel" as="xs:string" select="''" />
<xsl:param name="metaAltValue" as="xs:string" select="''" />
<xsl:param name="metaAltValueAsString" as="xs:integer" select="1" />
<xsl:param name="metaMaxLength" as="xs:integer" select="0" />
<xsl:param name="metaAltMaxLength" as="xs:integer" select="0" />
<xsl:param name="clickAction" as="xs:string" select="''" />
<xsl:param name="clickTitleAction" as="xs:string" select="''" />
<xsl:param name="clickAltAction" as="xs:string" select="''" />
<xsl:param name="clickAltHtml" as="xs:string" select="''" />
<xsl:param name="hoverOverAction" as="xs:string" select="''" />
<xsl:param name="hoverOutAction" as="xs:string" select="''" />
<xsl:param name="hoverIntent" as="xs:integer" select="1" />
<xsl:param name="hoverState" as="xs:integer" select="0" />
<xsl:param name="thmbHoverOverAction" as="xs:string" select="''" />
<xsl:param name="thmbHoverOutAction" as="xs:string" select="''" />
<xsl:param name="thmbHoverIntent" as="xs:integer" select="1" />
<xsl:param name="thmbHoverState" as="xs:integer" select="0" />
<xsl:param name="visible" as="xs:integer" select="1" />
<xsl:param name="cssClasses" as="xs:string" select="''" />
	
	<xsl:value-of select='concat(
		"YWC.f.assetDisplayData("
		,"&apos;",ywc:escApos($listName),"&apos;,"
		,"&apos;",ywc:escApos($assetId),"&apos;,"
		,"{&apos;visible&apos;:",if ($visible = 1) then "true" else "false"
				
		,if (string-length($title) = 0) then "" else concat(",&apos;title&apos;:&apos;",ywc:escApos(ywc:removeFormatting($title)),"&apos;")
		,if ($titleMaxLength = 0) then "" else concat(",&apos;titleMaxLength&apos;:",$titleMaxLength)
					
		,if (string-length($body) = 0) then "" else concat(",&apos;body&apos;:&apos;",ywc:escApos($body),"&apos;")
		,if ($bodyMaxLength = 0) then "" else concat(",&apos;bodyMaxLength&apos;:",$bodyMaxLength)
				
		,if (string-length($clickBodyAction) = 0) then "" else concat(",&apos;clickBodyAction&apos;:&apos;",ywc:escApos($clickBodyAction),"&apos;")
		,if (string-length($baseHtml) = 0) then "" else concat(",&apos;baseHtml&apos;:&apos;",ywc:escApos($baseHtml),"&apos;")
		,if (string-length($thmb) = 0) then "" else concat(",&apos;thmb&apos;:&apos;",ywc:escApos($thmb),"&apos;")				
		,if (string-length($thmbAlt) = 0) then "" else concat(",&apos;thmbAlt&apos;:&apos;",ywc:escApos($thmbAlt),"&apos;")	
		,if (string-length($thmbSquareType) = 0) then "" else concat(",&apos;thmbSquareType&apos;:&apos;",ywc:escApos($thmbSquareType),"&apos;")
		,if (string-length($thmbAltSquareType) = 0) then "" else concat(",&apos;thmbAltSquareType&apos;:&apos;",ywc:escApos($thmbAltSquareType),"&apos;")

		,if (string-length($thmbCssClasses) = 0) then "" else concat(",&apos;thmbCssClasses&apos;:&apos;",ywc:escApos($thmbCssClasses),"&apos;")		
		,if (string-length($thmbAltCssClasses) = 0) then "" else concat(",&apos;thmbAltCssClasses&apos;:&apos;",ywc:escApos($thmbAltCssClasses),"&apos;")

		,if (string-length($clickAltLabel) = 0) then "" else concat(",&apos;clickAltLabel&apos;:&apos;",ywc:escApos($clickAltLabel),"&apos;")		
		,if (string-length($metaLabel) = 0) then "" else concat(",&apos;metaLabel&apos;:&apos;",ywc:escApos($metaLabel),"&apos;")		
		,if (string-length($metaValue) = 0) then "" else concat(",&apos;metaValue&apos;:"
			,if ($metaValueAsString = 1) then concat("&apos;",ywc:escApos(ywc:removeFormatting($metaValue)),"&apos;")
				else $metaValue
			)	
		,if (string-length($metaAltLabel) = 0) then "" else concat(",&apos;metaAltLabel&apos;:&apos;",ywc:escApos($metaAltLabel),"&apos;")
		,if (string-length($metaAltValue) = 0) then "" else concat(",&apos;metaAltValue&apos;:"
			,if ($metaAltValueAsString = 1) then concat("&apos;",ywc:escApos(ywc:removeFormatting($metaAltValue)),"&apos;")
				else $metaAltValue
			)	
		,if ($metaMaxLength = 0) then "" else concat(",&apos;metaMaxLength&apos;:",$metaMaxLength)	
		,if ($metaAltMaxLength = 0) then "" else concat(",&apos;metaAltMaxLength&apos;:",$metaAltMaxLength)

		,if (string-length($clickAction) = 0) then "" else concat(",&apos;clickAction&apos;:&apos;",ywc:escApos($clickAction),"&apos;")
		,if (string-length($clickTitleAction) = 0) then "" else concat(",&apos;clickTitleAction&apos;:&apos;",ywc:escApos($clickTitleAction),"&apos;")
		,if (string-length($clickAltAction) = 0) then "" else concat(",&apos;clickAltAction&apos;:&apos;",ywc:escApos($clickAltAction),"&apos;")
		,if (string-length($clickAltHtml) = 0) then "" else concat(",&apos;clickAltHtml&apos;:&apos;",ywc:escApos($clickAltHtml),"&apos;")		

		,if (string-length($hoverOverAction) = 0) then "" else concat(",&apos;hoverOverAction&apos;:&apos;",ywc:escApos($hoverOverAction),"&apos;")	
		,if (string-length($hoverOutAction) = 0) then "" else concat(",&apos;hoverOutAction&apos;:&apos;",ywc:escApos($hoverOutAction),"&apos;")
		,if ($hoverIntent = 1) then "" else ",&apos;hoverIntent&apos;:false"
		,if ($hoverState = 0) then "" else ",&apos;hoverState&apos;:true"
		,if (string-length($thmbHoverOverAction) = 0) then "" else concat(",&apos;thmbHoverOverAction&apos;:&apos;",ywc:escApos($thmbHoverOverAction),"&apos;")	
		,if (string-length($thmbHoverOutAction) = 0) then "" else concat(",&apos;thmbHoverOutAction&apos;:&apos;",ywc:escApos($thmbHoverOutAction),"&apos;")

		,if ($thmbHoverIntent = 1) then "" else ",&apos;thmbHoverIntent&apos;:false"
		,if ($thmbHoverState = 0) then "" else ",&apos;thmbHoverState&apos;:true"
		
		,if (string-length($cssClasses) = 0) then "" else concat(",&apos;cssClasses&apos;:&apos;",ywc:escApos($cssClasses),"&apos;")
				
		,"});")' disable-output-escaping="yes" />
	
</xsl:template>

</xsl:stylesheet>