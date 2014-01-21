<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">


<xsl:template name="ywcInputText">
<xsl:param name="type" as="xs:string" select="'text'" /> <!-- other options are textarea or password -->
<xsl:param name="id" as="xs:string" select="''" />
<xsl:param name="class" as="xs:string" select="''" />
<xsl:param name="style" as="xs:string" select="''" />
<xsl:param name="value" as="xs:string" select="''" />
<xsl:param name="placeholder" as="xs:string" select="''" />
<xsl:param name="fontSize" as="xs:integer" select="24" />
<xsl:param name="eraseBttn" as="xs:integer" select="0" />
<xsl:param name="eraseBttnJs" as="xs:string" select="''" />
<xsl:param name="onLoadJs" as="xs:string" select="''" />
<xsl:param name="onTypeJs" as="xs:string" select="''" />
<xsl:param name="onTypeJsDelay" as="xs:integer" select="250" />
<xsl:param name="onTypeJsMinLength" as="xs:integer" select="3" />
<xsl:param name="onReturnKeyJs" as="xs:string" select="''" />
<xsl:param name="onFocusJs" as="xs:string" select="''" />
<xsl:param name="onBlurJs" as="xs:string" select="''" />
<xsl:param name="readOnly" as="xs:integer" select="0" />
<xsl:param name="autoFocus" as="xs:integer" select="0" />
<xsl:param name="richText" as="xs:integer" select="1" />
<xsl:param name="icon" as="xs:string" select="''" />
<xsl:param name="preUri" as="xs:string" select="'/'" />
<xsl:param name="isRequired" as="xs:integer" select="0" />

<xsl:param name="onEscapeKeyJs" as="xs:string" select="''" />
<xsl:param name="onClearJs" as="xs:string" select="''" /><!-- not yet implemented -->

<xsl:variable name="a" select='"&apos;"' />

<xsl:variable name="bttnEraseVis" select="if (string-length($value) = 0) then 'none' else 'block'" />

