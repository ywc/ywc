
YWC.f.coreSetDefault("intranet","authCheckToggle",true);
YWC.f.coreSetDefault("intranet","authCheckUri",YWC.uri.pre+'bws/action/auth/check');

YWC.f.coreSetDefault("intranet","subscribeUri",YWC.uri.pre+'bws/action/list/');

YWC.f.coreSetDefault("intranet","uriUploadFile",YWC.uri.pre+"input/file");

YWC.f.coreSetDefault("intranet","uiHeaderColor",'bbbbbb');
YWC.f.coreSetDefault("intranet","uiHeaderBgColor",'444444');

YWC.f.coreSetDefault("intranet","uriDeletePost","bws/action/ywc_");
YWC.f.coreSetDefault("intranet","methodDeletePost","DELETE");
YWC.f.coreSetDefault("intranet","dataTypeDeletePost","json");

YWC.f.coreSetDefault("intranet","uriSubmitPost","bws/action/ywc_");
YWC.f.coreSetDefault("intranet","methodSubmitPost","POST");
YWC.f.coreSetDefault("intranet","dataTypeSubmitPost","json");

YWC.f.coreSetDefault("intranet","uriSendEmail",YWC.uri.pre+"bws/action/sendmail");
YWC.f.coreSetDefault("intranet","methodSendEmail","POST");
YWC.f.coreSetDefault("intranet","dataTypeSendEmail","json");

YWC.f.coreSetDefault("intranet","autoRefreshLists",[]);
YWC.f.coreSetDefault("intranet","autoRefreshInterval",60000);

YWC.f.coreSetDefault("intranet","uiGlobalNavFlyout",false);

YWC.f.intranetCheckAuth = function(callback,skipToPopout) {
	if (callback == null) { var callback = ""; }
	if (!YWC.intranet.authCheckToggle) {
		var x = setTimeout(callback,25);
		if (YWC.user.id == '') { YWC.f.intranetAuthIdentity(); }
	} else {
		window.ywcAuthCallback = null;
		if (callback != null) {
			window.ywcAuthCallback = function() {
				YWC.f.popupKill(2,true);
				var x = setTimeout(callback,25);
				if (YWC.user.id == '') { YWC.f.intranetAuthIdentity(); }
			};
		}
		
		if ((skipToPopout == null) || !skipToPopout) {
			$.ajax({ type: "GET", dataType: "html", data: {}
				,url: YWC.intranet.authCheckUri
				,beforeSend:function(){ YWC.f.uiAlertToggle({'toggle':true}); }
				,error:function(d) {
					YWC.f.uiAlertToggle({'toggle':false});
					YWC.f.intranetAuthPopup(); }
				,success:function(d) {
					if (d.indexOf('success') > -1) {
						var x = setTimeout(callback,25);
						if (YWC.user.id == '') { YWC.f.intranetAuthIdentity(); }
					} else {
						YWC.f.intranetAuthPopup();
					}
				},complete:function(){
					YWC.f.uiAlertToggle({'toggle':false});
				}
			});
		} else {
			YWC.f.intranetAuthPopout();
		}
	}
}

YWC.f.intranetAuthPopup = function() {
	YWC.f.popupLoad({
		'z':2, 'id':'ywc-auth-popup', 'width':280
		,'source':YWC.uri.pre+'ywc/intranet/popup/auth'
		,'bgToggle':true
		,'params':{'onClickJs':'YWC.f.intranetAuthPopout();'
			,'siteTitle':''
			,'accountType':''
		}
	});
}

YWC.f.intranetAuthPopout = function() {
	window.open(YWC.intranet.authCheckUri,'','width=620,height=360,scrollbars=no,toolbar=no,location=no,resizable=no');
}

YWC.f.intranetAuthIdentity = function() {
	var whoamiUri = 'ywc/intranet/whoami';
	if (YWC.intranet.authCheckToggle) { whoamiUri = 'alt/'+whoamiUri; }
	$.ajax({ type: "GET", dataType: "xml", data: null
		,url: YWC.uri.pre+whoamiUri
		,success:function(d) {
			YWC.user.id = $(d).find('user').attr('uid');
			$(".ywc-intranet-login-uid a").attr({"href":"#"}).html("User: "+YWC.user.id);
		}
	});
}

