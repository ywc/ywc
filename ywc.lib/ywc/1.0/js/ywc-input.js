/**
* YWC User Input Plugin
*/
// Check for YWC function namespace
if (typeof window.YWC.f != "object") { window.YWC.f = {}; }

// Check for YWC UI namespace
if (typeof window.YWC.ui != "object") { window.YWC.ui = {}; }

YWC.ui.jsOnKeyPressLock = true;


YWC.f.inputTextLabelSet = function(customSelector) {
	var selector = 'input[type=text][title!=""], textarea[title!=""]';
	if (customSelector != null) {
		selector = customSelector;
	}
	$(selector).each(function() {
		if ($.trim($(this).val()) == '') $(this).val($(this).attr('title'));
		if ($(this).val() == $(this).attr('title')) $(this).addClass('ywc-input-label');
	}).focus(YWC.f.inputTextLabelSwitch).blur(YWC.f.inputTextLabelSwitch);
};

YWC.f.inputTextLabelSwitch = function() {
	if ($(this).val() == $(this).attr('title'))
		$(this).val('').removeClass('ywc-input-label');
	else if ($.trim($(this).val()) == '')
		$(this).addClass('ywc-input-label').val($(this).attr('title'));
};

YWC.f.inputGetById = function(id,type,suppressWarning) {
	if (type == null) { var type = ['button','text','checkbox','datetime','fileupload','hidden','select'];
	} else { var type = [type]; }
	for (var i = 0; i < type.length; i++) {
		var obj = document.getElementById('ywc-input-'+type[i]+'-'+id);
		if (obj != null) { return obj; }
	}
	if ((typeof suppressWarning === "boolean") && !suppressWarning) {
		console.log('YWC: no input object found with id \''+id+'\'');
	}
	return null;
};

YWC.f.inputHiddenValueListener = function(id) {
	var inputObj = YWC.f.inputGetById(id,'hidden',true);
	if (inputObj != null) {
		if (inputObj.value != YWC.input.value.hidden[id]) {
			YWC.input.value.hidden[id] = inputObj.value;
		}
		var z = setTimeout("YWC.f.inputHiddenValueListener('"+id+"')",250);
	}
};

YWC.f.inputTextClear = function(id,force,focus) {
	var inputObj = $('input#ywc-input-text-'+id+', textarea#ywc-input-text-'+id);
	var bttnObj = $('img#ywc-input-text-'+id+'-x');
	var plh = inputObj.attr('title');
	if (force) {
		inputObj.val('').blur();
		if ((BrowserDetect.browser !== 'Explorer') && focus) { inputObj.focus(); }
		bttnObj.css('visibility','hidden');
		YWC.input.value.text[id] = "";
	} else {	
		YWC.input.value.text[id] = "";
		var x = setTimeout(function(){
			var val = $.trim(inputObj.val());
			if ((val == '') || (val == plh)) {
				bttnObj.css('visibility','hidden');
			}
		},150);
	}
	YWC.input.meta.valueLength[id] = 0;
};

YWC.f.inputTextFocus = function(id,toggle) {
	if (toggle == null) { var toggle = true; }
	var inputObj = $(YWC.f.inputGetById(id,'text',true));
//	$('input#ywc-input-text-'+id+', textarea#ywc-input-text-'+id).each(function(){
//		var inputObj = $(this);
		if (toggle) {
			if (inputObj.val() != inputObj.attr("title")) {
				inputObj.blur();
			}
			inputObj.focus();
		} else {
			inputObj.blur();
		}
//	});
};

YWC.f.inputTextLoadingIndicator = function(id,toggle) {
	if (toggle == null) { var toggle = true; }
	if (toggle) {
		$("img#ywc-input-text-"+id+"-load").css({'visibility':'visible'});
	} else {
		$("img#ywc-input-text-"+id+"-load").css({'visibility':'hidden'});
	}
};


