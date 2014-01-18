<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:param name="domain" as="xs:string" select="''" />
<xsl:param name="protocol" as="xs:string" select="'http'" />
<xsl:param name="user" as="xs:string" select="''" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../../ywc/inc/ywc-core.xsl" />
<xsl:include href="../../../ywc/inc/ywc-convert.xsl" />
<xsl:include href="../../../ywc-intranet/inc/ywc-intranet-asset-detail-model.xsl" />
<xsl:include href="../../../ywc-intranet/inc/ywc-intranet-asset-detail-draw.xsl" />
<xsl:include href="../../../ywc-intranet/inc/ywc-intranet-retrieve-node.xsl" />
<xsl:include href="../../../ywc-intranet/inc/ywc-intranet-directory.xsl" />

<xsl:variable name="listName" select="ywc:getParam('listName',$params)"/>
<xsl:variable name="assetId" select="ywc:getParam('assetId',$params)"/>
<xsl:variable name="srcIdName" select="ywc:getParam('srcIdName',$params)"/>
<xsl:variable name="srcIdVal" select="ywc:getParam('srcIdVal',$params)"/>
<xsl:variable name="popupWidth" select="ywc:getParam('popupWidth',$params)" />
<xsl:variable name="preUri" select="ywc:getParam('preUri',$params)"/>

<xsl:template match="/">
	
	<xsl:call-template name="ywcIntranetAssetDetailDraw">
		<xsl:with-param name="listName" select="$listName"/>
		<xsl:with-param name="assetId" select="$assetId"/>
		<xsl:with-param name="srcIdVal" select="$srcIdVal"/>
		<xsl:with-param name="boxWidth" select="xs:integer($popupWidth)"/>
		<xsl:with-param name="useJavascript" select="1" />
		<xsl:with-param name="domain" select="$domain"/>
		<xsl:with-param name="protocol" select="$protocol"/>
		<xsl:with-param name="currentUser" select="$user"/>
		<xsl:with-param name="preUri" select="$preUri"/>
	</xsl:call-template>
		


</xsl:template>

</xsl:stylesheet>
