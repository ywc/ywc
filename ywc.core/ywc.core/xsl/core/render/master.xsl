<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="ywc_delim_header" as="xs:string" select="''" />
<xsl:param name="ywc_delim_outer" as="xs:string" select="''" />
<xsl:param name="ywc_delim_inner" as="xs:string" select="''" />
<xsl:param name="ywc_delim_command" as="xs:string" select="''" />
<xsl:param name="ywc_env_env" as="xs:string" select="'env'" />
<xsl:param name="ywc_env_app" as="xs:string" select="'app'" />
<xsl:param name="ywc_env_domain" as="xs:string" select="'domain'" />
<xsl:param name="ywc_env_server" as="xs:string" select="'server'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../render/template.xsl" />
	
<xsl:template match="/ywc">
	
	<xsl:variable name="core_uri_xml" select="document('../../../xml/data/uri.xml')/ywc" />
	
	<xsl:variable name="direct_match" select="($core_uri_xml | .)/uri[(@type = 'page') and (@pattern = $uri) and (@asset_type = 'template')]" />
	
	<xsl:choose>
		<xsl:when test="count($direct_match) &gt; 0">
			<xsl:for-each select="$direct_match[position() = 1]">
				<xsl:call-template name="render_template">
					<xsl:with-param name="uri_params_lang_delims" select="($uri,$params,$lang,$ywc_delim_outer,$ywc_delim_inner,$ywc_delim_command)"/>
					<xsl:with-param name="ywc_delim_header" select="$ywc_delim_header"/>
					<xsl:with-param name="template_id" select="@asset_id"/>
					<xsl:with-param name="parent_node_uri" select="."/>
					<xsl:with-param name="env" select="($ywc_env_env,$ywc_env_app,$ywc_env_domain,$ywc_env_server)"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="($core_uri_xml | .)/uri[(@type = 'regex') and (@asset_type = 'template') and matches($uri,@pattern)][position() = 1]">
				<xsl:call-template name="render_template">
					<xsl:with-param name="uri_params_lang_delims" select="($uri,$params,$lang,$ywc_delim_outer,$ywc_delim_inner,$ywc_delim_command)"/>
					<xsl:with-param name="ywc_delim_header" select="$ywc_delim_header"/>
					<xsl:with-param name="template_id" select="@asset_id"/>
					<xsl:with-param name="parent_node_uri" select="."/>
					<xsl:with-param name="env" select="($ywc_env_env,$ywc_env_app,$ywc_env_domain,$ywc_env_server)"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:otherwise>
	</xsl:choose>

	
</xsl:template>

</xsl:stylesheet>