YWC.f.inputLoadRichText = function(targetSelector) {
	
	var ckEditorVersion = "4.2.1";
	
	if (YWC.f.coreLoadFileAsync("script","ckeditor-base"
				,YWC.uri.pre+"lib/ckeditor/"+ckEditorVersion+"/ckeditor.js"
				,"YWC.f.inputLoadRichText('"+targetSelector+"');") ){
					
	} else if ((typeof CKEDITOR != 'undefined') && 
				YWC.f.coreLoadFileAsync("script","ckeditor-jquery"
				,YWC.uri.cdn+"lib/ckeditor/"+ckEditorVersion+"/adapters/jquery.js"
				,"YWC.f.inputLoadRichText('"+targetSelector+"');") ){
					
	} else if ((typeof CKEDITOR != 'undefined') && (typeof CKEDITOR.instances != 'undefined') && $().ckeditor) {
		
		// destroy previous instances with the same ID
		var domId = $(targetSelector).attr('id');
		var instanceObj = CKEDITOR.instances[domId];
		if (instanceObj) { instanceObj.destroy(true); }
		// create editor
		$(targetSelector).ckeditor(function(){$(targetSelector).css({'visibility':'visible'});},{
			skin:'moono',resize_minWidth:400,language:'en'
			,toolbar: [
				[ 'Undo', 'Redo' ]
				,[ 'PasteText', 'PasteFromWord' ]
				,[ 'Bold', 'Italic', 'Underline', '-', 'Subscript', 'Superscript', '-', 'TextColor', 'BGColor', '-', 'RemoveFormat' ]
				,[ 'Outdent', 'Indent', '-', 'NumberedList', 'BulletedList' ]
				,[ 'Font', 'FontSize' ]
				,[ 'Link', 'Unlink' ]
				,[ 'Table']
				,[ 'SpecialChar']
				,[ 'Source']
			]
	// 		,toolbar: [
	// // { name: 'document', groups: [ 'mode', 'document', 'doctools' ], items: [ 'Source', '-', 'Save', 'NewPage', 'Preview', 'Print', '-', 'Templates' ] },
	// // { name: 'clipboard', groups: [ 'clipboard', 'undo' ], items: [ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ] },
	// // { name: 'editing', groups: [ 'find', 'selection', 'spellchecker' ], items: [ 'Find', 'Replace', '-', 'SelectAll', '-', 'Scayt' ] },
	// // { name: 'forms', items: [ 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField' ] },
	// // { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
	// // { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ], items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'BidiLtr', 'BidiRtl' ] },
	// // { name: 'links', items: [ 'Link', 'Unlink', 'Anchor' ] },
	// // { name: 'insert', items: [ 'Image', 'Flash', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak', 'Iframe' ] },
	// // { name: 'styles', items: [ 'Styles', 'Format', 'Font', 'FontSize' ] },
	// // { name: 'colors', items: [ 'TextColor', 'BGColor' ] },
	// // { name: 'tools', items: [ 'Maximize', 'ShowBlocks' ] },
	// // { name: 'others', items: [ '-' ] }
	// 	/	]
	//		,toolbar:[ [ 'Undo', '-', 'Redo' ]
	//			, [ 'Paste', '-', 'PasteText', '-', 'PasteFromWord' ]
	//			, [ 'Outdent', '-', 'Indent' ]
	//			, [ 'NumberedList', '-', 'BulletedList' ]
	//			, [ 'Font', '-', 'FontSize' ]
			// 	,[ 'Replace','-','SpellChecker' ]
			// 	, [ 'Smiley', '-', 'SpecialChar' ]
			// 	,[ 'Bold', '-', 'Italic', '-', 'Underline', '-', 'Strike', '-', 'Subscript', '-'
			// 		, 'Superscript', '-', 'TextColor', '-', 'BGColor', '-', 'RemoveFormat' ]
		//	 	, [ 'Link', '-', 'Unlink' ]
//			]
			,contentsCss:YWC.uri.pre+"lib/ckeditor/"+ckEditorVersion+"/samples/assets/outputxhtml/outputxhtml.css"
			,baseHref:''
			,blockedKeystrokes:[]
			,browserContextMenuOnCtrl:true
		});
		if (typeof CKEDITOR.instances[domId] != 'undefined') {
			/*CKEDITOR.instances[domId].on('blur', function(){
				var instanceId = targetSelector.substr(targetSelector.indexOf("ywc-input-text-")+15);
				YWC.input.value.text[instanceId] = $(targetSelector).val();
			});*/
			YWC.f.inputRichTextValueListener(targetSelector.substr(targetSelector.indexOf("ywc-input-text-")+15));
		}
	} else {
		var loop = setTimeout("YWC.f.inputLoadRichText('"+targetSelector+"');",10);
	}
};

