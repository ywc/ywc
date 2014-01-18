<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="domain" as="xs:string" select="''" />
<xsl:param name="protocol" as="xs:string" select="'http'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../../ywc/inc/ywc-core.xsl" />
<xsl:include href="../../../ywc/inc/ywc-convert.xsl" />
<xsl:include href="../../../ywc-intranet/inc/ywc-intranet-asset-detail-model.xsl" />
<xsl:include href="../../../ywc-intranet/inc/ywc-intranet-asset-detail-draw.xsl" />
<xsl:include href="../../../ywc-intranet/inc/ywc-intranet-retrieve-node.xsl" />
<xsl:include href="../../../ywc-intranet/inc/ywc-intranet-directory.xsl" />

<!-- get list and post id from URL pattern -->
<xsl:variable name="listName" select="substring-before(substring-after(substring-after($uri,'ywc/intranet/'),'/'),'/')"/>
<xsl:variable name="srcIdVal" select="substring-after(substring-after(substring-after($uri,'ywc/intranet/'),'/'),'/')"/>

<xsl:variable name="renderContext" select="substring-before(substring-after($uri,'ywc/intranet/'),'/')"/>

<xsl:variable name="bannerImage" as="xs:string" select="ywc:getParam('bannerImage',$params)" />

<xsl:template match="/">

	<table style="position:relative;border:solid 1px gray; {
		if ($renderContext = 'link') then 'margin-left:auto; margin-right:auto; margin-top:40px;'
		else ''
		} -moz-border-radius:5px; -webkit-border-radius:5px; border-radius:5px;">
	
	<xsl:value-of select="concat('&lt;tr&gt;'
		,'&lt;td colspan=&quot;3&quot; height=&quot;20&quot; style=&quot;height:20px;&quot;&gt;&lt;/td&gt;'
		,'&lt;/tr&gt;')" disable-output-escaping="yes" />

	<xsl:if test="string-length($bannerImage) &gt; 0">
		<xsl:value-of select="concat(
			'&lt;tr&gt;'
			,'&lt;td style=&quot;width:20px;&quot; width=&quot;20&quot; &gt;&lt;/td&gt;'
			,'&lt;td style=&quot;background-color:red;height:20px;&quot;&gt;&lt;/td&gt;'
			,'&lt;td style=&quot;width:20px;&quot; width=&quot;20&quot; &gt;&lt;/td&gt;'
			,'&lt;/tr&gt;'
			,'&lt;tr&gt;'
			,'&lt;td colspan=&quot;3&quot; style=&quot;height:20px;&quot;&gt;&lt;/td&gt;'
			,'&lt;/tr&gt;'
			)" disable-output-escaping="yes" />
	</xsl:if>
	
	<xsl:value-of select="concat('&lt;tr&gt;'
			,'&lt;td style=&quot;width:20px;&quot; width=&quot;20&quot;&gt;&lt;/td&gt;'
			)" disable-output-escaping="yes" />
	
	<td width="500" style="width:500px;">
		
	<xsl:call-template name="ywcIntranetAssetDetailDraw">
		<xsl:with-param name="listName" select="$listName"/>
		<xsl:with-param name="assetId" select="concat($listName,'_',$srcIdVal)"/>
		<xsl:with-param name="srcIdVal" select="$srcIdVal"/>
		<xsl:with-param name="boxWidth" select="500"/>
		<xsl:with-param name="cssStyle" select="''"/>
		<xsl:with-param name="useJavascript" select="0" />
		<xsl:with-param name="toggleImages" select="0" />
		<xsl:with-param name="bodyCssStyle" select="
			if ($renderContext = 'link') then 'font-size:70% !important;'
			else 'font-size:70% !important;'
			" />
		<xsl:with-param name="domain" select="$domain"/>
		<xsl:with-param name="protocol" select="$protocol"/>
	</xsl:call-template>
	
	</td>
	
	<xsl:value-of select="concat('&lt;td style=&quot;width:20px;&quot; width=&quot;20&quot;&gt;'
		,'&lt;/td&gt;'
		,'&lt;/tr&gt;')" disable-output-escaping="yes" />
	
	<xsl:value-of select="concat('&lt;tr&gt;'
		,'&lt;td colspan=&quot;3&quot; style=&quot;height:20px;&quot; height=&quot;20&quot;&gt;'
		,'&lt;/td&gt;'
		,'&lt;/tr&gt;')" disable-output-escaping="yes" />
	
	</table>
	
</xsl:template>

</xsl:stylesheet>
