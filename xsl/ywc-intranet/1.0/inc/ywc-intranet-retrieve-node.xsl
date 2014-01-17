<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:rs="urn:schemas-microsoft-com:rowset" xmlns:z="#RowsetSchema" exclude-result-prefixes="xs xsl ywc dt rs z">
	
<xsl:include href="../../vendor/json2xml/1.0/json2xml.xsl" />	
	

<xsl:function name="ywc:getImgUrl" as="xs:string">
<xsl:param name="nodeString" />
<xsl:param name="index" as="xs:integer" />
		
	<xsl:variable name="nodes" as="xs:string*">
		<xsl:choose>
			<!-- Sharepoint: string is in SharePoint serialized attachment format -->
			<xsl:when test="contains($nodeString,';#')">
				<xsl:for-each select="tokenize(lower-case($nodeString),';#')">
					<xsl:value-of select="." />
				</xsl:for-each>
			</xsl:when>
			<!-- YWC: string is in YWC JSON attachment format -->
			<xsl:when test="contains($nodeString,'[{') and contains($nodeString,'}]')">
				<!-- parse json for xpath -->
				<xsl:variable name="jsonAsXml">
					<xsl:call-template name="json2xml">
						<xsl:with-param name="text" select="$nodeString"/>
					</xsl:call-template>
				</xsl:variable>
				<!-- only fetch images from the attachments -->
				<xsl:for-each select="$jsonAsXml/array/object/field[
							(@name='ext') and ((string='jpeg') or (string='jpg') or (string='png'))
						]/../field[@name='image']/string">
					<xsl:value-of select="." />
				</xsl:for-each>
			</xsl:when>
			<!-- Drupal: if string matches to separate node table -->
			<xsl:when test="contains($nodeString,'&lt;/a&gt;')">
				<xsl:variable name="ywcCacheId" select="document('../../../cache/xml/data/cache.xml')/ywc/cache[lower-case(@name)='images']/@cache_id" />
				<xsl:variable name="imgXml" select="document(concat('../../../cache/xml/cache/',$ywcCacheId,'.xml'))/nodes/node" />
				
				<xsl:for-each select="tokenize(lower-case($nodeString),'&lt;/a&gt;, &lt;a ')">
					<xsl:variable name="imgId" select="substring-before(substring-after(.,'href=&quot;'),'&quot;')" />
					<xsl:value-of select="concat('//'
							,substring-before(substring-after(
								$imgXml[contains(title,concat('a href=&quot;',$imgId,'&quot;'))
								]/image,'://'),'&quot;'
							))" />
				</xsl:for-each>
				
			</xsl:when>				
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
		
	<xsl:variable name="getImg" as="xs:string*">
		<xsl:for-each select="
			$nodes	[	contains(lower-case(.),'.jpg') or contains(lower-case(.),'.jpeg') or contains(lower-case(.),'.png')
					][	position() = $index
					]">
			<xsl:value-of select="." />
		</xsl:for-each>
	</xsl:variable>
		
	<xsl:value-of select="replace(replace(concat('',string-join($getImg,'')),'http://','//'),'https://','//')" />
</xsl:function>

</xsl:stylesheet>