YWC.f.intranetPopupDetailUtility = function(listName,assetId,wh) {
	
	var anchorOn = ['right','bottom','bottom','left'];
	
	YWC.f.popupLoad({
		'source':YWC.uri.pre+'ywc/intranet/popup/utility'
		,'id':'ywc-intranet-popup-utility-'+assetId+'-'+wh
		,'width':400, 'top':-20, 'z':2, 'dragEnabled':false
		,'anchorObj':document.getElementById('ywc-container-popup-detail-'+listName+'-'+assetId+'-img-'+wh)
		,'anchorOn':anchorOn[wh-1], 'shadowToggle':false
		,'brdrWidth':1,'xInvert':true
		,"xColor":"888888","brdrColor":"888888"
		,'params':{'action':wh,'assetId':assetId}
	});
}

YWC.f.intranetPopupQuickLinks = function(anchorObj) {
	YWC.f.popupLoad({'width':250,'top':-10
		,'xWidth':33,'xOffset':10,'dragEnabled':false
		,'marginWidth':10
		,'anchorObj':anchorObj,'anchorOn':'right'
		,'source':YWC.uri.pre+'ywc/intranet/popup/links'
		,'params':{
			'linkTitle':$(anchorObj).attr('title')
		}
	});
}

YWC.f.intranetSubscribePopup = function(listName){
	YWC.f.popupLoad({
		'source':YWC.uri.pre+'ywc/intranet/popup/subscribe'
		,'z':'1','width':320,'dragEnabled':false
		,'anchorObj':document.getElementById('ywc-list-controls-bttn-subscribe-'+listName)
		,'anchorOn':'bottom','id':'ywc-intranet-subscribe'
		,'params':{'listName':listName}
	});
}

YWC.f.intranetPopupDirectory = function(anchorObj,anchorOn) {

	if (anchorOn == null) { var anchorOn = 'left'; }

	YWC.f.popupLoad({
		'width':400,'top':-30
		,'anchorOn':anchorOn,'anchorObj':anchorObj
		,'z':1,'dragEnabled':false
		,'source':YWC.uri.pre+'ywc/intranet/popup/directory'
		,'id':'ywc-intranet-directory'
		,'params':{
			'uiHeaderColor':YWC.intranet.uiHeaderColor
			,'uiHeaderBgColor':YWC.intranet.uiHeaderBgColor
			,'uiFallbackImage':YWC.intranet.uiFallbackImage
		}
	});
}

YWC.f.intranetPopupNews = function(listName,articleId) {
	YWC.f.popupLoad({
		'width':600,'top':70,'z':1
		,'source':YWC.uri.pre+'ywc/intranet/popup/news'
		,'id':'ywc-intranet-news-article'
		,'params':{
			'listName':listName
			,'articleId':articleId
			,'uiHeaderColor':YWC.intranet.uiHeaderColor
			,'uiHeaderBgColor':YWC.intranet.uiHeaderBgColor
			,'uiFallbackImage':YWC.intranet.uiFallbackImage
		},'callback':function(){
			YWC.f.intranetFormatDateTime();
		}
	});
}

YWC.f.intranetPopupNewsRefine = function(listName,articleId) {
	var assetId = listName+'_'+articleId;
	
	var putHtml = "";
	
	for (var i = 0; i < YWC.store[assetId].attachments.length; i++) {
		var node = YWC.store[assetId].attachments[i];
		if ((node.ext!='jpeg')&&(node.ext!='jpg')&&(node.ext!='png')) {
			putHtml += "<br /><a target=\"_blank\" href=\""
				+decodeURIComponent(YWC.store[assetId].attachments[i].orig)
				+"\">"
				+"<img src=\""+YWC.uri.pre+"lib/ywc-image/1.0/bttn/misc/attach-01.png\" />"
				+decodeURIComponent(YWC.store[assetId].attachments[i].name)
				+"</a>";
		}
	}
	
	if ((YWC.store[assetId].url != null) && (YWC.store[assetId].url != "")) {
		putHtml += "<br /><a target=\"_blank\" href=\""
			+YWC.store[assetId].url
			+"\">"
			+"<img src=\""+YWC.uri.pre+"lib/ywc-image/1.0/bttn/misc/attach-01.png\" />"
			+YWC.store[assetId].url
			+"</a>";
	}
	
	if (putHtml.length > 0) {
		$("span.ywc-intranet-news-full div.news-footer").before(
			"<div class=\"news-footer news-attachments\" style=\"width:"+600+"px;\">"
			+putHtml
			+"</div>"
			);
	}
}

