<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" xmlns:yweather="http://xml.weather.yahoo.com/ns/rss/1.0" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" exclude-result-prefixes="xs xsl ywc yweather geo">
<xsl:param name="uri" as="xs:string" select="'/'" />
<xsl:param name="params" as="xs:string" select="''" />
<xsl:param name="lang" as="xs:string" select="'en'" />
<xsl:param name="cache_path" as="xs:string" select="'-'" />
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />

<xsl:include href="../../../ywc/1.0/inc/ywc-core.xsl" />
<xsl:include href="../../../ywc/1.0/ui-elements/ywc-header.xsl" />
<xsl:include href="../../../ywc-intranet/1.0/widget/ywc-intranet-weather.xsl" />
<xsl:include href="../inc/iter-core.xsl" />

<xsl:template match="/">
	<!--  -->
	<xsl:if test="ywc:getParam('id', $params) = 'safety-numbers'">
		<span style="font-weight:bold;font-size:16px;">ITER Safety Contact Phone Numbers</span>
		<br /><br />
		<span style="font-size:12px;"><a target="_blank" href="//static-1.iter.org/buzz/img/quicklaunch/popup/cell_phone_1.jpg">
		<img src="//static-1.iter.org/buzz/img/quicklaunch/popup/cell_phone_1.jpg" style="border:none;cursor:pointer;float:right;clear:right;margin:0px 0px 5px 5px;" />
		</a>
		<div>
			<div>
				<strong><font size="2">
					<div style="display:inline !important">
						<div style="display:inline !important">
							<strong><font size="2">
								<div style="display:inline !important">
									<font class="Apple-style-span" face="arial">CEA Fire &amp; Rescue Team:</font>
								</div>
							</font></strong>
						</div>
					</div>
				</font></strong>
				<br />
			</div>
			<div>
				<strong><font size="2">
					<div>
						<div style="font-family:arial;font-size:11px;font-weight:normal">
							<font size="2" style="line-height:normal">
								<a title="" href="tel:+33442252218">+33 4 42 25 22 18</a>
							</font>
						</div>
					</div>
					<div style="font-family:arial"><br /></div>
					<div style="font-family:arial">ITER Guard house (working hours) for on-site incidents:</div>
				</font></strong>
			</div>
			<div style="font-family:arial">
				<font size="2">
					<a title="" href="tel:+33628681160">+33 6 28 68 11 60</a> or <a title="" href="tel:+33442171910">+33 4 42 17 19 10</a>
				</font>
			</div>
			<div style="font-family:arial"><strong><font size="2"></font></strong></div>
			<div style="font-family:arial">
				<strong><font size="2">24h/24h, On-Duty for on-site incidents:</font></strong>
			</div>
			<div style="font-family:arial">
				<font size="2"><a title="" href="tel:+33634522512">+33 6 34 52 25 12</a></font>
			</div>
			<div style="font-family:arial"><strong><font size="2"></font></strong></div>
			<div style="font-family:arial">
				<strong><font size="2">24h/24h Emergency Number (any off-site incidents): </font></strong>
			</div>
			<div style="font-family:arial">
				<font size="2"><a title="" href="tel:+33619649851">+33 6 19 64 98 51</a></font>
			</div>
			<div style="font-family:arial"><strong><font size="2"></font></strong></div>
			<div style="font-family:arial"><strong><font size="2">Building Safety Contacts: (not for emergencies):</font></strong></div>
			<div style="font-family:arial"><strong><font size="2"></font></strong></div>
			<div style="font-family:arial">
				<div>
					<a href="https://user.iter.org/?uid=4DMQJ9&amp;action=get_document"><font color="#0000ff" face="Calibri">https://user.iter.org/?uid=4DMQJ9&amp;action=get_document</font></a>
				</div>
			<div></div>
			<div><div><font size="2"></font></div>
			<div><font size="2"><strong>ITER Info Line</strong></font></div>
			<div><a title="" href="tel:+33442176099">+33 4 42 17 60 99</a></div>
			</div>
			</div>
		</div>
		<br />
		</span>
	</xsl:if>
	<!--  -->
	<xsl:if test="ywc:getParam('id', $params) = 'safety'">
		<span style="font-weight:bold;font-size:16px;">Integrated Safety, Quality and Security Management Policy</span><br /><br /><span style="font-size:12px;"><a target="_blank" href="//static-1.iter.org/buzz/img/quicklaunch/popup/ISMS_policy_signed_b.jpg"><img src="//static-1.iter.org/buzz/img/quicklaunch/popup/ISMS_policy_signed.jpg" style="border:none;cursor:pointer;float:right;clear:right;margin:0px 0px 5px 5px;" /></a><div class="ExternalClassB45FC02F8F3342968568EC5D77726124">Below you will find a full summary of ITER's <strong>Integrated Safety, Quality and Security Management Policy</strong>, currently in effect.</div> <div class="ExternalClassB45FC02F8F3342968568EC5D77726124"><br /></div> <div class="ExternalClassB45FC02F8F3342968568EC5D77726124">The Safety, Quality &amp; Security Department also invites you to respond to this policy with comments, questions or suggestions. To do so, please send an e-mail to <a href="mailto:sqs-suggestions@iter.org" target="_blank">sqs-suggestions@iter.org?.?</a><br /></div> <div class="ExternalClassB45FC02F8F3342968568EC5D77726124"><br /></div> <div>Click the image to the right to view the official document, signed and approved by Director-General Motojima. This official document (<a href="https://user.iter.org/?uid=43UJN7" target="_blank">43UJN7</a>) can also be found <a href="https://user.iter.org/?uid=43UJN7" target="_blank">here</a> in IDM.</div> <div><hr /> <br /></div> <div style="font-size:16px"><strong>Integrated Safety, Quality and Security Management Policy</strong></div> <span style="font-size:16px"> </span> <div class="ExternalClassB45FC02F8F3342968568EC5D77726124"><ul></ul></div> <div class="ExternalClassB45FC02F8F3342968568EC5D77726124">Prevention of injuries and illnesses to all affected parties (employees, contractors, visiting teams and community), minimization of impact to the environment, and ensuring that activities are performed at quality levels appropriate to teh Safety and Performance objectives of the project are are all priorities in the planning and execution of ITER work at all stages. The Organization commits to these objectives by:</div> <div class="ExternalClassB45FC02F8F3342968568EC5D77726124"><ul><li>Implementing? the Headquarters Agreement signed with the Host State on November 7, 2007<br /></li> <li>Implementing a management system in accordance with IAEA GS-R-3, and incorporating the Quality and Safety requirements of the 1984 French Quality Order.</li> <li>Ensuring Human and Capital Resources for Quality and Integrated Safety as a top priority in all of ITER life phases.</li> <li>Setting up an Integrated Safety¹? Management System (ISMS) and a Management and Quality Program (MQP), with a Continuous Improvement Strategy.</li> <li>Ensuring that Domestic Agencies and Suppliers follow applicable Management System requirements</li> <li>Auditing the implementation and the maintenance of the Management Systems</li> <li>Encouraging a responsible, transparent, open and participative Safety and Security Culture throughout the Organization</li> <li>Promoting Leadership Commitment</li> <li>Ensuring competence and training throughout the organization appropriate for each function</li> <li>Creating channels to encourage internal communication, diffusing lessons learned and experience feedback</li> <li>Reporting, tracking, categorizing, analyzing, and acting upon all categories of adverse events</li> <li>Benchmarking the Management Systems (ISMS+MQP) and their performances with those of other Nuclear Installations worldwide</li> <li>Ensuring periodical Management Reviews of the Systems and their performances, including this Policy</li></ul> This policy is communicated to all staff, contractors and visitors at ITER, and Domestic Agencies.</div> <div class="ExternalClassB45FC02F8F3342968568EC5D77726124"><br /></div> <div class="ExternalClassB45FC02F8F3342968568EC5D77726124" style="font-size:11px"><em>¹ Article 14 of the Agreement on the Establishment of the ITER International Fusion energy Organization sets forward the concept of Integrated Safety: &quot;The ITER Organization shall observe applicable national laws and regulations of the Host State in the fields of public and occupational health and safety, nuclear safety, radiation protection, licensing, nuclear substances, environmental protection and protection from acts of malevolence.&quot; </em></div> <span style="font-size:11px"> </span><span style="font-size:11px"> </span><br /></span>
	</xsl:if>
	<!--  -->
	<xsl:if test="ywc:getParam('id', $params) = 'suggestions'">
		<span style="font-weight:bold;font-size:16px;">Buzz Suggestion Box</span><br /><br /><span style="font-size:12px;"><a target="_blank" href="//static-1.iter.org/buzz/img/quicklaunch/popup/suggestion_box_b.jpg"><img src="//static-1.iter.org/buzz/img/quicklaunch/popup/suggestion_box.jpg" style="border:none;cursor:pointer;float:right;clear:right;margin:0px 0px 5px 5px;" /></a><div class="ExternalClassF631ED9013CE493B8D09432BBDFA8DBE"><br /><br /> <div>We are very interested in your suggestions about how to improve Buzz. Buzz is, after all, here to help you, so please let us know what you think!</div> <div><strong><font size="2"></font></strong> </div> <div>To do so, please send an e-mail to:</div> <div><strong><font size="2"></font></strong> </div> <div><a href="mailto:buzz-suggestions@iter.org">buzz-suggestions@iter.org</a></div> <div><strong><font size="2"></font></strong> </div> <div>We look forward to hearing from you!</div></div><br /></span>
	</xsl:if>
	<!--  -->
</xsl:template>

</xsl:stylesheet>
