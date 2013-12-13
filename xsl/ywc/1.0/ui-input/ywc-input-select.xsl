<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">


<xsl:template name="ywcInputSelect">
<xsl:param name="id" as="xs:string" select="''" />
<xsl:param name="class" as="xs:string" select="''" />
<xsl:param name="placeholder" as="xs:string" select="''" />
<xsl:param name="values" as="xs:string*" select="()" />
<xsl:param name="labels" as="xs:string*" select="()" />
<xsl:param name="selected" as="xs:string" select="''" />
<xsl:param name="menuWidth" as="xs:integer" select="0" />
<xsl:param name="menuStyle" as="xs:string" select="'popup'" /><!-- other option is 'dropdown' -->
<xsl:param name="onSelectJs" as="xs:string" select="''" />
<xsl:param name="onLoadJs" as="xs:string" select="''" />
<xsl:param name="isRequired" as="xs:integer" select="0" />

<xsl:variable name="a" select='"&apos;"' />

<xsl:value-of select="concat(''
					,'&lt;select'
						,' id=&quot;ywc-input-select-',$id,'&quot;'
						,' class=&quot;ywc-input-select '
								, if ($isRequired = 1) then ' ywc-input-required' else ''
								,' ', $class,'&quot;'
						,' onChange=&quot;'
							,'YWC.input.value.select[',$a,replace($id,$a,concat('\\',$a)),$a,']=this.options[this.selectedIndex].value;'
							,replace($onSelectJs,'&quot;','\\&quot;')
						,'&quot;'
						,' style=&quot;visibility:hidden;&quot;'
						,'&gt;'
						, if (string-length($placeholder) = 0) then '' else 
							concat('&lt;option value=&quot;&quot;'
								, if (string-length($selected) = 0) then ' selected=&quot;selected&quot;' else ''
								,'&gt;',$placeholder,'&lt;/option&gt;')
						)" disable-output-escaping="yes" />

		<xsl:for-each select="$values">
			<xsl:variable name="ind" select="position()" />
			<xsl:value-of select="concat('&lt;option'
					, if ((string-length($selected) = 0) or ($selected != .)) then ''
						else ' selected=&quot;selected&quot;'
					,' value=&quot;',replace(.,'&quot;','\\&quot;'),'&quot;&gt;'
					,if (string-length($labels[position()=$ind]) &gt; 0) then $labels[position()=$ind] else .
					,'&lt;/option&gt;')" disable-output-escaping="yes" />
		</xsl:for-each>
					
<xsl:value-of select="concat(''
						,' &lt;/select&gt;'
						
					,'&lt;script type=&quot;text/javascript&quot;&gt;'
						,'$(function(){'
						,'YWC.input.value.select[',$a,replace($id,$a,concat('\\',$a)),$a,']='
							,'document.getElementById(&quot;ywc-input-select-',replace($id,'&quot;','\\&quot;'),'&quot;).options'
								,'[document.getElementById(&quot;ywc-input-select-',replace($id,'&quot;','\\&quot;'),'&quot;).selectedIndex].value;'
							,' YWC.f.inputLoadSelectMenu(&quot;select#ywc-input-select-',$id,'&quot;,&quot;{transferClasses:true'
							,',style:',$a,$menuStyle,$a
							,if ($menuWidth != 0) then concat(',menuWidth:',$menuWidth) else ''
							,if ($menuWidth != 0) then concat(',width:',$menuWidth) else ''
							,'}&quot;);'
							
							,' YWC.input.meta.validation.required[',$a,replace($id,$a,concat('\\',$a)),$a,']='
								, if ($isRequired = 1) then 'true' else 'false', ';'
							
							,' YWC.input.meta.validation.type[',$a,replace($id,$a,concat('\\',$a)),$a,']=',$a,'select',$a,';'

							,$onLoadJs,';'
						,' });'
					,'&lt;/script&gt;'
					
					)" disable-output-escaping="yes" />
</xsl:template>

</xsl:stylesheet>