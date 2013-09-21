<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">

<xsl:template name="ywcIntranetGlobalNav">
<xsl:param name="height" as="xs:integer" select="40" />
<xsl:param name="bg-img" as="xs:string" select="''" />
<xsl:param name="font-size" as="xs:integer" select="14" />
<xsl:param name="font-color" as="xs:string" select="'222222'" />
<xsl:param name="labels" as="xs:string*" select="()" />
<xsl:param name="links" as="xs:string*" select="()" />
<xsl:param name="menusXmlRef" as="xs:string" select="''" />
<xsl:param name="uid" as="xs:string" select="''" />
	
	<div class="ywc-intranet-nav-global ywc-crnr-5 ywc-crnr-b-off" style="background:url({$bg-img});">
	
		<xsl:for-each select="$labels">
		<xsl:variable name="pos" select="position()" />
			<div class="item-top" style="font-size:{$font-size}px;padding:{($height - $font-size) div 2}px 10px;">
			<a href="{$links[$pos]}" target="_blank">	
				<xsl:value-of select="$labels[$pos]" />
			</a></div>
		</xsl:for-each>	

		<xsl:if test="string-length($menusXmlRef) &gt; 0">
			<ul class="ywc-crnr-5 ywc-crnr-b-off">
				<xsl:variable name="menus-xml" select="ywc:returnYwcCache($menusXmlRef)/menus/menu/item" />
				<xsl:for-each select="$menus-xml[@language='en']">
					<li style="background:url({$bg-img});" class="ywc-crnr-5 ywc-crnr-b-off">
						<a href="{@url}" target="_blank"><xsl:value-of select="@title" /></a>
						<xsl:if test="count(item) &gt; 0">							
							<ul>
								<xsl:for-each select="item[@language='en']">
									<li style="background:url({$bg-img});">
										<a href="{@url}" target="_blank"><xsl:value-of select="@title" /></a>
										<xsl:if test="count(item) &gt; 0">
<!-- 											<xsl:value-of select="'&lt;div class=&quot;ywc-flyout-indicator&quot;&gt;t&lt;/div&gt;'" disable-output-escaping="yes" /> -->
											<ul>
												<xsl:for-each select="item[@language='en']">
													<li style="background:url({$bg-img});">
														<a href="{@url}" target="_blank"><xsl:value-of select="@title" /></a>
														<xsl:if test="count(item) &gt; 0">
		<!-- 													<xsl:value-of select="'&lt;div class=&quot;ywc-flyout-indicator&quot;&gt;t&lt;/div&gt;'" disable-output-escaping="yes" /> -->
															<ul>
																<xsl:for-each select="item[@language='en']">
																	<li style="background:url({$bg-img});">
																		<a href="{@url}" target="_blank"><xsl:value-of select="@title" /></a>
																	</li>
																</xsl:for-each>
															</ul>
														</xsl:if>
													</li>
												</xsl:for-each>
											</ul>
										</xsl:if>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:if>
					</li>
				</xsl:for-each>	
			</ul>
			<script type="text/javascript"><!--
				-->YWC.exec.setQueue("YWC.f.intranetInitGlobalNav();");<!--
			--></script>
		</xsl:if> 
		
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