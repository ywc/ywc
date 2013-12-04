<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">

<xsl:function name="ywc:escQuot" as="xs:string">
	<xsl:param name="text" as="xs:string" />
	<xsl:value-of select="replace($text,'&quot;','\\&quot;')" disable-output-escaping="yes" />
</xsl:function>

<xsl:function name="ywc:escApos" as="xs:string">
	<xsl:param name="text" as="xs:string" />
	<xsl:value-of select='replace($text,"&apos;","\\&apos;")' disable-output-escaping="yes" />
</xsl:function>

<xsl:function name="ywc:escTags" as="xs:string">
	<xsl:param name="text" as="xs:string" />
	<xsl:variable name="gtLt" select='replace(replace($text,"&gt;","&amp;gt;"),"&lt;","&amp;lt;")' />
	<xsl:value-of select="replace($gtLt,'&quot;','&amp;quot;')" disable-output-escaping="yes" />
</xsl:function>

<xsl:function name="ywc:removeSpace" as="xs:string">
	<xsl:param name="text" as="xs:string" />
	<xsl:value-of select='replace($text," ","")' disable-output-escaping="yes" />
</xsl:function>

<xsl:function name="ywc:removeNewLine" as="xs:string">
	<xsl:param name="text" as="xs:string" />
	<xsl:value-of select='replace(replace(replace($text,"&#xA;",""),"&#10;",""),"&#13;","")' disable-output-escaping="yes" />
</xsl:function>

<xsl:template name="ywcStoreObjectAsJavascript">
<xsl:param name="node" select="." />
<xsl:param name="assetId" as="xs:string" select="'_error'" />
<xsl:param name="extraIndex" as="xs:string*" select="()" />
<xsl:param name="extraValue" as="xs:string*" select="()" />
<xsl:param name="omit" as="xs:string*" select="()" />
<xsl:param name="only" as="xs:string*" select="()" />

<xsl:value-of select='concat(" YWC.f.assetSetData(&apos;",$assetId,"&apos;"
	,",{")' />

	<xsl:for-each select="
			if (count($only) = 0)
				then (*|@*)
					[	not(exists(index-of($omit,lower-case(name()))))
					and not(exists(index-of($omit,lower-case(substring-after(name(),'ows_')))))
					]
			else (*|@*)[exists(index-of($only,lower-case(name())))]
			">
		<xsl:value-of select='concat(""
			,if (position() != 1) then "," else ""
			,"&apos;",replace(lower-case(name()),"ows_",""),"&apos;"
			,":&apos;",normalize-space(replace(.,"&apos;","\\&apos;")),"&apos;"
		)' disable-output-escaping="yes" />
	
	</xsl:for-each>
	
	<xsl:for-each select="$extraIndex">
		<xsl:variable name="pos" select="position()" />
		<xsl:value-of select='concat(""
			,",&apos;",lower-case(.),"&apos;"
			,":&apos;",normalize-space(replace($extraValue[$pos],"&apos;","\\&apos;")),"&apos;"
		)' disable-output-escaping="yes" />
	</xsl:for-each>
	
<xsl:value-of select="'});'" />

<xsl:value-of select="concat(' YWC.f.assetParseAttachments(&quot;',$assetId,'&quot;);')" />

</xsl:template>


<xsl:function name="ywc:getNodeValue" as="xs:string">
	<xsl:param name="node" />
	<xsl:param name="indexName" as="xs:string" />
	
	<xsl:variable name="values" as="xs:string*">
		<xsl:for-each select="
			$node/(*|@*)
			[	exists(index-of(lower-case($indexName),lower-case(name())))
			or	exists(index-of(lower-case($indexName),lower-case(substring-after(name(),'ows_'))))
			or	exists(index-of(concat(lower-case($indexName),'text'),lower-case(substring-after(name(),'ows_'))))
			or	exists(index-of(concat('posting',lower-case($indexName)),lower-case(substring-after(name(),'ows_'))))
			]">
			<xsl:value-of select='.' disable-output-escaping="yes" />
		</xsl:for-each>
	</xsl:variable>
	<xsl:value-of select="concat('',string-join($values,' '))" disable-output-escaping="yes" />
