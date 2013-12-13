<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">


<xsl:template name="ywcInputDateTime">
<xsl:param name="id" as="xs:string" select="''" />
<xsl:param name="class" as="xs:string" select="''" />
<xsl:param name="type" as="xs:string" select="'datetime'" />
<xsl:param name="value" as="xs:string" select="''" />
<xsl:param name="fontSize" as="xs:integer" select="18" />
<xsl:param name="unitLengthInSeconds" as="xs:integer" select="300" />
<xsl:param name="onChangeJs" as="xs:string" select="''" />
<xsl:param name="isRequired" as="xs:integer" select="0" />

<xsl:variable name="a" select='"&apos;"' />

<xsl:variable name="verifiedValue" select="
	if (string-length($value) &gt; 0) then $value
	else concat('',ywc:unixTime())
" />

<xsl:if test="contains($type,'date')">
	<xsl:value-of select="concat(''
					,'&lt;input type=&quot;text&quot;'
						,' id=&quot;ywc-input-datetime-date-',$id,'&quot;'
						,' class=&quot;ywc-input-text ywc-input-datetime ywc-crnr-5 '
								, if ($isRequired = 1) then ' ywc-input-required' else ''
								,' ', $class,'&quot;'
						,' style=&quot;'
							,'font-size:',$fontSize,'px;'
							,'padding:',round(0.5 * $fontSize),'px 5px;'
							,'visibility:hidden;'
						,'&quot;'
						,' size=&quot;','11','&quot;'
						,' value=&quot;',ywc:escTags($verifiedValue),'&quot;'
						,' /&gt;'
					
					,'&lt;script type=&quot;text/javascript&quot;&gt;'
							,'$(function(){'
							,' YWC.f.inputDateTimeLoad(&quot;date&quot;'
								,',&quot;date-',$id,'&quot;'
								,',function(){',$onChangeJs,';}'
								,');'
							,'});'
						,'&lt;/script&gt;'
					)" disable-output-escaping="yes" />
</xsl:if>

<xsl:if test="contains($type,'time')">
	<xsl:value-of select="concat(''
					,'&lt;input type=&quot;text&quot;'
						,' id=&quot;ywc-input-datetime-time-',$id,'&quot;'
						,' class=&quot;ywc-input-text ywc-input-datetime ywc-crnr-5 '
								, if ($isRequired = 1) then ' ywc-input-required' else ''
								,' ', $class,'&quot;'
						,' style=&quot;'
							,'font-size:',$fontSize,'px;'
							,'padding:',round(0.5 * $fontSize),'px 5px;'
							,'visibility:hidden;'
						,'&quot;'
						,' size=&quot;','8','&quot;'
						,' value=&quot;',ywc:escTags($verifiedValue),'&quot;'
						,' /&gt;'

					,'&lt;script type=&quot;text/javascript&quot;&gt;'
							,'$(function(){'
							,' YWC.f.inputDateTimeLoad(&quot;time&quot;'
								,',&quot;time-',$id,'&quot;'
								,',function(){',$onChangeJs,';}'
								,');'
							,'});'
						,'&lt;/script&gt;'
					)" disable-output-escaping="yes" />
</xsl:if>

<xsl:value-of select="concat(
		'&lt;script type=&quot;text/javascript&quot;&gt;'
			,' YWC.input.meta.validation.required[',$a,replace($id,$a,concat('\\',$a)),$a,']='
			, if ($isRequired = 1) then 'true' else 'false', ';'
			,' YWC.input.meta.validation.type[',$a,replace($id,$a,concat('\\',$a)),$a,']=',$a,'datetime',$a,';'
		,'&lt;/script&gt;'
	)" disable-output-escaping="yes" />


</xsl:template>

</xsl:stylesheet>
