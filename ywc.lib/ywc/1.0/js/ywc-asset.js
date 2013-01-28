/**
* YWC Asset Lists Plugin
*/

/**
* Initializes a storage index for a generic asset storage object, and fills it with specified data
* @param {string} assetId The unique index of the item to be stored
* @param {object} newAttr A collection of key-value pairs
* @returns {undefined}
* @public
*/
YWC.f.assetSetData = function(assetId,newAttr) {
	
	if (typeof window.YWC.store[assetId] !== "object") {
		window.YWC.store[assetId] = {
			'assetId': assetId
		};
	}
	for (i in newAttr) {
		window.YWC.store[assetId][i] = newAttr[i];
	}
}

/**
* Parse various known formats of attachment string and convert to uniform format
* @param {string} assetId The unique index of the stored item to be processed
* @returns {undefined}
* @public
*/
YWC.f.assetParseAttachments = function(assetId) {
	var assetObj = YWC.store[assetId];
	var attStr = "";
	
	if ( (typeof assetObj.attachment === "string") && (assetObj.attachment.length > 0) ) {
		attStr += YWC.f.strTrim(assetObj.attachment);
	}
	if ( (typeof assetObj.attachments === "string") && (assetObj.attachments.length > 0) ) {
		attStr += YWC.f.strTrim(assetObj.attachments);
	}	
	
	if ( (attStr !== "") && (typeof YWC.store[assetId].attachments !== "object") ) {
		YWC.store[assetId].attachments = [];

		if ( (attStr.indexOf("[{") >= 0) && (attStr.indexOf("}]") >= 0) ) {
			// This means that the serialized attachment field is mostly likely in YWC JSON format
			if (typeof JSON !== "undefined") {
				var jsonObj = JSON.parse(attStr);
				if (attStr.indexOf("[{") == 0) {
					YWC.store[assetId].attachments = jsonObj;
				} else {
					for (i in jsonObj) {
						YWC.store[assetId].attachments = jsonObj[i];
					}
				}
			}
		} else if (attStr.substr(0,1) === "<") {
			// This means that the serialized attachment field is mostly likely in XML format
			$(	$.parseXML("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
							+"\n<ywc>"+YWC.f.strEscAmp(attStr)+"</ywc>"
				)).find("*[href]").each(function(){
					var attObj = {"orig":$(this).attr("href")};
					attObj.name = attObj.orig.substr(1+attObj.orig.lastIndexOf("/"));
					attObj.ext = attObj.name.substr(1+attObj.name.lastIndexOf("."));
					var type = $(this).attr("type");
					attObj.size = parseInt(type.substr(7+type.lastIndexOf("length=")));
					YWC.store[assetId].attachments.push(attObj);
	 			});
		} else if ((attStr.indexOf(";#") == 0)) {
			// This means that the serialized attachment field is mostly likely in MS Sharepoint format
			var attArr = attStr.split(";#");
			for (i in attArr) {
				if (attArr[i].length > 0) {
					var obj = {
						"ext":attArr[i].substr(1+attArr[i].lastIndexOf(".")).toLowerCase()
						,"media_id":""
						,"name":attArr[i].substr(1+attArr[i].lastIndexOf("/"))
						,"orig":attArr[i]
						,"size":0
					};
					if ( (obj.ext === "jpeg") || (obj.ext === "jpg") || (obj.ext == "png") ) {
						obj.image = attArr[i];
					}
					YWC.store[assetId].attachments.push(obj);
				}
			}
		} else if (attStr == "[]") {
			YWC.store[assetId].attachments = [];
		} else {
			console.log("YWC: function failure -> assetParseData -> unparsable attachment format ("+assetId+") -> "+attStr);
		}
		for (i in YWC.store[assetId].attachments) {
			if (typeof YWC.store[assetId].attachments[i].orig === "string") {
				var origStr = YWC.store[assetId].attachments[i].orig;
				YWC.store[assetId].attachments[i].orig =
					origStr.substr(0,origStr.lastIndexOf("/"))+"/"
					+encodeURIComponent(
						origStr.substr(1+origStr.lastIndexOf("/")).replace(/ /g,"_")
				);
			}
		}
	}
	// if there is no attachment attribute, just create an empty one
	if (typeof YWC.store[assetId].attachments === "undefined") {
		YWC.store[assetId].attachments = [];
	}
}