</xsl:function>


<xsl:function name="ywc:dateMonthString" as="xs:string">
<xsl:param name="num" as="xs:string" />
<xsl:variable name="asNum" as="xs:integer" select="xs:integer($num)" />
<xsl:variable name="names" as="xs:string*" select="('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')" />
<xsl:value-of select="$names[$asNum]" />
</xsl:function>

<xsl:function name="ywc:dateStringToNumbers" as="xs:string">
<xsl:param name="dateString" as="xs:string" />
<xsl:variable name="formatMonth" as="xs:string" select="
			replace(replace(replace(replace(replace(replace(replace(
			replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
				lower-case($dateString)
			,'jan','01'),'feb','02'),'mar','03'),'apr','04'),'may','05'),'jun','06'),'jul','07'),'aug','08'),'sep','09'),'oct','10'),'nov','11'),'dec','12')
			,'(mon)',''),'(tue)',''),'(wed)',''),'(thu)',''),'(fri)',''),'(sat)',''),'(sun)','')
	" />
<xsl:value-of select="$formatMonth" />
</xsl:function>

<xsl:function name="ywc:dateStringProcess" as="xs:string">
<xsl:param name="dateString" as="xs:string" />
<xsl:variable name="dateString_" as="xs:string" select="ywc:removeSpace(ywc:dateStringToNumbers(ywc:removeFormatting($dateString)))" />
<xsl:variable name="dateString__" as="xs:string" select=" if (string-length($dateString_) = 15) then concat($dateString_,':00') else $dateString_ " />
<xsl:variable name="dateStringReplaced" as="xs:string" select="replace($dateString__,'\(allday\)','00:00:00')" />
<xsl:value-of select="concat(substring($dateStringReplaced,1,10),'T',substring($dateStringReplaced,11),'Z')" />
</xsl:function>

<xsl:function name="ywc:getImgUrlFromHtml" as="xs:string">
<xsl:param name="text" as="xs:string" />
	<xsl:value-of select="substring-before(substring-after(substring-before(substring-after($text,'&lt;img '),'&gt;'),'src=&quot;'),'&quot;')" />
</xsl:function>

<xsl:function name="ywc:removeFormatting" as="xs:string">
<xsl:param name="text" as="xs:string" />
<xsl:variable name="formatted" as="xs:string*">
<xsl:call-template name="ywcRemoveFormatting">
	<xsl:with-param name="text" select="$text"/>
</xsl:call-template>
</xsl:variable>
<xsl:value-of select="string-join($formatted,' ')" disable-output-escaping="yes" />
</xsl:function>


<xsl:template name="ywcRemoveFormatting">
<xsl:param name="text" select="."/>
<xsl:choose>

	<xsl:when test="contains($text,'&lt;')"><xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-before($text,'&lt;')"/></xsl:call-template> <xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-after($text,'&gt;')"/></xsl:call-template></xsl:when>
<!--	<xsl:when test="contains($text,'&amp;nbsp;')"><xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-before($text,'&amp;nbsp;')"/></xsl:call-template> <xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-after($text,'&amp;nbsp;')"/></xsl:call-template></xsl:when>-->
	<xsl:when test="contains($text,'&quot;')"><xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-before($text,'&quot;')"/></xsl:call-template>'<xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-after($text,'&quot;')"/></xsl:call-template></xsl:when>
	<xsl:when test="contains($text,'_Img1_')"><xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-before($text,'_Img1_')"/></xsl:call-template> <xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-after($text,'_Img1_')"/></xsl:call-template></xsl:when>			
	<xsl:when test="contains($text,'_Img2_')"><xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-before($text,'_Img2_')"/></xsl:call-template> <xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-after($text,'_Img2_')"/></xsl:call-template></xsl:when>			
	<xsl:when test="contains($text,'_Img3_')"><xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-before($text,'_Img3_')"/></xsl:call-template> <xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-after($text,'_Img3_')"/></xsl:call-template></xsl:when>			
	<xsl:when test="contains($text,'_Img4_')"><xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-before($text,'_Img4_')"/></xsl:call-template> <xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-after($text,'_Img4_')"/></xsl:call-template></xsl:when>
	<xsl:when test="contains($text,'_Img5_')"><xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-before($text,'_Img5_')"/></xsl:call-template> <xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-after($text,'_Img5_')"/></xsl:call-template></xsl:when>