YWC.f.intranetSubscribeConfirm = function(listId,listName){
	
	var email = YWC.input.value.text['intranet-subscribe-email'];
	if ((email != null) && YWC.f.strEmailValidate(email)) {
		$.ajax({ type: "POST", data: { 'mail':email }, dataType:"json"
			// should change this on the server side to make it more dynamic
			,url: YWC.intranet.subscribeUri + listId
			,beforeSend: function(){  }
			,success: function(d) {
				YWC.f.popupKill(1);

			},error: function(){
				YWC.f.inputButtonClick(YWC.f.inputGetById('intranet-subscribe-submit','button'),true);
				YWC.f.intranetInvalidEmailWarning(".ywc-container-popup-utility");
			}
		});
	} else {	
		YWC.f.inputButtonClick(YWC.f.inputGetById('intranet-subscribe-submit','button'),true);
		YWC.f.intranetInvalidEmailWarning(".ywc-container-popup-utility");
	}
}

YWC.f.intranetPostArchivePopup = function(listName,sortOptions) {
	if (sortOptions == null) { var sortOptions = {}; }
	if (typeof YWC.list.meta[listName] != "undefined") {
		var sendSortBy = (sortOptions.sortBy != null) ? sortOptions.sortBy : YWC.list.meta[listName].sortBy;
		var sendSortOrder = (sortOptions.sortOrder != null) ? sortOptions.sortOrder : YWC.list.meta[listName].sortOrder;
		var sendSortByType = (sortOptions.sortByType != null) ? sortOptions.sortByType : YWC.list.meta[listName].sortByType;
	} else {
		var sendSortBy = (sortOptions.sortBy != null) ? sortOptions.sortBy : "";
		var sendSortOrder = (sortOptions.sortOrder != null) ? sortOptions.sortOrder : "descending";
		var sendSortByType = (sortOptions.sortByType != null) ? sortOptions.sortByType : "text";
	}
	YWC.f.popupLoad({ 'source':YWC.uri.pre+'ywc/intranet/popup/archive'
		,'top':50,'z':'1','width':480,'id':'ywc-intranet-popup-archive-'+listName
		,'params':{'listName':listName
			,'uiHeaderColor':YWC.intranet.uiHeaderColor
			,'uiHeaderBgColor':YWC.intranet.uiHeaderBgColor
			,'uiFallbackImage':YWC.intranet.uiFallbackImage
			,'sortBy':sendSortBy
			,'sortOrder':sendSortOrder
			,'sortByType':sendSortByType
		}
	});
}


YWC.f.intranetPostDelete = function(listName,assetId,cacheId) {
	
	if (confirm("Are you sure you wish to delete this posting?")) {
		
		var deleteUri = YWC.intranet.uriDeletePost;
		if (deleteUri.indexOf('bws/') > -1) { deleteUri = deleteUri+listName+'/'+assetId+'?ywc_cache_id='+cacheId }
		
		$.ajax({ data:{'cacheId':cacheId,'id':assetId}
			,url: YWC.uri.pre+deleteUri
			,type: YWC.intranet.methodDeletePost
			,dataType: YWC.intranet.dataTypeDeletePost
			,beforeSend: function(){
				YWC.f.popupKill(1);
				YWC.f.uiAlertToggle({'toggle':true});
			},complete: function() {	
				YWC.f.uiAlertToggle({'toggle':false});
			},success: function(d) {
				YWC.list.list[listName] = [];
				YWC.list.meta[listName].groupCurr = 0;
				YWC.list.meta[listName].count = YWC.list.meta[listName].count-1;
				YWC.f.assetPagingGo(listName);
			},error: function(d) {
				alert('Failed to delete item...');
			}
		});
	}
}