YWC.f.inputRichTextValueListener = function(id) {
	var inputObj = YWC.f.inputGetById(id,'text',true);
	if (inputObj != null) {
		YWC.input.value.text[id] = $(inputObj).val();
		var z = setTimeout("YWC.f.inputRichTextValueListener('"+id+"')",333);
	}
};

YWC.f.inputCheckBoxValueSet = function(id,checkBoxType,onChangeJs) {
	var checkBoxObj = $("div.ywc-input-checkbox-"+id+" input:checked");
	var prevValue = YWC.input.value.checkbox[id];
	if (checkBoxType == 'checkbox') {
		YWC.input.value.checkbox[id] = [];
		checkBoxObj.each(function(){ YWC.input.value.checkbox[id].push($(this).val()); });
	} else {
		YWC.input.value.checkbox[id] = "";
		checkBoxObj.each(function(){ YWC.input.value.checkbox[id] = $(this).val(); });
	}
	if ((onChangeJs != null) && (YWC.input.value.checkbox[id] != prevValue)) {
		var execOnChangeJs = setTimeout(onChangeJs,25);
	}
};


YWC.f.inputLoadFileUpload = function(fileUploadId,callback) {
	
	var themeUri = "lib/jquery-ui/jquery-ui-themes/"+YWC.ui.jQueryUI.v+"/"+YWC.ui.jQueryUI.theme+"/jquery-ui.css";
	if (YWC.ui.jQueryUI.themeUri != "") { themeUri = YWC.ui.jQueryUI.themeUri; }
	
	if (YWC.input.meta.uploadCallback == null) { YWC.input.meta.uploadCallback = {}; }
	if (YWC.input.meta.uploadCallback[fileUploadId] == null) {
		YWC.input.meta.uploadCallback[fileUploadId] = "";
	}
	if (callback != null) {
		YWC.input.meta.uploadCallback[fileUploadId] = callback;
	}

	window.locale = {
		"fileupload": {
			"errors": {
				"maxFileSize": "File is too big",
				"minFileSize": "File is too small",
				"acceptFileTypes": "Filetype not allowed",
				"maxNumberOfFiles": "Max number of files exceeded",
				"uploadedBytes": "Uploaded bytes exceed file size",
				"emptyResult": "Empty file upload result"
			},
			"error": "Error", "start": "Start",
			"cancel": "Cancel", "destroy": "Complete"
		}
	};


	if (YWC.f.coreLoadFileAsync("script","jquery-ui"
			,YWC.uri.cdn+"lib/jquery-ui/jquery-ui/"+YWC.ui.jQueryUI.v+"/jquery-ui.min.js"
			,"YWC.f.inputLoadFileUpload('"+fileUploadId+"');") ){

	} else if (YWC.f.coreLoadFileAsync("link","jquery-ui"
			,YWC.uri.pre+themeUri
			,"YWC.f.inputLoadFileUpload('"+fileUploadId+"');") ){

	} else if (YWC.f.coreLoadFileAsync("link","jquery-fileupload-ui"
			,YWC.uri.pre+"lib/jquery/jquery-fileupload/jquery-fileupload/5.13/css/jquery.fileupload-ui.css"
			,"YWC.f.inputLoadFileUpload('"+fileUploadId+"');") ){

	} else if (YWC.f.coreLoadFileAsync("link","bootstrap"
			,YWC.uri.pre+"lib/jquery/jquery-fileupload/jquery-fileupload/5.13/css/bootstrap.ywc.min.css"
			,"YWC.f.inputLoadFileUpload('"+fileUploadId+"');") ){

	} else if (YWC.f.coreLoadFileAsync("link","bootstrap-responsive"
			,YWC.uri.pre+"lib/jquery/jquery-fileupload/jquery-fileupload/5.13/css/bootstrap-responsive.min.css"
			,"YWC.f.inputLoadFileUpload('"+fileUploadId+"');") ){

	} else if (YWC.f.coreLoadFileAsync("script","jquery-tmpl"
			,YWC.uri.cdn+"lib/jquery/jquery-fileupload/jquery-tmpl/1.0/jquery-tmpl.min.js"
			,"YWC.f.inputLoadFileUpload('"+fileUploadId+"');") ){
				
	} else if (YWC.f.coreLoadFileAsync("script","jquery-iframe-transport"
			,YWC.uri.cdn+"lib/jquery/jquery-fileupload/jquery-fileupload/5.13/js/jquery.iframe-transport.js"
			,"YWC.f.inputLoadFileUpload('"+fileUploadId+"');") ){
				
	} else if (YWC.f.coreLoadFileAsync("script","jquery-xdr-transport"
			,YWC.uri.cdn+"lib/jquery/jquery-fileupload/jquery-fileupload/5.13/js/cors/jquery.xdr-transport.js"
			,"YWC.f.inputLoadFileUpload('"+fileUploadId+"');") ){

	} else if ( (typeof $.widget != 'undefined')
			&&	YWC.f.coreLoadFileAsync("script","jquery-fileupload"
			,YWC.uri.cdn+"lib/jquery/jquery-fileupload/jquery-fileupload/5.13/js/jquery.fileupload.js"
			,"YWC.f.inputLoadFileUpload('"+fileUploadId+"');") ){

	} else if ( 
			YWC.f.coreLoadFileAsync("script","jquery-fileupload-fp"
			,YWC.uri.cdn+"lib/jquery/jquery-fileupload/jquery-fileupload/5.13/js/jquery.fileupload-fp.js"
			,"YWC.f.inputLoadFileUpload('"+fileUploadId+"');") ){
	
	} else if ( 
			YWC.f.coreLoadFileAsync("script","jquery-fileupload-ui"
			,YWC.uri.cdn+"lib/jquery/jquery-fileupload/jquery-fileupload/5.13/js/jquery.fileupload-ui.js"
			,"YWC.f.inputLoadFileUpload('"+fileUploadId+"');") ){
							
	} else if (	$().fileupload && $().submit
			&&	(typeof window.tmpl != 'undefined')
		) {
		var draw = setTimeout("YWC.f.inputDrawFileUpload('"+fileUploadId+"',{});",20);
	} else {
		var loop = setTimeout("YWC.f.inputLoadFileUpload('"+fileUploadId+"');",20);
	}
}

