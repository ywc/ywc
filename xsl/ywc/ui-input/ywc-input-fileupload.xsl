<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ywc="http://www.iter.org/ywc" exclude-result-prefixes="xs xsl ywc">
<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" />


<xsl:template name="ywcInputFileUpload">
	<xsl:param name="preUri" as="xs:string" select="'/'" />
	<xsl:param name="lang" as="xs:string" select="." />
	<xsl:param name="id" as="xs:string" select="'anonymous'" />
	<xsl:param name="targetUri" as="xs:string" select="'input/file'" />
	<xsl:param name="onSuccessJs" as="xs:string" select="''" />
	<xsl:param name="width" as="xs:integer" select="0" />
	<xsl:param name="maxFiles" as="xs:integer" select="25" />
	<xsl:param name="paramNames" as="xs:string*" select="()" />
	<xsl:param name="paramValues" as="xs:string*" select="()" />
	<xsl:param name="isRequired" as="xs:integer" select="0" />

	<div id="ywc-fileupload-{$id}-container" class="ui-widget-header ywc-crnr-5 ywc-fileupload"
		style="width:{
			if ($width != 0) then concat($width,'px') else '100%'
		};visibility:hidden;">
		
	    <!-- The file upload form used as target for the file upload widget -->
	    <form id="{$id}" class="ywc-fileupload" method="POST" enctype="multipart/form-data"
			action="{if (contains($targetUri,'://')) then '' else $preUri}{$targetUri}{
					if (string-length($paramNames[1]) &gt; 0) then concat('?',$paramNames[1],'=',$paramValues[1]) else ''
				}{	if (string-length($paramNames[2]) &gt; 0) then concat('&amp;',$paramNames[2],'=',$paramValues[2]) else ''	
				}{	if (string-length($paramNames[3]) &gt; 0) then concat('&amp;',$paramNames[3],'=',$paramValues[3]) else ''
				}">
	        
			<!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
	        <div class="row fileupload-buttonbar">
	            <div class="span7" style="width:100%;">
	                <!-- The fileinput-button span is used to style the file input field as button -->
	                <span class="btn btn-success fileinput-button" style="margin-bottom:5px;margin-left:30px;">
						<xsl:value-of disable-output-escaping="yes"
							select="'&lt;i class=&quot;icon-plus icon-white&quot;&gt;&lt;/i&gt;'" />
	                    <span>Add files...</span>
	                    <input type="file" name="files[]">
							<xsl:if test="$maxFiles &gt; 1">
							<xsl:attribute name="multiple" select="'multiple'" />
							</xsl:if>
						</input>
	                </span>
	                <button type="submit" class="btn btn-primary start" style="display:none;">
						<xsl:value-of disable-output-escaping="yes"
							select="'&lt;i class=&quot;icon-upload icon-white&quot;&gt;&lt;/i&gt;'" />
	                    <span>Start upload</span>
	                </button>
	                <button type="reset" class="btn btn-warning cancel" style="float:right;display:none;">
						<xsl:value-of disable-output-escaping="yes"
							select="'&lt;i class=&quot;icon-ban-circle icon-white&quot;&gt;&lt;/i&gt;'" />
	                    <span>Clear List</span>
	                </button>
	                <button type="button" class="btn btn-danger delete" style="display:none;">
						<xsl:value-of disable-output-escaping="yes"
							select="'&lt;i class=&quot;icon-trash icon-white&quot;&gt;&lt;/i&gt;'" />
	                    <span>Delete</span>
	                </button>
				
				<input type="checkbox" class="toggle" checked="checked" style="display:none;" />
			</div>
			<!-- The global progress information -->
			<div class="span5 fileupload-progress fade" style="display:none;">
				<!-- The global progress bar -->
				<div class="progress progress-success progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100">
					<xsl:value-of disable-output-escaping="yes"
						select="'&lt;div class=&quot;bar&quot; style=&quot;width:0%;&quot;&gt;&lt;/div&gt;'" />
				</div>
				<!-- The extended global progress information -->
				<!--
				<xsl:value-of disable-output-escaping="yes"
					select="'&lt;div class=&quot;progress-extended&quot;&gt;&amp;nbsp;&lt;/div&gt;'" />
				-->
			</div>
		</div>
		<!-- The loading indicator is shown during file processing -->
		<xsl:value-of disable-output-escaping="yes"
			select="'&lt;div class=&quot;fileupload-loading&quot;&gt;&lt;/div&gt;'" />
		<br />
		<!-- The table listing the files available for upload/download -->
		<table role="presentation" class="table table-striped">
			<xsl:value-of disable-output-escaping="yes"
				select="'&lt;tbody class=&quot;files&quot; data-toggle=&quot;modal-gallery&quot; data-target=&quot;#modal-gallery&quot;&gt;&lt;/tbody&gt;'" />
		</table>
		
	    </form>
	</div>
	
	<!-- load external JS templates -->
	<xsl:value-of select="unparsed-text('ywc-input-fileupload-template.html')" disable-output-escaping="yes" />
	
	<script type="text/javascript"><!--
		-->$(function(){<!--
			-->YWC.f.inputLoadFileUpload(<!--
				-->'<xsl:value-of select='replace($id,"&apos;","\\&apos;")' />'<!--
				-->,'<xsl:value-of select='replace($onSuccessJs,"&apos;","\\&apos;")' />'<!--
				-->);<!--
			-->YWC.input.meta.validation.required[<!--
				-->'<xsl:value-of select='replace($id,"&apos;","\\&apos;")' />'<!--
				-->]=<!--
			--><xsl:value-of select="if ($isRequired = 1) then 'true' else 'false'" /><!--
				-->;<!--
			-->YWC.input.meta.validation.type[<!--
				-->'<xsl:value-of select='replace($id,"&apos;","\\&apos;")' />'<!--
				-->]='file';<!--

		-->});<!--
	--></script>
	
</xsl:template>

</xsl:stylesheet>