YWC.f.assetDrawSingle = function(listId,assetId,animate) {
	
	var displayFormat = YWC.list.meta[listId].format;
	
	var modelObj = YWC.f.assetCreateModel(displayFormat);
	
	var obj = YWC.list.data[listId][assetId];
	
	var containerObj = $("div.ywc-container-"+displayFormat+"-"+listId);
	if (containerObj.length > 0) {
		containerObj.append(
			"<div class=\"ywc-crnr-5 ywc-asset-list ywc-"+displayFormat+" "+obj.cssClasses
				+"\" id=\"ywc-"+displayFormat+"-"+listId+"-"+assetId+"\">"
			+modelObj.html()
		+"</div>");
	} else {
		console.log('YWC: Error in assetDrawSingle -> no list container found in DOM'
			+' (div.ywc-container-'+displayFormat+'-'+listId+')');
	}
	
	var shell = containerObj.find("div#ywc-"+displayFormat+"-"+listId+"-"+assetId).css({"visibility":"hidden"});
	
	if ((typeof obj.thmb != 'string')&&(obj.thmb!=null)&&(obj.thmb[0]!=null)) {
		var preThmb = obj.thmb; obj.thmb = "";
		for (i in preThmb) { if ((preThmb[i].image != null)&&(preThmb[i].image != "")) {
			obj.thmb = preThmb[i].image+"?size=320";
			break;
		} }
	}
	
	if (displayFormat == "stack-list") {
		YWC.f.assetElementClickHover(
			shell.find("div.asset-thmb").attr({'title':obj.title}).addClass(obj.thmbCssClasses).html(
				"<img src=\""+obj.thmb+"\""
				+" onLoad=\"YWC.f.uiSetSquImg(this,'"+obj.thmbSquareType+"')\" />")
		,obj,'thmb');
	} else {
		
		if ((obj.thmb != null) && (obj.thmb != "")) {
			YWC.f.assetElementClickHover(
				shell.find("div.asset-thmb").addClass(obj.thmbCssClasses).html(
					"<img src=\""+obj.thmb+"\""
					+" onLoad=\"YWC.f.uiSetSquImg(this,'"+obj.thmbSquareType+"')\" />")
			,obj,'thmb');
		} else {
			var wd = parseInt(shell.find("div.asset-thmb").addClass(obj.thmbCssClasses).css({'display':'none'}).css('width'));
			shell.find("span.asset-title, span.asset-meta").css({'left':(parseInt(shell.find("span.asset-title").css('left'))-wd)+'px'});
		}
		if ((obj.thmbAlt != null) && (obj.thmbAlt != "")) {
			shell.find("div.asset-thmb-alt").addClass(obj.thmbAltCssClasses).html(
				"<img src=\""+obj.thmbAlt+"\" onLoad=\"YWC.f.uiSetSquImg(this,'"+obj.thmbAltSquareType+"')\" />");
		} else {
			shell.find("div.asset-thmb-alt").addClass(obj.thmbAltCssClasses).css({'display':'none'});
		}
			
		shell.find("div.asset-list-bg, span.asset-title").attr({"onClick":obj.clickAction});
		
		if (obj.clickTitleAction != '') {
			shell.find("span.asset-title").attr({'onClick':obj.clickTitleAction}).addClass("asset-title-clickable");
		}
		
		shell.find("span.asset-title").html(YWC.f.strLimitLength(YWC.f.strTrim(
			//YWC.f.strRemoveTags(
				obj.title
			//	)
			),obj.titleMaxLength));
		
		shell.find("div.asset-controls a").html(obj.clickAltHtml).each(function(){
			if ((obj.clickAltHtml != "") && (obj.clickAltAction != "")) {
				$(this).attr({"onclick":obj.clickAltAction});
			} else {
				$(this).attr({"onclick":obj.clickAction});
			}
		});
		
		if (obj.metaValue.length == 0) {
			obj.metaLabel = "";
		}
		shell.find("span.asset-meta span.meta-label").html(
			YWC.f.strLimitLength(obj.metaLabel,obj.metaMaxLength));
		shell.find("span.asset-meta span.meta-value").html(
			YWC.f.strLimitLength(obj.metaValue,obj.metaMaxLength));
		
		if (obj.metaAltValue.length == 0) {
			obj.metaAltLabel = "";
		}
		shell.find("span.asset-meta span.meta-label-alt").html(
			YWC.f.strLimitLength(obj.metaAltLabel,obj.metaAltMaxLength));
		shell.find("span.asset-meta span.meta-value-alt").html(
			YWC.f.strLimitLength(obj.metaAltValue,obj.metaAltMaxLength));
		
		
		if ((obj.metaValue=='')||(obj.metaLabel=='')) { shell.find("span.asset-meta span.meta-delim").css('display','none'); }
		if ((obj.metaAltValue=='')||(obj.metaAltLabel=='')) { shell.find("span.asset-meta span.meta-delim-alt").css('display','none'); }
	}
	
	if (displayFormat == "feed-list") {
		
		shell.find("div.asset-body").html(
			YWC.f.strLimitLength(YWC.f.strTrim(obj.body),obj.bodyMaxLength));
	
		if (obj.clickBodyAction != '') {
			shell.find("div.asset-body").attr({'onClick':obj.clickBodyAction});
		}
	
		if (obj.baseHtml != '') {
			shell.find("div.asset-base").html(obj.baseHtml).css({'display':'block'});
		}
	}
	
	shell.css({"visibility":"visible"})
}