YWC.f.inputDrawFileUpload = function(fileUploadId,inputParams){
	
	var uploadOptions = {
		autoUpload:true
		,limitMultiFileUploads:3
		,sequentialUploads:true
		,maxNumberOfFiles:100
		,redirect:YWC.uri.pre+"lib/jquery/jquery-fileupload/jquery-fileupload/5.13/cors/result.html?%s"
	};
	
	if (inputParams != null) {
		for (i in inputParams) { uploadOptions[i] = inputParams[i]; }
	}
	
	$("#"+fileUploadId).fileupload(uploadOptions)
		.bind("fileuploadfail",function(e,data){
			alert('Upload Failed...');
		}).bind("fileuploaddone",function(e,data){
			if (YWC.input.value.file[fileUploadId] == null) {
				YWC.input.value.file[fileUploadId] = [];
			}
			if (data.result[0].media_id != null) { 
				for (var i = 0; i < data.result.length; i++) {
					var media_id = data.result[i].media_id;
					var addToList = true;
					for (var j = 0; j < YWC.input.value.file[fileUploadId].length; j++) {
						if (YWC.input.value.file[fileUploadId][j].media_id==media_id) {
							addToList = false;
						}
					}
					if (addToList) {
						YWC.input.value.file[fileUploadId].push(data.result[i]);
					}
				}
			}
			
			var uploadCallback = setTimeout(YWC.input.meta.uploadCallback[fileUploadId],25);
		});
	$("#ywc-fileupload-"+fileUploadId+"-container").css({'visibility':'visible'});
	
}


