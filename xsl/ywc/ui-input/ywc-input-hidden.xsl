<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">


<xsl:template name="ywcInputHidden">
<xsl:param name="id" as="xs:string" select="''" />
<xsl:param name="class" as="xs:string" select="''" />
<xsl:param name="value" as="xs:string" select="''" />

<xsl:variable name="a" select='"&apos;"' />

<xsl:value-of select="concat(''
					,'&lt;input type=&quot;hidden&quot;'
					
						,' id=&quot;ywc-input-hidden-',$id,'&quot;'
						,' class=&quot;ywc-input-hidden ',$class,'&quot;'
						,' value=&quot;',ywc:escTags($value),'&quot;'
						,' /&gt;'
						
					,'&lt;script type=&quot;text/javascript&quot;&gt;'
						,'$(function(){'
							,'YWC.f.inputHiddenValueListener(&quot;',replace($id,'&quot;','\\&quot;'),'&quot;);'
						,' });'
					,'&lt;/script&gt;'
					
					)" disable-output-escaping="yes" />
</xsl:template>

</xsl:stylesheet>