YWC.f.assetDrawEmpty = function(listId,height,message) {
	
	var displayFormat = YWC.list.meta[listId].format;
	var msgHtml = "";
	var heightHtml = "";
	var boxVisibility = "";
	if (message == null) { var message = YWC.list.meta[listId].emptyMessage; }
	if (message != "") {
		msgHtml = "<span"
				+" class=\"asset-title ywc-trans-50 ywc-unselectable empty-message\""
				+">"+message+"</span>";
		boxVisibility = "visibility:visible;";
	}
	if (height != null) { heightHtml = "height:"+height+"px;"; }
	$("div.ywc-container-"+displayFormat+"-"+listId).append(
		"<div class=\"ywc-asset-list ywc-"+displayFormat+" ywc-asset-list-empty\""
			+" style=\""+heightHtml+boxVisibility+"\""
			+">"+msgHtml+"</div>");
}

YWC.f.assetElementClickHover = function(targetObj,inputParams,targetType) {
	
	var hoverStateIndex = "hoverState";
	var action = [inputParams.hoverOverAction,inputParams.hoverOutAction];
					
	if (targetType == 'thmb') {
		hoverStateIndex = "thmbHoverState";
		action = [inputParams.thmbHoverOverAction,inputParams.thmbHoverOutAction];
	}
	
	if ((targetType != 'thmb') || ((targetType==='thmb') && (inputParams.hoverOverAction == ''))) {
		if (inputParams.hoverIntent && $().hoverIntent) {
			targetObj.hoverIntent({
				sensitivity: YWC.ui.hoverIntent.sensitivity
				,interval: YWC.ui.hoverIntent.interval
				,timeout: YWC.ui.hoverIntent.timeout
				,over: function(){
					YWC.list.data[inputParams.listId][inputParams.assetId][hoverStateIndex] = true;
					eval(action[0]);
				}
				,out: function(){
					YWC.list.data[inputParams.listId][inputParams.assetId][hoverStateIndex] = false;
					eval(action[1]);
				}
			});
		} else {
			targetObj.hover(function(){
					YWC.list.data[inputParams.listId][inputParams.assetId][hoverStateIndex] = true;
					eval(action[0]);
				},function(){
					YWC.list.data[inputParams.listId][inputParams.assetId][hoverStateIndex] = false;
					eval(action[1]);
				});
		}
	}
	
	if (inputParams.clickAction != '') {
		targetObj.click(function(){eval(inputParams.clickAction);});
	}
}

YWC.f.assetDisplayData = function(listId,assetId,data) {
	
	YWC.f.assetMetaInit(listId);
	
	if (YWC.list.data[listId][assetId] == null) { YWC.list.data[listId][assetId] = {}; }
	
	var assetFormat = YWC.f.assetDisplayFormat();
	data.listId = listId; data.assetId = assetId;
	
	for (i=0;i<assetFormat.name.length;i++) {
		var dataVal = data[assetFormat.name[i]];
		if (assetFormat.format[i] == 'float') { dataVal = parseFloat(data[assetFormat.name[i]]); }
		else if (assetFormat.format[i] == 'int') { dataVal = parseInt(data[assetFormat.name[i]]); }
		else if (assetFormat.format[i] == 'string') { dataVal = ''+data[assetFormat.name[i]]; }
		
		if (data[assetFormat.name[i]] == null) {
			YWC.list.data[listId][assetId][assetFormat.name[i]] = assetFormat.fallback[i];
		} else {
			YWC.list.data[listId][assetId][assetFormat.name[i]] = dataVal;
		}
	}
	
	var rankId = "111*"+assetId;
	
	var pushItem = true;
	for (i=0;i<YWC.list.list[listId].length;i++) {
		if (YWC.list.list[listId][i]==rankId) { pushItem = false; break; }
	}
	if (pushItem) { YWC.list.list[listId].push(rankId); }
}