YWC.f.inputLoadSelectMenu = function(targetSelector,optionString) {
		
	var themeUri = "lib/jquery-ui/jquery-ui-themes/"+YWC.ui.jQueryUI.v+"/"+YWC.ui.jQueryUI.theme+"/jquery-ui.css";
	if (YWC.ui.jQueryUI.themeUri != "") { themeUri = YWC.ui.jQueryUI.themeUri; }
	
	if (YWC.f.coreLoadFileAsync("script","jquery-ui"
			,YWC.uri.cdn+"lib/jquery-ui/jquery-ui/"+YWC.ui.jQueryUI.v+"/jquery-ui.min.js"
			,"YWC.f.inputLoadSelectMenu(\""+targetSelector+"\",\""+optionString+"\");") ){

	} else if (YWC.f.coreLoadFileAsync("link","jquery-ui"
			,YWC.uri.pre+themeUri
			,"YWC.f.inputLoadSelectMenu(\""+targetSelector+"\",\""+optionString+"\");") ){

	} else if (YWC.f.coreLoadFileAsync("link","jquery-ui-selectmenu"
			,YWC.uri.pre+"lib/jquery-ui/jquery-ui-selectmenu/1.2.0/jquery-ui-selectmenu.css"
			,"YWC.f.inputLoadSelectMenu(\""+targetSelector+"\",\""+optionString+"\");") ){
				
	} else if (	(typeof $.widget != 'undefined')
			&&	YWC.f.coreLoadFileAsync("script","jquery-ui-selectmenu"
			,YWC.uri.cdn+"lib/jquery-ui/jquery-ui-selectmenu/1.2.0/jquery-ui-selectmenu.js"
			,"YWC.f.inputLoadSelectMenu(\""+targetSelector+"\",\""+optionString+"\");") ){
				
	} else if ($().selectmenu) {
		var draw = setTimeout("$(\""+targetSelector+"\").selectmenu("+optionString+");"
					+"$(\""+targetSelector+"\").css({'visibility':'visible'});",10);
	} else {
		var loop = setTimeout("YWC.f.inputLoadSelectMenu(\""+targetSelector+"\",\""+optionString+"\");",10);
	}
}

YWC.f.inputJsOnKeyPress = function(wh,selector,js,min_length) {
	if (min_length == null) { min_length = 2; }
	$(selector).keyup(function(pressed){
		if (pressed.which == 13) {
			if ((wh == "rtrn") || (wh == "return") || (wh == "enter") || (parseInt(wh) == 13)) {
				pressed.preventDefault();
				var z = setTimeout(js,10);
			}
		} else if (pressed.which == 27) {
			if ((wh == "esc") || (wh == "escape") || (parseInt(wh) == 27)) {
					pressed.preventDefault();
					var z = setTimeout(js,10);
			}
		} else if (wh == 'any') {
			var val = $(this).val();
			if (val.length >= min_length) {
				if (YWC.ui.jsOnKeyPressLock == true) {
					var y = setTimeout(function(){
						var z = setTimeout(js+';if(YWC.ui.jsOnKeyPressLock==false){YWC.ui.jsOnKeyPressLock=true;}',10);
					},250);
					YWC.ui.jsOnKeyPressLock = false;
				}
			}
		}	
	});
}



YWC.input.meta.dateTime[0].obj = null;
YWC.input.meta.dateTime[0].onLoad = null;
YWC.input.meta.dateTime[0].onChange = {};
YWC.input.meta.dateTime[0].value = {};
YWC.input.meta.dateTime[0].eventRank = [];
YWC.input.meta.dateTime[0].eventObj = {};
if ( YWC.input.meta.dateTime[0].format['date'] == null ) { YWC.input.meta.dateTime[0].format['date'] = "dd/mm/yy"; }
if ( YWC.input.meta.dateTime[0].format['12h'] == null ) { YWC.input.meta.dateTime[0].format['12h'] = false; }