<!-- removing \n, not a typing mistake-->
	<xsl:when test="contains($text,'
')"><xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-before($text,'
')"/></xsl:call-template><xsl:value-of select="' '" disable-output-escaping="yes" /><xsl:call-template name="ywcRemoveFormatting"><xsl:with-param name="text" select="substring-after($text,'
')"/></xsl:call-template></xsl:when>		

	<xsl:otherwise><xsl:value-of select="$text" /></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:function name="ywc:removeImages" as="xs:string">
<xsl:param name="text" as="xs:string" />
<xsl:variable name="formatted" as="xs:string*">
<xsl:call-template name="ywcRemoveImages">
	<xsl:with-param name="text" select="$text"/>
</xsl:call-template>
</xsl:variable>
<xsl:value-of select="string-join($formatted,' ')" disable-output-escaping="yes" />
</xsl:function>

<xsl:template name="ywcRemoveImages">
<xsl:param name="text" select="."/>
<xsl:choose>
	<xsl:when test="contains($text,'&lt;img ')">
		<xsl:call-template name="ywcRemoveImages">
			<xsl:with-param name="text" select="substring-before($text,'&lt;img ')"/>
		</xsl:call-template>
		<xsl:call-template name="ywcRemoveImages">
			<xsl:with-param name="text" select="substring-after($text,'&gt;')"/>
		</xsl:call-template>
	</xsl:when>
	<xsl:otherwise><xsl:value-of select="$text" /></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:function name="ywc:cleanWhitespace" as="xs:string">
<xsl:param name="text" as="xs:string" />
<xsl:variable name="formatted" as="xs:string*">
<xsl:call-template name="ywcCleanWhitespace">
	<xsl:with-param name="text" select="$text"/>
</xsl:call-template>
</xsl:variable>
<xsl:value-of select="string-join($formatted,' ')" disable-output-escaping="yes" />
</xsl:function>

<xsl:template name="ywcCleanWhitespace">
<xsl:param name="text" select="."/>
<xsl:choose>
	<xsl:when test="contains($text,'&lt;/p&gt;&lt;br /&gt;&lt;p&gt;')">
		<xsl:call-template name="ywcCleanWhitespace">
			<xsl:with-param name="text" select="substring-before($text,'&lt;/p&gt;&lt;br /&gt;&lt;p&gt;')"/>
		</xsl:call-template>
		<xsl:value-of select="'&lt;/p&gt;&lt;p&gt;'" disable-output-escaping="yes" />
		<xsl:call-template name="ywcCleanWhitespace">
			<xsl:with-param name="text" select="substring-after($text,'&lt;/p&gt;&lt;br /&gt;&lt;p&gt;')"/>
		</xsl:call-template>
	</xsl:when>
	<xsl:when test="contains($text,'&lt;p&gt;&lt;/p&gt;')">
		<xsl:call-template name="ywcCleanWhitespace">
			<xsl:with-param name="text" select="substring-before($text,'&lt;p&gt;&lt;/p&gt;')"/>
		</xsl:call-template>
		<xsl:call-template name="ywcCleanWhitespace">
			<xsl:with-param name="text" select="substring-after($text,'&lt;p&gt;&lt;/p&gt;')"/>
		</xsl:call-template>
	</xsl:when>	
	<xsl:otherwise><xsl:value-of select="$text" /></xsl:otherwise>
</xsl:choose>
</xsl:template>


</xsl:stylesheet>