YWC.f.assetDisplayFormat = function() {
	
	var out = { 'name':[], 'format':[], 'fallback':[] };
	
	out.name.push('listId'); out.format.push('string'); out.fallback.push('listId');
	out.name.push('assetId'); out.format.push('string'); out.fallback.push('assetId');
	
	out.name.push('title'); out.format.push('string'); out.fallback.push('');
	out.name.push('titleMaxLength'); out.format.push('int'); out.fallback.push(30);
	
	out.name.push('body'); out.format.push('string'); out.fallback.push('');
	out.name.push('bodyMaxLength'); out.format.push('int'); out.fallback.push(200);
	out.name.push('clickBodyAction'); out.format.push('function'); out.fallback.push('');
	
	out.name.push('baseHtml'); out.format.push('string'); out.fallback.push('');
	
	out.name.push('thmb'); out.format.push('object'); out.fallback.push(null);
	out.name.push('thmbAlt'); out.format.push('object'); out.fallback.push(null);
	out.name.push('thmbSquareType'); out.format.push('string'); out.fallback.push('out');
	out.name.push('thmbAltSquareType'); out.format.push('string'); out.fallback.push('out');
	out.name.push('thmbCssClasses'); out.format.push('string'); out.fallback.push('');
	out.name.push('thmbAltCssClasses'); out.format.push('string'); out.fallback.push('');
	
	out.name.push('clickAltLabel'); out.format.push('string'); out.fallback.push('');
	
	out.name.push('metaValue'); out.format.push('string'); out.fallback.push('');
	out.name.push('metaLabel'); out.format.push('string'); out.fallback.push('');
	out.name.push('metaAltValue'); out.format.push('string'); out.fallback.push('');
	out.name.push('metaAltLabel'); out.format.push('string'); out.fallback.push('');
	out.name.push('metaMaxLength'); out.format.push('int'); out.fallback.push(30);
	out.name.push('metaAltMaxLength'); out.format.push('int'); out.fallback.push(30);
	
	out.name.push('clickAction'); out.format.push('function'); out.fallback.push('');
	out.name.push('clickTitleAction'); out.format.push('function'); out.fallback.push('');
	out.name.push('clickAltAction'); out.format.push('function'); out.fallback.push('');
	out.name.push('clickAltHtml'); out.format.push('string'); out.fallback.push('');

	out.name.push('hoverOverAction'); out.format.push('function'); out.fallback.push('');
	out.name.push('hoverOutAction'); out.format.push('function'); out.fallback.push('');
	out.name.push('hoverIntent'); out.format.push('boolean'); out.fallback.push(true);
	out.name.push('hoverState'); out.format.push('boolean'); out.fallback.push(false);

	out.name.push('thmbHoverOverAction'); out.format.push('function'); out.fallback.push('');
	out.name.push('thmbHoverOutAction'); out.format.push('function'); out.fallback.push('');
	out.name.push('thmbHoverIntent'); out.format.push('boolean'); out.fallback.push(true);
	out.name.push('thmbHoverState'); out.format.push('boolean'); out.fallback.push(false);
	
	out.name.push('visible'); out.format.push('boolean'); out.fallback.push(true);
	out.name.push('cssClasses'); out.format.push('string'); out.fallback.push('');
	
	return out;
}