if (typeof YWC.f.intranetPostSubmit == 'undefined') {
	
	YWC.f.intranetPostSubmit = function(listName,assetId,cacheId) {
	
		alert('Please define an application-specific function for \'YWC.f.intranetPostSubmit()\'');
	
		/*var params = {'cacheId':cacheId};
	
		params.title = YWC.input.value.text[listName+'-title'];
		params.body = YWC.input.value.text[listName+'-body'];
		params.expiration = YWC.f.strTrim(YWC.f.dateConvert(YWC.input.value.datetime[listName+'-expiration']
						,{'type':'datetime','format':'Y/m/d H:i:s'}));
	
		var submitUri = YWC.intranet.uriSubmitPost;
		if (submitUri.indexOf('bws/') > -1) {
			submitUri = submitUri+cacheId;
			if (assetId != '') { submitUri = submitUri+'/'+assetId; }
		}
	
		$.ajax({ type:YWC.intranet.methodSubmitPost
			,dataType: YWC.intranet.dataTypeSubmitPost
			,url:YWC.uri.pre+submitUri
			,data: params
			,success: function() {
			//	YWC.f.assetDrawList(listTarget,false,false);
			}
		});*/
	}
}

// these functions are to be used as callbacks in the application specific 'YWC.f.intranetPostSubmit' function
YWC.f.intranetPostSubmitBeforeSend = function(listName) {
	YWC.f.uiAlertToggle({'toggle':true,'message':''});
}
YWC.f.intranetPostSubmitComplete = function(listName) {
	YWC.f.uiAlertToggle({'toggle':false});
}
YWC.f.intranetPostSubmitSuccess = function(listName) {
	YWC.list.list[listName] = [];
	YWC.list.meta[listName].groupCurr = 0;
	YWC.list.meta[listName].count = YWC.list.meta[listName].count-1;
	YWC.input.value.file[listName+'-upload'] = [];
	YWC.list.list['attachments-'+listName+'-edit'] = [];
	
	YWC.f.assetPagingGo(listName);
	YWC.f.popupKill(1);
}
YWC.f.intranetPostSubmitError = function(listName,message) {
	if (YWC.input.value.button[listName+"-submit-top"] == true) { 
		YWC.f.inputButtonClick(YWC.f.inputGetById(listName+"-submit-top","button"),true);
	}
	if (YWC.input.value.button[listName+"-submit-bottom"] == true) { 
		YWC.f.inputButtonClick(YWC.f.inputGetById(listName+"-submit-bottom","button"),true);
	}
	if (message == null) {
		var message = "Your post could not be saved.\n\nPlease ensure that you have completed all required fields and try to Save it again.";
	}
	alert(message);
}


YWC.f.intranetPopupPostEdit = function(listName,assetId,inputParams) {
	
	var params = { 'listName':listName
		,'uiHeaderColor':YWC.intranet.uiHeaderColor
		,'uiHeaderBgColor':YWC.intranet.uiHeaderBgColor
		,'uriUploadFile':YWC.intranet.uriUploadFile
		};
	
	if (inputParams != null) {
		for (i in inputParams) {
			params[i] = inputParams[i];
		}
	}
	
	if (assetId != null) {
		params.assetId = assetId;
	}
	
	var popupUri = 'ywc/intranet/popup/edit';
	if (YWC.intranet.authCheckToggle) { popupUri = 'alt/'+popupUri; }
	
	YWC.f.popupLoad({'source':YWC.uri.pre+popupUri
		,'top':50,'z':'1','minHeight':300
		,'xToggle':false,'escToKill':false,'width':700
		,'id':'ywc-intranet-popup-edit-'+listName
		,'params':params
	});
}

YWC.f.intranetPopupPostEditDurationCheck = function(listName) {
	var checkEndTime = setTimeout(function(){
		if (YWC.input.value.datetime[listName+"-end"] < YWC.input.value.datetime[listName+"-start"]) {
			alert("You have selected an end time that is before the start time."
				+"\n\nPlease be sure to correct this error before submitting."
				);
		}
	},150);
}

YWC.f.intranetPostPopup = function(listName,assetId,srcIdVal){
	
	if (listName.indexOf('news') > -1) {
		YWC.f.intranetPopupNews(listName,srcIdVal);
	
	} else if (listName.indexOf('questions') > -1) {
		
		YWC.f.intranetPopupPostEdit(listName,srcIdVal,{
			'labelTitle':'Question'
			,'valueTitle':YWC.store[assetId].title
			,'labelBody':'Response'
			});
	
	} else {
		
		var popupDetailUri = "ywc/intranet/popup/detail";
		if (YWC.intranet.authCheckToggle && (YWC.user.id != "")) {
			popupDetailUri = "alt/"+popupDetailUri;
		}
		
		var popupParams = { 'id': 'ywc-intranet-popup-'+listName
				,'source':YWC.uri.pre+popupDetailUri
				,'top':50, 'z':1, 'width':600 };		
		popupParams.params = {
				'popupWidth':popupParams.width
				,'listName':listName
				,'srcIdVal':srcIdVal
				,'assetId':assetId
				};

		YWC.f.popupLoad(popupParams);
	}
	
	YWC.f.trackEvent({category:"posting"
					,action:"view-detail"
					,label:assetId
					});
}



