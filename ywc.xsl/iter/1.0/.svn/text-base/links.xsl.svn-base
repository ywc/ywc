<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">
  <xsl:param name="uri" as="xs:string" select="'/'" />
  <xsl:param name="params" as="xs:string" select="''" />
  <xsl:param name="lang" as="xs:string" select="'en'" />
  <xsl:param name="cache_path" as="xs:string" select="'-'" />
  <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

  <xsl:include href="../../ywc/1.0/inc/ywc-core.xsl" />
  <xsl:include href="../../ywc/1.0/inc/ywc-convert.xsl" />
  <xsl:include href="../../ywc/1.0/ui-elements/ywc-header.xsl" />
  <xsl:include href="asset-list/quick-links.xsl" />
  <xsl:template match="/">
  
    <xsl:for-each select="ywc/cache[@name='links']">
      
      <xsl:variable name="cache_id" select="@cache_id" />
      <xsl:variable name="listXml" select="document(concat('../../../ywc.cache/xml/cache/',$cache_id,'.xml'))/rs:data/z:row" />
      
      <xsl:call-template name="ywcHeader">
        <xsl:with-param name="text" select="lower-case(@title)"/>
        <xsl:with-param name="width" select="120"/>
        <xsl:with-param name="fontsize" select="20"/>
        <xsl:with-param name="color" select="'FDBB30'"/>
        <xsl:with-param name="bg-color" select="'919BC6'"/>
      </xsl:call-template>

      <xsl:for-each select="$listXml[@ows_Parent='Page']">

        <xsl:if test="@ows_Parent='Page'">
          <xsl:call-template name="ywcHeader">
            <xsl:with-param name="text" select="lower-case(@ows_Title)"/>
            <xsl:with-param name="width" select="120"/>
            <xsl:with-param name="fontsize" select="12"/>
            <xsl:with-param name="color" select="'FDBB30'"/>
            <xsl:with-param name="bg-color" select="'919BC6'"/>
          </xsl:call-template>
        </xsl:if>
          
        <xsl:call-template name="quicklinks">
          <xsl:with-param name="quicklinks_xml" select="$listXml"/>
          <xsl:with-param name="quicklinks_id" select="@ows_ID"/>
          <xsl:with-param name="wdth" select="'160'"/>
          <xsl:with-param name="search" select="'x'"/>
        </xsl:call-template>
        
      </xsl:for-each>
      
      </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>

