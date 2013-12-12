<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">


<xsl:template name="ywcInputCheckBox">
<xsl:param name="type" as="xs:string" select="'checkbox'" />
<xsl:param name="id" as="xs:string" select="''" />
<xsl:param name="class" as="xs:string" select="''" />
<xsl:param name="fontSize" as="xs:integer" select="16" />
<xsl:param name="values" as="xs:string*" select="()" />
<xsl:param name="labels" as="xs:string*" select="()" />
<xsl:param name="checked" as="xs:integer*" select="()" />
<xsl:param name="onChangeJs" as="xs:string" select="''" />
<xsl:param name="onLoadJs" as="xs:string" select="''" />
<xsl:param name="isRequired" as="xs:integer" select="0" />

<xsl:variable name="a" select='"&apos;"' />

		<xsl:for-each select="$values">
			<xsl:variable name="ind" select="position()" />
			<xsl:value-of select="concat('&lt;div'
					,' class=&quot;ywc-input-checkbox'
						,' ywc-input-checkbox-',$id
								, if ($isRequired = 1) then ' ywc-input-required' else ''
								,' ', $class
						,'&quot;'
					,' style=&quot;'
						,'font-size:',$fontSize,'px;'
						,'height:',($fontSize+4),'px;'
						,'&quot;'
					,'&gt;'
					,'&lt;input type=&quot;',$type,'&quot;'
					,' id=&quot;ywc-input-checkbox-',$id,'-',$ind,'&quot;'
					,' name=&quot;ywc-input-checkbox-',$id,'&quot;'
					,' value=&quot;',replace($values[position()=$ind],'&quot;','\\&quot;'),'&quot;'
					,' onChange=&quot;'
						,'YWC.f.inputCheckBoxValueSet('
							,$a,$id,$a
							,',',$a,$type,$a
							,',function(){',replace($onChangeJs,'&quot;','\\&quot;'),';}'
						,')&quot;'
						
					, if ($checked[position()=$ind] = 1) then ' checked=&quot;checked&quot;' else ''
					
					,' /&gt;'
					 ,'&lt;label for=&quot;ywc-input-checkbox-',$id,'-',$ind,'&quot;&gt;'
							,if (string-length($labels[position()=$ind]) &gt; 0) then $labels[position()=$ind] else $values[position()=$ind]
								,'&lt;/label&gt;'
					,'&lt;/div&gt;'
					)" disable-output-escaping="yes" />
		</xsl:for-each>


<xsl:value-of select="concat(''
					,'&lt;script type=&quot;text/javascript&quot;&gt;'
						,'var ywcInputCheckBoxObject=document.getElementsByName(',$a,'ywc-input-checkbox-',$id,$a,');'
						, if ($type = 'checkbox') then concat(''
							,'YWC.input.value.checkbox[',$a,$id,$a,']=[];'
							,'for(i in ywcInputCheckBoxObject){if(ywcInputCheckBoxObject[i].checked){'
								,'YWC.input.value.checkbox[',$a,$id,$a,'].push(ywcInputCheckBoxObject[i].value);'
							,'}}'
						) else	concat(''
							,'YWC.input.value.checkbox[',$a,$id,$a,']=',$a,$a,';'
							,'for(i in ywcInputCheckBoxObject){if(ywcInputCheckBoxObject[i].checked){'
								,'YWC.input.value.checkbox[',$a,$id,$a,']=ywcInputCheckBoxObject[i].value;'
							,'}}'
						)
						
						,'$(function(){'
							,$onLoadJs,';'
						,' });'
					,'&lt;/script&gt;'
					)" disable-output-escaping="yes" />

</xsl:template>

</xsl:stylesheet>