YWC.f.intranetFormatDateTime = function(selector) {
	
	$(".ywc-intranet-date-unformatted-date").each(function(){
		$(this).removeClass("ywc-intranet-date-unformatted-date")
			.html(YWC.f.dateConvert($(this).html(),{'type':'date','format':'local'}));
	});
	$(".ywc-intranet-date-unformatted-time").each(function(){
		var val = YWC.f.dateConvert($(this).html(),{'type':'time','format':'G:i'});
		$(this).removeClass("ywc-intranet-date-unformatted-time").html(val);
	});	
}

YWC.f.intranetFormatDuration = function(selector) {
	$(".ywc-intranet-duration-unformatted").each(function(){
		var val = YWC.f.strTimePeriod(parseInt($(this).html().replace(/ /g,''))*1000);
		$(this).removeClass("ywc-intranet-duration-unformatted").html(val);
		console.log(val);
	});	
}

YWC.f.intranetPostPopupRefine = function(listName,assetId) {
	
	var obj = YWC.store[assetId];

	var shell = $("div.ywc-container-popup-detail-"+listName+"-"+assetId
			+" div#ywc-popup-detail-"+listName+"-"+assetId);
	
	var attachmentlistName = "attachments-"+listName+"-"+assetId;
	var gallerylistName = "gallery-"+listName+"-"+assetId;
	
	YWC.list.list[attachmentlistName] = [];
	YWC.list.list[gallerylistName] = [];
	YWC.f.assetMetaCount(attachmentlistName,0);
	YWC.f.assetMetaCount(gallerylistName,0);
		
	var hideThmb = true;
	
	if (obj.attachments[0]!=null) {
		for (i in obj.attachments) {
			if (obj.attachments[i].ext != null) {
				var ext = obj.attachments[i].ext.toLowerCase();	
				
				var fileSize = Math.round(obj.attachments[i].size/1024);
				if ((isNaN(fileSize)) || (fileSize <= 0)) { fileSize = 'Unknown'; }
				else if (fileSize > 1024) { fileSize = Math.round(fileSize/102.4)/10; fileSize+=' MB'; }
				else { fileSize+=' kB'; }
				
				if ((ext=="jpeg")||(ext=="jpg")||(ext=="png")||(ext=="gif")) {
					if (hideThmb && (obj.attachments[i].image != null)&&(obj.attachments[i].image != "")&&(obj.attachments[i].image.indexOf("http") != 0)) {
						hideThmb = false;
					} else {
						YWC.f.assetDisplayData(gallerylistName,gallerylistName+'-'+i,{
							'visible':true
							,'metaAltLabel':'File Size'
							,'metaAltValue':fileSize
							,'titleMaxLength':200
							,'cssClasses':'ywc-intranet-detail-gallery'
							,'thmb':obj.attachments[i].image+'?size=320'
							,'title':obj.attachments[i].name
							,'clickAction':'window.open(\''+YWC.f.strEscApos(YWC.uri.pre+obj.attachments[i].image)+'?size=1024\')'
						});
						YWC.list.meta[gallerylistName].count++;
					}
				} else {
					YWC.f.assetDisplayData(attachmentlistName,attachmentlistName+'-'+i,{
						'visible':true
						,'metaAltLabel':'File Size'
						,'metaAltValue':fileSize
						,'titleMaxLength':200
						,'cssClasses':'ywc-intranet-detail-attachments'
						,'clickAltHtml':'Click anywhere<br />to download'
						,'thmb':YWC.uri.pre+'lib/ywc-image/1.0/bttn/misc/attach-01.png'
						,'title':obj.attachments[i].name
						,'clickAction':'window.open(\''+YWC.f.strEscApos(YWC.uri.pre+obj.attachments[i].orig)+'\')'
					});
					YWC.list.meta[attachmentlistName].count++;
				}
			}
		}	
	}
		
	if (hideThmb) { shell.find("div.ywc-popup-detail-body div.ywc-popup-detail-body-thmb").css({'display':'none'}); }
	
	if ((YWC.list.meta[attachmentlistName].count+YWC.list.meta[gallerylistName].count) == 0) {
		YWC.list.meta[attachmentlistName].emptyMessage = '';//'This posting has no attachments.';
		$("div.ywc-container-stack-list-"+gallerylistName).css({'display':'none'});
	} else if ((YWC.list.meta[gallerylistName].count > 0)&&(YWC.list.meta[attachmentlistName].count==0)) {
		$("div.ywc-container-vertical-list-"+attachmentlistName).css({'display':'none'});
	} else if (YWC.list.meta[attachmentlistName].count > 0) {
		$("div.ywc-container-vertical-list-"+attachmentlistName).before(
			"<div class=\"ywc-intranet-detail-attachments-label\">Attached Documents</div>");
	}
	
	YWC.list.meta[attachmentlistName].groupSize = 6;
	YWC.list.meta[attachmentlistName].format = 'vertical-list';
	YWC.f.assetDrawList(attachmentlistName,false,false);
	
	YWC.list.meta[gallerylistName].emptyMessage = '';
	YWC.list.meta[gallerylistName].groupSize = 12;
	YWC.list.meta[gallerylistName].format = 'stack-list';
	YWC.f.assetDrawList(gallerylistName,false,false);
	
	YWC.f.intranetFormatDateTime();
	YWC.f.intranetFormatDuration();
	
	shell.find("div.ywc-popup-detail-body a[target!=_blank]").attr("target","_blank");
	shell.find("div.ywc-popup-detail-body p").attr("style","").after("<br />");
}