YWC.f.inputDateTimeLoad = function(wh,ywcId,onChange) {
	var index = 0;
	if (onChange != null) { YWC.input.meta.dateTime[index].onChange[ywcId] = onChange; }
	
	var themeUri = "lib/jquery-ui/jquery-ui-themes/"+YWC.ui.jQueryUI.v+"/"+YWC.ui.jQueryUI.theme+"/jquery-ui.css";
	if (YWC.ui.jQueryUI.themeUri != "") { themeUri = YWC.ui.jQueryUI.themeUri; }
		
	if (YWC.f.coreLoadFileAsync("script","jquery-ui"
			,YWC.uri.cdn+"lib/jquery-ui/jquery-ui/"+YWC.ui.jQueryUI.v+"/jquery-ui.min.js"
			,"YWC.f.inputDateTimeLoad('"+wh+"','"+ywcId+"');")) {

	} else if (YWC.f.coreLoadFileAsync("link","jquery-ui"
			,YWC.uri.pre+themeUri
			,"YWC.f.inputDateTimeLoad('"+wh+"','"+ywcId+"');")) {
				
	} else if (YWC.f.coreLoadFileAsync("script","jquery-ui-timepicker"
			,YWC.uri.cdn+"lib/jquery-ui/jquery-ui-timepicker/0.3.1/jquery-ui-timepicker.js"
			,"YWC.f.inputDateTimeLoad('"+wh+"','"+ywcId+"');")) {

	} else if (YWC.f.coreLoadFileAsync("link","jquery-ui-timepicker"
			,YWC.uri.pre+"lib/jquery-ui/jquery-ui-timepicker/0.3.1/jquery-ui-timepicker.css"
			,"YWC.f.inputDateTimeLoad('"+wh+"','"+ywcId+"');")) {
				
	} else if ($().datepicker && $().timepicker) {
		var draw = setTimeout("YWC.f.inputDateTimeDraw('"+wh+"','"+ywcId+"');",10);
	} else {
		var loop = setTimeout("YWC.f.inputDateTimeLoad('"+wh+"','"+ywcId+"');",10);
	}

}

YWC.f.inputDateTimeDraw = function(wh,ywcId) {
	var index = 0;
	var uiObj = $("input#ywc-input-datetime-"+ywcId);
	var dateObj = YWC.f.dateConvert(uiObj.val(),{'type':'object','resolutionInSeconds':300});
	if (//check to see if input already been formatted. added to avoid double parse error in MSIE 9 and below
		(dateObj.valueOf() > 100000000000) // if input is double as formatted by XSL
	//	 || !isNaN(parseInt(uiObj.val())) // BUGGY: if input is an integer, doesn't work for some reason
		) {
		var dateArr = [ dateObj.getDate(),(dateObj.getMonth()+1),dateObj.getFullYear()
					,dateObj.getHours(),dateObj.getMinutes()];
		var instanceId = ywcId.substr(5);
		YWC.f.inputDateTimeSumValue(index,instanceId);
		
		if (wh == "date") {
			uiObj.val($.datepicker.formatDate(YWC.input.meta.dateTime[index].format.date, dateObj));
			uiObj.datepicker({ dateFormat:YWC.input.meta.dateTime[index].format.date, changeYear:true
				, onSelect:function(d,i){
					YWC.input.meta.dateTime[index].value[instanceId].date = Date.parse($(this).datepicker('getDate'));
					YWC.f.inputDateTimeSumValue(index,instanceId);
				
					if (YWC.input.meta.dateTime[index].onChange[ywcId] != null) {
						YWC.exec.setQueue(YWC.input.meta.dateTime[index].onChange[ywcId]);
					}
				}
			});
		
			YWC.input.meta.dateTime[index].value[instanceId].date = Date.parse(uiObj.datepicker('getDate'));
			YWC.f.inputDateTimeSumValue(index,instanceId);
		
		} else if (wh == "time") {
			if (dateArr[4]<10) { dateArr[4] = "0"+dateArr[4]; }
			var dateStr = dateArr[3]+":"+dateArr[4];
			if (YWC.input.meta.dateTime[index].format['12h']) {
				if (dateArr[3]==0) { var dateStr = "12:"+dateArr[4]+" AM"; }
				else if (dateArr[3]>12) { var dateStr = (dateArr[3]-12)+":"+dateArr[4]+" PM"; }
				else { dateStr += " AM"; }
			}
		
			uiObj.val(dateStr);
			uiObj.timepicker({ hourText:'Time (Hour)'
				,showLeadingZero: false, showMinutesLeadingZero: true
				,showPeriod: YWC.input.meta.dateTime[index].format['12h']
				,onSelect:function(d,i){
					YWC.input.meta.dateTime[index].value[instanceId].time = YWC.f.strTimeToMilliSeconds(d);
					YWC.f.inputDateTimeSumValue(index,instanceId);
					if (YWC.input.meta.dateTime[index].onChange[ywcId] != null) {
						YWC.exec.setQueue(YWC.input.meta.dateTime[index].onChange[ywcId]);
					}
				}
			});
			YWC.input.meta.dateTime[index].value[instanceId].time = YWC.f.strTimeToMilliSeconds(dateStr);
			YWC.f.inputDateTimeSumValue(index,instanceId);
		}
		uiObj.css({'visibility':'visible','z-index':1001});
	} else {
		console.log('YWC: inputDateTimeDraw -> skipped \''+ywcId+'\' due to value '+dateObj.valueOf())
	}
}