YWC.f.assetDrawList = function(listId,append,animate) {
	
	var displayFormat = YWC.list.meta[listId].format;
	var box = $("div.ywc-container-"+YWC.list.meta[listId].format+"-"+listId);
	if (!append) { box.html(""); }
	
	if (YWC.list.data[listId] != null) {
		
		var countDrawn = 0;
		var itemId = '';
		for (	i = (YWC.list.meta[listId].groupCurr*YWC.list.meta[listId].groupSize);
				i < ((1+YWC.list.meta[listId].groupCurr)*YWC.list.meta[listId].groupSize);
				i++) {
			if (YWC.list.list[listId][i] != null) {
				itemId = YWC.list.list[listId][i].substr(YWC.list.list[listId][i].indexOf('*')+1);
				YWC.f.assetDrawSingle(listId,itemId,true);
				countDrawn++;		
			}
		}
		if ((YWC.list.meta[listId].minSize > 0) && (YWC.list.meta[listId].minSize > countDrawn)) {
			var lastHeight = box.find("div#ywc-"+displayFormat+"-"+listId+"-"+itemId).height();
			for (var i = 0; i < (YWC.list.meta[listId].minSize - countDrawn); i++) {
				YWC.f.assetDrawEmpty(listId,lastHeight,"");
			}
		}
		
		if (	(YWC.list.meta[listId].count > ((1+YWC.list.meta[listId].groupCurr)*YWC.list.meta[listId].groupSize))
		 	||	(YWC.list.meta[listId].groupCurr > 0)
			){
			YWC.f.assetPagingControls(listId,false);
		} else if (YWC.list.meta[listId].searchTerm != "") {
			if (YWC.list.meta[listId].count > 0) {
				YWC.f.assetPagingControls(listId,false);
			} else {
				
			}
		}
		
		if (YWC.list.meta[listId].count == 0) {
			YWC.f.assetDrawEmpty(listId,null);
		}
		
		if (YWC.list.meta[listId].searchTerm != "") {
			YWC.f.assetSearchHeader(listId,false);
		}
	}
}

YWC.f.assetMetaCount = function(listId,countValue) {	
	YWC.f.assetMetaInit(listId);
	YWC.list.meta[listId].count = parseInt(countValue);
}

YWC.f.assetMetaInit = function(listId) {
	if (YWC.list.data[listId] == null) {
		YWC.list.data[listId] = {};
		YWC.list.meta[listId] = {
				'format':'vertical-list','count':0
				,'groupSize':6,'minSize':0,'emptyMessage':''
				,'groupCurr':0,'searchTerm':'','showPaging':true
				,'filterBy':{'dateTime':''}
				,'groupBounds':['','']
				,'dataSource':function(){  }
			};
		YWC.list.list[listId] = [];
	}
}


YWC.f.assetPagingControls = function(listId,animate) {
	
	var displayFormat = YWC.list.meta[listId].format;
	var listMeta = YWC.list.meta[listId];
	
	var	modelObj = YWC.f.assetCreateModel("list-paging");
	
	var containerObj = $("div.ywc-container-"+displayFormat+"-"+listId);
	
	if ((containerObj.length > 0) && (listMeta.showPaging)) {
		
		containerObj.append("<div"
			+" class=\"ywc-crnr-5 ywc-crnr-t-off ywc-container-list-paging\""
			+" id=\"ywc-list-paging-"+listId+"\">"+modelObj.html()+"</div>");
		
		var shell = containerObj.find("div#ywc-list-paging-"+listId).css({"visibility":"hidden"});
	
		shell.find("span.cnt").html(listMeta.count);
		shell.find("span.cur").each(function(){
			var cur = (listMeta.groupCurr*listMeta.groupSize+1)+"-";
			if (((1+listMeta.groupCurr)*listMeta.groupSize) <= listMeta.count) {
				cur += ((1+listMeta.groupCurr)*listMeta.groupSize);
			} else {
				cur += listMeta.count;
			}
			$(this).html(cur);
		});
		
		var shellWidth = shell.width();
		
		shell.find("a.nxt").each(function(){
			var thisObj = $(this);
			var thisLbl = "next "+listMeta.groupSize+" &gt;&gt;";
			if (listMeta.count <= ((1+listMeta.groupCurr)*listMeta.groupSize)) {
				thisObj.attr({'href':'javascript:','class':'nxt paging-off'});
			} else {
				thisObj.attr({'href':'javascript:YWC.f.assetPagingIncr(\''+listId+'\',true);','class':'nxt'});
			}
			if (shellWidth < 300) {
				thisLbl = listMeta.groupSize+" &gt;&gt;";
			}
			thisObj.html(thisLbl);
		});
		shell.find("a.prv").each(function(){
			var thisObj = $(this);
			var thisLbl = "&lt;&lt; prev "+listMeta.groupSize;
			if (listMeta.groupCurr == 0) {
				thisObj.attr({'href':'javascript:','class':'prv paging-off'});
			} else {
				thisObj.attr({'href':'javascript:YWC.f.assetPagingIncr(\''+listId+'\',false);','class':'prv'});
			}
			if (shellWidth < 300) {
				thisLbl = "&lt;&lt; "+listMeta.groupSize;
			}
			thisObj.html(thisLbl);
		});
		
		shell.css({"visibility":"visible"});
	}
}