YWC.f.intranetAssetPagingDataSource = function(listName,listTarget) {
	$.ajax({ type:"POST" //set to POST to account for character encoding issues... normally this should be a GET
		,dataType:"script"
		,url:YWC.uri.pre+'ywc/intranet/asset/list'
		,data:{
			'listName':listName,'listTarget':listTarget
			,'sortBy':YWC.list.meta[listTarget].sortBy
			,'sortOrder':YWC.list.meta[listTarget].sortOrder
			,'sortByType':YWC.list.meta[listTarget].sortByType
			,'groupCurr':YWC.list.meta[listTarget].groupCurr
			,'groupSize':YWC.list.meta[listTarget].groupSize
			,'searchTerm':YWC.f.assetSearchTerm(listTarget)
			,'filterByDateTime':YWC.list.meta[listTarget].filterBy.dateTime
			,'uiFallbackImage':YWC.intranet.uiFallbackImage
		}, success: function() {
			YWC.f.assetDrawList(listTarget,false,false);
		}
	});
}

YWC.f.intranetWorldtimeUpdate = function() {
	
	YWC.f.coreSetDateTime();
	
	$("div.ywc-intranet-widget-weather-header").each(function(){
		var thisId = this.id;
		var locationId = thisId.substr(1+thisId.lastIndexOf('-'));
		var unixTime = YWC.user.date.now+YWC.user.date.zone.offset+YWC.intranet.worldtime[locationId].timezoneOffset*3600*1000;
		$(this).find("td.time span").html(YWC.f.dateConvert(unixTime,{'type':'time','format':'G:i'}));
	});
	
	var updateTime = setTimeout("YWC.f.intranetWorldtimeUpdate();",15000);
}

YWC.f.intranetWeatherDisplay = function(headerObj) {
	var thisId = headerObj.id;
	var locationId = thisId.substr(1+thisId.lastIndexOf('-'));
	
	$("div.ywc-intranet-widget-weather").each(function(){
		if ((this.id != thisId) && (parseInt($(this).css('height')) > 0)) {
			$(this).css({'height':'0px','border':'none','border-top':'none','padding':'0px 0px'});
		} else if (this.id == thisId) {
			$(this).css({'height':'auto','border':'solid 1px #ddd','border-top':'none','padding':'5px 0px'});
		}
	});
}