YWC.f.inputDateTimeSumValue = function(scheduleIndex,instanceId){
	
	if (YWC.input.meta.dateTime[scheduleIndex].value[instanceId] == null) {
		YWC.input.meta.dateTime[scheduleIndex].value[instanceId] = {'date':0,'time':0};
		YWC.input.value.datetime[instanceId] = 0;
	} else {
		YWC.input.value.datetime[instanceId] = (
			YWC.input.meta.dateTime[scheduleIndex].value[instanceId].date
			+YWC.input.meta.dateTime[scheduleIndex].value[instanceId].time);
	}
}

YWC.f.inputButtonClick = function(bttnObj,force) {
	if (force==null) { var force = false; }
	var bttnJq = $(bttnObj);
	var bttnId = bttnJq.attr('id').substr(17);
	
	if (YWC.input.meta.button[bttnId].isClickable || force) {
		if (!YWC.input.value.button[bttnId]) {
			YWC.f.uiDoClassToggle(bttnObj,YWC.input.meta.button[bttnId].classAlreadyClicked);
			if (YWC.input.meta.button[bttnId].label[1] != "") {
				bttnJq.find("span.ywc-input-button-label")
					.addClass("ywc-input-button-label-on")
					.html(YWC.input.meta.button[bttnId].label[1]);
			}
			if (YWC.input.meta.button[bttnId].labelCircle[1] != "") {
				bttnJq.find("div.ywc-input-button-circle div")
				.addClass("ywc-input-button-circle-on")
				.html(YWC.input.meta.button[bttnId].labelCircle[1]);
			}
			if (YWC.input.meta.button[bttnId].labelCircle[0] != "") {
				bttnJq.find("div.ywc-input-button-circle img").each(function(){
					YWC.f.uiDoImageToggle(this,true);
				});
			}
			YWC.input.value.button[bttnId] = true;
			return true;
		} else if (YWC.input.meta.button[bttnId].isUnClickable || force) {
			YWC.f.uiDoClassToggle(bttnObj,YWC.input.meta.button[bttnId].classAlreadyClicked);
			if (YWC.input.meta.button[bttnId].label[0] != "") {
				bttnJq.find("span.ywc-input-button-label")
				.removeClass("ywc-input-button-label-on")
				.html(YWC.input.meta.button[bttnId].label[0]);
			}
			if (YWC.input.meta.button[bttnId].labelCircle[0] != "") {
				bttnJq.find("div.ywc-input-button-circle div")
				.removeClass("ywc-input-button-circle-on")
				.html(YWC.input.meta.button[bttnId].labelCircle[0]);
			}
			if (YWC.input.meta.button[bttnId].labelCircle[0] != "") {
				bttnJq.find("div.ywc-input-button-circle img").each(function(){
					YWC.f.uiDoImageToggle(this,false);
				});
			}
			YWC.input.value.button[bttnId] = false;
			return true;
		}
	}
	return false;
}