<xsl:value-of select="concat(''
	
						,'&lt;div class=&quot;ywc-input-text&quot;'
							,' style=&quot;top:',round(0.6 * $fontSize),'px;&quot;'
							,'&gt;'
						
						, if (string-length($icon) = 0) then '' else concat(''
						,'&lt;img src=&quot;',$preUri,$icon,'&quot;'
						,' style=&quot;width:',round(1.3 * $fontSize),'px;'
							,'height:',round(1.3 * $fontSize),'px;'
							,'left:',round(0.5 * $fontSize),'px;'
						,'&quot;'
						,' id=&quot;ywc-input-text-',$id,'-icon&quot;'
						,' class=&quot;ywc-trans-100 icon&quot;'
						,' onClick=&quot;$(',$a,'input#ywc-input-text-',$id,$a,').focus()&quot;'
						,' /&gt;'
						)
						
						,'&lt;/div&gt;'
		
					, if ($type != 'textarea') then concat('&lt;input type=&quot;',$type,'&quot;')
						else '&lt;textarea'
					
						,' id=&quot;ywc-input-text-',$id,'&quot;'
						,' name=&quot;ywc-input-text-',$id,'&quot;'
						,' title=&quot;',replace($placeholder,'&quot;','&amp;quot;'),'&quot;'
						,' class=&quot;ywc-input-text ywc-crnr-5'
								, if ($isRequired = 1) then ' ywc-input-required' else ''
								,' ', $class,'&quot;'
						,' style=&quot;'
							,'font-size:',$fontSize,'px;'
							,'padding:',round(0.5 * $fontSize),'px;'
							,'padding-right:',(2 * $fontSize),'px;'
							, if (($type = 'textarea') and ($richText = 1)) then 'visibility:hidden;' else ''
							, if (($type != 'textarea') and (string-length($icon) &gt; 0)) then concat('padding-left:',(2 * $fontSize),'px;width:75%;') else 'width:80%;'
							,$style
						,'&quot;'
						,' onFocus=&quot;'
							,replace($onFocusJs,'&quot;','\\&quot;')
						,'&quot;'
						,' onBlur=&quot;'
							,replace($onBlurJs,'&quot;','\\&quot;')
						,'&quot;'
						,' onKeyUp=&quot;'
							,'if(this.value.length&gt;0){'
							,'if(document.getElementById(this.id+',$a,'-x',$a,')!=null){'
							,'document.getElementById(this.id+',$a,'-x',$a,')'
								,'.style.display=',$a,'block',$a,';'
							,'}}else{YWC.f.inputTextClear(',$a,$id,$a,',false,false);}'
							,'YWC.input.value.text[',$a,replace($id,$a,concat('\\',$a)),$a,']=$(this).val();'
							,'if(!YWC.input.meta.jsBlock[',$a,replace($id,$a,concat('\\',$a)),$a,']){'
							,'YWC.input.meta.jsBlock[',$a,replace($id,$a,concat('\\',$a)),$a,']=true;'
							,'setTimeout(function(){'
								,'if((YWC.input.value.text[',$a,replace($id,$a,concat('\\',$a)),$a,'].length&gt;=',$onTypeJsMinLength,')'
									,'&amp;&amp;(YWC.input.meta.lastValue.text[',$a,replace($id,$a,concat('\\',$a)),$a,']!=YWC.input.value.text[',$a,replace($id,$a,concat('\\',$a)),$a,'])){'
									,$onTypeJs,';'
									,'YWC.input.meta.lastValue.text[',$a,replace($id,$a,concat('\\',$a)),$a,']=YWC.input.value.text[',$a,replace($id,$a,concat('\\',$a)),$a,'];'
						
								,'}'
								,'YWC.input.meta.jsBlock[',$a,replace($id,$a,concat('\\',$a)),$a,']=false;'
							,'},',$onTypeJsDelay,');'
							,'}'
							,'else if(YWC.input.value.text[',$a,replace($id,$a,concat('\\',$a)),$a,'].length==0)'
								,'{'
								,'YWC.f.inputTextClear(',$a,$id,$a,',true,true);'
								,'YWC.f.inputTextFocus(',$a,$id,$a,');'
								,$eraseBttnJs
								,';}'
							,'YWC.input.meta.valueLength[',$a,replace($id,$a,concat('\\',$a)),$a,']=YWC.input.value.text[',$a,replace($id,$a,concat('\\',$a)),$a,'].length;'
						,'&quot;'
					
					, if ($readOnly = 1) then ' readonly=&quot;readonly&quot;' else ''
					, if ($type != 'textarea') then concat(' value=&quot;',ywc:escTags($value),'&quot; /&gt;')
							else concat('&gt;',$value,'&lt;/textarea&gt;')
					
					,'&lt;div class=&quot;ywc-input-text&quot;'
					,' style=&quot;top:',round(0.6 * $fontSize),'px;&quot;'
					,'&gt;'

					
					, if (($eraseBttn = 1) and ($type != 'textarea')) then concat(''					
					
					,'&lt;span class=&quot;ywc-x&quot;&gt;'
					,'&lt;div'
					,' style=&quot;width:',round(1.6 * $fontSize),'px;'
						,'height:',round(1.6 * $fontSize),'px;'
						,'left:-',round(1.9 * $fontSize),'px;'
						,'display:',$bttnEraseVis,';'
						,'font-size:',((1.6 * $fontSize) div 10),'%;'
						,'border:none;'
						,'&quot;'
					,' unselectable=&quot;on&quot;'
					,' id=&quot;ywc-input-text-',$id,'-x&quot;'
					,' class=&quot;ywc-trans-50 erase fa-stack fa-fw ywc-x-box ywc-unselectable&quot;'
					,' onMouseOver=&quot;YWC.f.xHover(true,',$a,'ywc-input-text-x-',$id,$a,',[',$a,'9f9f9f',$a,',',$a,'ffffff',$a,']);&quot;'
					,' onMouseOut=&quot;YWC.f.xHover(false,',$a,'ywc-input-text-x-',$id,$a,',[',$a,'9f9f9f',$a,',',$a,'ffffff',$a,']);&quot;'
					,' onClick=&quot;'
						,'YWC.f.inputTextClear(',$a,$id,$a,',true,true);'
						,$eraseBttnJs
						,'&quot;'
					,'&gt;'
					,'&lt;i id=&quot;ywc-x-1-ywc-input-text-x-',$id,'&quot; class=&quot;ywc-x-3 fa fa-stack-1x fa-circle&quot;&gt;&lt;/i&gt;'
					,'&lt;i id=&quot;ywc-x-2-ywc-input-text-x-',$id,'&quot; class=&quot;ywc-x-2 fa fa-stack-1x fa-circle&quot;&gt;&lt;/i&gt;'
					,'&lt;i id=&quot;ywc-x-3-ywc-input-text-x-',$id,'&quot; class=&quot;ywc-x-1 fa fa-stack-1x fa-times&quot;&gt;&lt;/i&gt;'
					,'&lt;/div&gt;'
					,'&lt;/span&gt;'
					
					) else ''
					
					, if ($type != 'textarea') then concat(''
						,'&lt;i'
						,' style=&quot;width:',round(2 * $fontSize),'px;'
							,'height:',round(2 * $fontSize),'px;'
							,'left:-',round(2.2 * $fontSize),'px;'
							,'top:-',round(0.4 * $fontSize),'px;'
							,'font-size:',round(2 * $fontSize),'px;'
							,'visibility:hidden;'
							,'&quot;'
						,' id=&quot;ywc-input-text-',$id,'-load&quot;'
						,' class=&quot;ywc-trans-100 loading fa fa-spinner fa-spin&quot;'
						,'&gt;&lt;/i&gt;'
					) else ''
						
					,'&lt;/div&gt;'
					
					,'&lt;script type=&quot;text/javascript&quot;&gt;'
						,'$(function(){'
							
							,'YWC.input.value.text[&quot;'
								,replace($id,'&quot;','\\&quot;')
									,'&quot;]=&quot;',replace($value,'&quot;','\\&quot;'),'&quot;;'
							
							,'YWC.input.meta.lastValue.text[&quot;'
								,replace($id,'&quot;','\\&quot;')
									,'&quot;]=&quot;',replace($value,'&quot;','\\&quot;'),'&quot;;'
							
							,'YWC.input.meta.jsBlock[&quot;',replace($id,'&quot;','\\&quot;'),'&quot;]=false;'
							
							, if (string-length($onReturnKeyJs) &gt; 0) then
								concat('YWC.f.inputJsOnKeyPress(&quot;enter&quot;'
									,',&quot;#ywc-input-text-',$id,'&quot;'
									,',&quot;',replace($onReturnKeyJs,'&quot;','\\&quot;'),'&quot;,',$onTypeJsMinLength,');')
								else ''
						
							, if ($type = 'text') then
								concat('YWC.f.inputTextLabelSet(',$a,'input#ywc-input-text-',$id,$a,');')
								else ''
							, if (($type = 'textarea') and ($richText = 1)) then 
								concat('YWC.f.inputLoadRichText(',$a,'textarea#ywc-input-text-',$id,$a,');')
								else ''
							, if ($autoFocus = 1) then 
								concat('if(BrowserDetect.browser!==&quot;Explorer&quot;){YWC.f.inputTextFocus(&quot;',$id,'&quot;);}') 
								else ''

							,' YWC.input.meta.validation.required[',$a,replace($id,$a,concat('\\',$a)),$a,']='
								, if ($isRequired = 1) then 'true' else 'false', ';'

							,' YWC.input.meta.validation.type[',$a,replace($id,$a,concat('\\',$a)),$a,']=',$a,'text',$a,';'

							,$onLoadJs,';'
						,'});'
					,'&lt;/script&gt;'
					
					)" disable-output-escaping="yes" />
</xsl:template>

</xsl:stylesheet>