YWC.f.intranetPostEmailForward = function(listName,assetId,toEmail){
	if ((toEmail != null) && YWC.f.strEmailValidate(toEmail)) {
		$.ajax({ data:{ 'action':'single'
				,'to':toEmail
				,'subject':'Fwd: '+YWC.store[listName+'_'+assetId].title
				,'url':'/ywc/intranet/email/'+listName+'/'+assetId
			}
			,url: YWC.intranet.uriSendEmail
			,type: YWC.intranet.methodSendEmail
			,dataType: YWC.intranet.dataTypeSendEmail
			,beforeSend: function() {
				
			},complete: function() {
				
			},success: function() {
				YWC.f.popupKill(2);
			},error: function() {	
				YWC.f.inputButtonClick(YWC.f.inputGetById('forward-posting','button'),true);
				YWC.f.intranetInvalidEmailWarning(".ywc-container-popup-utility");
			}
		});
	} else {	
		YWC.f.inputButtonClick(YWC.f.inputGetById('forward-posting','button'),true);
		YWC.f.intranetInvalidEmailWarning(".ywc-container-popup-utility");
	}
}

YWC.f.intranetInvalidEmailWarning = function(popupSelector) {
	
	$(popupSelector).find("div.warning").css({"display":"block"});
	
	var killMsg = setTimeout(function(){
		$(popupSelector).find("div.warning").css({"display":"none"});
	},3000);
	
}

/*YWC.f.intranetPostEmailReply = function(listName,assetId,toEmail){
	if ((toEmail != null) && YWC.f.strEmailValidate(toEmail)) {
		$.ajax({ data:{
			'action':'single'
			,'recipient':toEmail
			,'subject':'Fwd: '
			,'url':'http://io-ws-pubfe1:83/item/marketplace/974'
			}
			,url: YWC.intranet.uriSendEmail
			,type: YWC.intranet.methodSendEmail
			,dataType: YWC.intranet.dataTypeSendEmail
			,beforeSend: function(){
				
			},complete: function() {
				
			},success: function(d) {
				
			},error: function(d) {
				alert('Failed to send email...');
			}
		});
	} else {
		YWC.f.inputButtonClick(YWC.f.inputGetById('forward-posting','button'),true);
		alert("Please enter a valid e-mail address.");
	}
}*/


YWC.f.intranetPostEditAttachmentsList = function(listName,assetId,append) {
	
	if (append == null) { var append = false; }
	
	var assetStorageId = listName+'_'+assetId;
	var assetListId = 'attachments-'+listName+'-edit';
	YWC.f.assetMetaCount(assetListId,0);
	YWC.list.list[assetListId] = [];
	YWC.list.meta[assetListId].groupCurr = 0;
	YWC.list.meta[assetListId].emptyMessage = 'This posting has no attachments yet. Upload new attachments below.';
	
	if (!append && YWC.store[assetStorageId] != null) {
		YWC.input.value.file[listName+'-upload'] = YWC.store[assetStorageId].attachments;
	}
	
	if (YWC.input.value.file[listName+'-upload'] == null) {
		YWC.input.value.file[listName+'-upload'] = [];
	}
	
	for (i in YWC.input.value.file[listName+'-upload']) {
			
		var attObj = YWC.input.value.file[listName+'-upload'][i];
		
		if (attObj.orig != null) {

			// show filesize
			var fileSize = Math.round(attObj.size/1024);
			if (fileSize <= 0) { fileSize = 'Unknown'; }
			else if (fileSize > 1024) { fileSize = Math.round(fileSize/102.4)/10; fileSize+=' MB'; }
			else { fileSize+=' kB'; }
			
			// if it's an image, show the thumbnail
			var thmb = YWC.uri.pre+'lib/ywc-image/1.0/bttn/misc/attach-01.png';
			if (attObj.image != null) { thmb = attObj.image; }
			var orig = attObj.orig.substr(0,attObj.orig.lastIndexOf('/'))
				+'/orig.'+attObj.orig.substr(1+attObj.orig.lastIndexOf('.'));
				
			YWC.f.assetDisplayData(assetListId,assetListId+'-'+i,{
					'visible':true
					,'metaAltLabel':'File Size'
					,'metaAltValue':fileSize
					,'titleMaxLength':200
					,'cssClasses':'ywc-intranet-edit-attachments'
					,'thmb':thmb
					,'title':attObj.name
					,'clickAction':'window.open(\''+orig+'\')'
					,'clickAltHtml':'Remove'
					,'clickAltAction':'YWC.f.intranetPostEditAttachmentRemove(\''+YWC.f.strEscApos(listName)+'\',\''+YWC.f.strEscApos(assetId)+'\','+i+');'
				});
				YWC.list.meta[assetListId].count++;
		}
	}
	
	YWC.f.assetDrawList(assetListId,false,false);

	// Remove completed upload row from file uploader
	$("div#ywc-fileupload-"+listName+"-upload-container tbody.files tr.template-download").remove();
}


