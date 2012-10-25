<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">

<xsl:template name="render_transform">
<xsl:param name="uri_params_lang_delims" as="xs:string*" select="('/','','en','','','')" />
<xsl:param name="xml_transform" select="." />
<xsl:param name="fallback_xml_xsl" as="xs:string*" select="('core/blank.xml','core/blank.xsl')" />

<!--<xsl:value-of select="concat($uri_params_lang_delims[1],$uri_params_lang_delims[2],$uri_params_lang_delims[3],$uri_params_lang_delims[4],$uri_params_lang_delims[5])" />-->
	<xsl:variable name="delim_outer" select="$uri_params_lang_delims[4]" />
	<xsl:variable name="delim_inner" select="$uri_params_lang_delims[5]" />
	<xsl:variable name="delim_command" select="$uri_params_lang_delims[6]" />

	<xsl:choose>
		<xsl:when test="count($xml_transform) &gt; 0">
			<xsl:for-each select="$xml_transform">
			<xsl:sort data-type="number" select="@ordering" order="ascending" />
			<xsl:value-of select="concat($delim_outer
						,@transform_id
					,$delim_inner
						,@xml
					,$delim_inner
						,@xsl
				,$delim_outer)" />
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat($delim_outer	
						,@transform_id
					,$delim_inner
						,$fallback_xml_xsl[1]
					,$delim_inner
						,$fallback_xml_xsl[2]
				,$delim_outer)" />
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>

</xsl:stylesheet>