YWC.f.assetPagingIncr = function(listId,upOrDown) {
	var proceedWithPaging = false;
	if (	upOrDown
		&&	((YWC.list.meta[listId].groupCurr+1)*YWC.list.meta[listId].groupSize < YWC.list.meta[listId].count)
		) {
		var bttnRef = 'nxt';
		YWC.list.meta[listId].groupCurr++;
		proceedWithPaging = true;
	} else if (!upOrDown && (YWC.list.meta[listId].groupCurr > 0)) {
		var bttnRef = 'prv';
		YWC.list.meta[listId].groupCurr--;
		proceedWithPaging = true;
	}
	
	if (proceedWithPaging) {
		if (YWC.list.list[listId][(YWC.list.meta[listId].groupCurr*YWC.list.meta[listId].groupSize)] == null) {
			$("div.ywc-container-"+YWC.list.meta[listId].format+"-"+listId
				+" div#ywc-list-paging-"+listId+" a."+bttnRef).html("loading")
				.attr({'href':'javascript:','class':bttnRef+' paging-off'});
		}
		YWC.f.assetPagingGo(listId);
	}
}

YWC.f.assetPagingGo = function(listId) {
	if (	(YWC.list.list[listId][(YWC.list.meta[listId].groupCurr*YWC.list.meta[listId].groupSize)] == null)
	 	||	(YWC.list.meta[listId].searchTerm != YWC.f.assetSearchTerm(listId))
		){
		if (YWC.list.meta[listId].searchTerm != YWC.f.assetSearchTerm(listId)) {
			YWC.list.meta[listId].searchTerm = YWC.f.assetSearchTerm(listId);
			YWC.list.meta[listId].groupCurr = 0;
		}
		var pagingGo = setTimeout(YWC.list.meta[listId].dataSource,10);
	} else {
		YWC.f.assetDrawList(listId,false,false);
	}
}

YWC.f.assetSearchReset = function(listId,filterBy) {
//	YWC.f.inputTextClear(listId,true,true);
//	YWC.list.meta[listId].searchTerm = "";
	if (filterBy != null) { YWC.list.meta[listId].filterBy = filterBy; }
	else { YWC.list.meta[listId].filterBy = {'datetime':''}; }
	YWC.list.list[listId] = [];
	YWC.f.assetPagingGo(listId);
}

YWC.f.assetSearchTerm = function(listId) {
	var inp = $("input#ywc-input-text-asset-list-"+listId);
	var val = inp.val();
	var rtrn = ""; if ((val != "") && (val != inp.attr("title"))) { rtrn = val; }
	return rtrn;
}

YWC.f.assetSearchHeader = function(listId,animate) {
	var displayFormat = YWC.list.meta[listId].format;
	var listMeta = YWC.list.meta[listId];

	var	modelObj = YWC.f.assetCreateModel("list-paging");

	var containerObj = $("div.ywc-container-"+displayFormat+"-"+listId);
	
	
	if (containerObj.length > 0) {
		containerObj.prepend(
			"<div class=\"ywc-crnr-5 ywc-crnr-t-off ywc-container-list-feedback\" id=\"ywc-list-feedback-"+listId+"\">"+modelObj.html()+"</div>");
		var shell = containerObj.find("div#ywc-list-feedback-"+listId).css({"visibility":"hidden"});
		
		if (shell.width() < 300) {
			shell.find("span.verbose").css({'display':'none'});
		}
		
		var searchTermEscaped = YWC.list.meta[listId].searchTerm.replace(/</g,'&lt;').replace(/>/g,'&gt;');
		shell.find("span.term").html(searchTermEscaped);
		shell.find("span.cnt").html(YWC.list.meta[listId].count);
//		shell.find("a.clear").click(function(){YWC.f.assetSearchReset(listId);});
	
		shell.css({"visibility":"visible"});
	}
}