YWC.f.intranetPostEditAttachmentRemove = function(listName,assetId,inputListIndex) {
	// still needs to be made to work for editing postings
	var editAssetList = 'attachments-'+listName+'-edit';
	if (YWC.input.value.file[listName+"-upload"][inputListIndex] !== null) {
		YWC.input.value.file[listName+"-upload"].splice(inputListIndex,1);
		delete YWC.list.data[editAssetList][editAssetList+'-'+inputListIndex];
		YWC.list.list[editAssetList].splice(inputListIndex,1);
		var tmpDataObj = {}; var tmpListArr = [];
		for (var i = 0; i < YWC.list.list[editAssetList].length; i++) {
			tmpDataObj[editAssetList+'-'+i] = YWC.list.data[editAssetList][YWC.list.list[editAssetList][i].substr(4)];
			tmpDataObj[editAssetList+'-'+i].assetId = editAssetList+'-'+i;
			tmpDataObj[editAssetList+'-'+i].clickAltAction = 'YWC.f.intranetPostEditAttachmentRemove(\''+YWC.f.strEscApos(listName)+'\',\''+YWC.f.strEscApos(assetId)+'\','+i+');'
			tmpListArr[i] = "111*"+editAssetList+"-"+i;
		}
		YWC.list.list[editAssetList] = tmpListArr;
		delete YWC.list.data[editAssetList]; YWC.list.data[editAssetList] = tmpDataObj;
		YWC.list.meta[editAssetList].count = YWC.list.list[editAssetList].length;
		YWC.f.assetDrawList('attachments-'+listName+'-edit',false,false);
	}

}

YWC.f.intranetAutoRefresh = function(executeAutoRefresh) {
		
	if ( (typeof YWC.intranet.autoRefreshLists === "object")
		&&	(YWC.intranet.autoRefreshLists.length > 0)
		) {
			var autoRefreshReset = setTimeout("YWC.f.intranetAutoRefresh(true);",YWC.intranet.autoRefreshInterval);
				
				for (var i = 0; i < YWC.intranet.autoRefreshLists.length; i++) {
					var listName = YWC.intranet.autoRefreshLists[i];
					if (	(executeAutoRefresh === true)
						&&	(YWC.list.meta[listName].searchTerm === "")
						&&	(YWC.list.meta[listName].groupCurr === 0)
						) {
						YWC.list.list[listName] = [];
						setTimeout("YWC.f.assetPagingGo('"+YWC.f.strEscApos(listName)+"');",i*500);
					}
				}
		}
}

YWC.f.intranetInitGlobalNavOpen = function() {
	$(this).addClass("hover");
	$('ul:first',this).css({visibility:'visible',opacity:1});
}

YWC.f.intranetInitGlobalNavClose = function() {
	$(this).removeClass("hover");
	$('ul:first',this).css({visibility:'hidden',opacity:0});
}

YWC.f.intranetInitGlobalNav = function() {
	if (YWC.intranet.uiGlobalNavFlyout) {
		$(function(){
			$(".ywc-intranet-nav-global ul li").hoverIntent({
				sensitivity: 14, // number = sensitivity threshold (must be 1 or higher)
				interval: 50,  // number = milliseconds for onMouseOver polling interval 
				over: YWC.f.intranetInitGlobalNavOpen,   // function = onMouseOver callback (REQUIRED)
				timeout: 40,   // number = milliseconds delay before onMouseOut
				out: YWC.f.intranetInitGlobalNavClose    // function = onMouseOut callback (REQUIRED)    
	    });
	  });
	}
}
YWC.exec.setQueue(YWC.f.intranetInitGlobalNav());

YWC.f.intranetBrowserFilter = function() {
	if ((BrowserDetect.browser==="Explorer") && (BrowserDetect.version<=8)) {
		alert("Please use a different browser to access this site. Preferably Chrome, Firefox, or Internet Explorer 10 (or higher).")
	}
}
YWC.exec.setQueue(YWC.f.intranetBrowserFilter());


