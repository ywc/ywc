<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">

<xsl:template name="ywcIntranetGlobalNav">
<xsl:param name="height" as="xs:integer" select="40" />
<xsl:param name="bg-img" as="xs:string" select="''" />
<xsl:param name="font-size" as="xs:integer" select="14" />
<xsl:param name="font-color" as="xs:string" select="'222222'" />
<xsl:param name="labels" as="xs:string*" select="()" />
<xsl:param name="links" as="xs:string*" select="()" />
<xsl:param name="uid" as="xs:string" select="''" />
	
	<div class="ywc-intranet-nav-global" style="background:url({$bg-img});height:auto;">
	
		<xsl:for-each select="$labels">
		<xsl:variable name="pos" select="position()" />
			<div class="item-top" style="font-size:{$font-size}px;padding:{($height - $font-size) div 2}px 10px;">
			<a href="{$links[$pos]}" target="_blank">	
				<xsl:value-of select="$labels[$pos]" />
			</a></div>
		</xsl:for-each>	
		
		<xsl:variable name="userId" select="
			if ((string-length($uid) &gt; 0) and ($uid != '(null)')) then concat('User: ',$uid) 
				else concat('Login'
					,'&lt;script type=&quot;text/javascript&quot;&gt;'
					,'$(function(){ YWC.f.intranetAuthIdentity(); });'
					,'&lt;/script&gt;'
				)
			" />
		
		<div class="item-top ywc-intranet-login-uid" style="font-size:{$font-size}px;padding:{($height - $font-size) div 2}px 10px;float:right;">
		<a href="javascript:YWC.f.intranetCheckAuth(null,true);">	
			<xsl:value-of select="$userId" disable-output-escaping="yes" />
		</a></div>
		
	</div>

</xsl:template>


</xsl:stylesheet>