YWC.f.storeObjectAsJavascript = function(inputParams) {
	
	if (inputParams.node == null) { inputParams.node = {}; }
	if (inputParams.assetId == null) { inputParams.assetId = '_error'; }
	if (inputParams.extraIndex == null) { inputParams.extraIndex = []; }
	if (inputParams.extraValue == null) { inputParams.extraValue = []; }
	if (inputParams.omit == null) { inputParams.omit = []; }
	if (inputParams.only == null) { inputParams.only = []; }
	
	var returnParams = {};
	
	for (i in inputParams.extraIndex) {
		if ((typeof inputParams.extraIndex[i] == 'string') && (inputParams.omit.indexOf(inputParams.extraIndex[i].toLowerCase()) == -1)) {
			returnParams[inputParams.extraIndex[i]] = inputParams.extraValue[i];
		}
	}
	
	if (inputParams.only.length > 0) {
		for (i in inputParams.node) {
			if (inputParams.only.indexOf(i.toLowerCase()) >= 0) {
				returnParams[i] = inputParams.node[i];
			}
		}
	} else {
		for (i in inputParams.node) {
			if (inputParams.omit.indexOf(i.toLowerCase()) == -1) {
				returnParams[i] = inputParams.node[i];
			}
		}
	}
	
	if (YWC.f.objLength(returnParams) != 0) {
		
		YWC.f.assetSetData(inputParams.assetId,returnParams);
		YWC.f.assetParseAttachments(inputParams.assetId);
	}
}

YWC.f.assetCreateModel = function(displayFormat) {
	
	var model = $("div.ywc-"+displayFormat+"-model:first div.ywc-"+displayFormat);
	
	if (model.length > 0) {
		return model;
		
	} else {
		
		var html = "";
	
		if (displayFormat == 'list-paging') {
		
			html = '<div class="ywc-list-paging-model" style="display:none;">'
			+'<div class="ywc-list-paging">'
			+'<div class="ywc-list-paging-inner">'
				+'<a class="prv">prev 0</a>'
				+'<span class="dlm">--</span>'
					+' <span class="cur">0-0</span> of <span class="cnt">0</span> '
				+'<span class="dlm">--</span>'
				+'<a class="nxt">next 0</a>'
			+'</div>'
			+'<div class="ywc-list-feedback">'
				+'<span class="feedback">'
					+'<span class="verbose">search </span>results for &quot;<span class="term">-</span>&quot;'
					+' : <span class="cnt">0</span><span class="verbose"> match(es)</span>'
		//			+' <a class="clear">clear</a>'
				+'</span>'
			+'</div>'		
			+'</div>'
			+'</div>';
	
		} else if (displayFormat == 'stack-list') {
		
			html = '<div class="ywc-stack-list-model" style="display:none;">'
				+'<div class="ywc-asset-list ywc-stack-list">'
					+'<div class="ywc-thmb asset-thmb"><img /></div>'
				+'</div>'
			+'</div>';
		} else {
		
			html = '<div class="ywc-'+displayFormat+'-model" style="display:none;">'
				+'<div class="ywc-asset-list ywc-'+displayFormat+'">'
				+'<div class="asset-list-bg"></div>'
				+'<div class="ywc-thmb asset-thmb"><img /></div>'
				+'<span class="asset-title"></span>';

			if (displayFormat == 'feed-list') {
				html += '<div class="asset-body"></div>'
					+'<div class="asset-base"></div>';
			}

			html += '<span class="asset-meta">'
				+'<span class="meta-label"></span>'
				+'<span class="meta-delim">: </span>'
				+'<span class="meta-value"></span>'
				+'<br />'
				+'<span class="meta-label-alt"></span>'
				+'<span class="meta-delim-alt">: </span>'
				+'<span class="meta-value-alt"></span>'
				+'</span>'
				
				+'<div class="asset-controls">'
				+'<a class="asset-controls-inner">more info</a>'
				+'<div class="asset-list-bg"></div>'
				+'</div>';
		
			if (displayFormat == 'richstack-list') {
				html += '<div class="delim"></div>';
			}		

			html += '</div></div>';
		}
	
		$("body").append(html);
	
		return $("div.ywc-"+displayFormat+"-model:first div.ywc-"+displayFormat);
	}
}
