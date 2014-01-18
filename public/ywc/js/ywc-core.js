
// for MSIE, if console is not defined, create an empty method
if (typeof console === "undefined") { window.console={log:function(){}}; }
// for MSIE
if (!Array.indexOf) { Array.prototype.indexOf = function(obj, start) { for (var i = (start || 0); i < this.length; i++) { if (this[i] == obj) { return i; } } return -1; } }



YWC.ui = {
	"hoverIntent":{"timeout":0,"sensitivity":7,"interval":100}
	,"jQueryUI":{"v":"1.10.3","theme":"smoothness","themeUri":"","onLoad":""}
};

YWC.f.coreLoadFileAsync = function(type,id,uri,callback) {
	var slct = "#"+type+"-"+id+", "+type+"."+type+"-ywc-aggregate[id*="+type+"-"+id+"\\;]";
	if ((typeof $ != 'undefined') && (typeof window.BrowserDetect != 'undefined') && ($(slct).length == 0)) {
		var s = document.createElement(type);
		var mimeType = "text/javascript"; if (type == "link") { mimeType = "text/css"; s.rel = "stylesheet"; }
		s.type = mimeType; s.async = true; s.id = type+"-"+id;
		if (type == "script") { s.src = uri; } else if (type == "link") { s.href = uri; }
		if (window.BrowserDetect.browser != 'Explorer') { s.onload = setTimeout(callback,25); }
		s.onreadystatechange = function() { setTimeout(callback,25); }
		var x = document.getElementsByTagName("head")[0]; x.appendChild(s);
	//	console.log("YWC: coreLoadFileAsync: "+id+" ("+type+")");
		return true;
	} else if (typeof window.BrowserDetect == 'undefined') {
		if (document.getElementById('script-browser-detect') == null) {
			var s = document.createElement("script");
			s.type = "text/javascript"; s.async = true; s.id = "script-browser-detect";
			s.src = YWC.uri.cdn+"vendor/browser-detect/1.0/browser-detect.js";
			s.onload = setTimeout(callback,25);
			s.onreadystatechange = function() { setTimeout(callback,25); }
			var x = document.getElementsByTagName("head")[0]; x.appendChild(s);
		//	console.log("YWC: coreLoadFileAsync: browser-detect (script)");
		} else {
			var loop = setTimeout(callback,25);
		}
		return true;
	} else if (typeof $ == 'undefined') {
		if (document.getElementById('script-jquery') == null) {
			var s = document.createElement("script");
			s.type = "text/javascript"; s.async = true; s.id = "script-jquery";
			s.src = YWC.uri.cdn+"vendor/jquery/jquery/1.10.2/jquery.min.js";
			if (window.BrowserDetect.browser != 'Explorer') { s.onload = setTimeout(callback,25); }
			s.onreadystatechange = function() { setTimeout(callback,25); }
			var x = document.getElementsByTagName("head")[0]; x.appendChild(s);
		//	console.log("YWC: coreLoadFileAsync: jquery (script)");
		} else {
			var loop = setTimeout(callback,25);
		}
		return true;
	} else {
		return false;
	}
}

YWC.f.coreLoadFileChainAsync = function(chainId,fileChainObjArr,callback){
	
	if (typeof YWC.f.aSyncChain == 'undefined') {
		YWC.f.aSyncChain = {'callback':{},'sequence':{},'loopCount':{}};
	}
	if (YWC.f.aSyncChain.callback[chainId] == null) {
		YWC.f.aSyncChain.callback[chainId] = "";
		YWC.f.aSyncChain.sequence[chainId] = [];
		YWC.f.aSyncChain.loopCount[chainId] = 0;
	}
	if ((callback != null)&&(YWC.f.aSyncChain.callback[chainId]=="")) {
		YWC.f.aSyncChain.callback[chainId] = callback; }	
	if ((fileChainObjArr != null)&&(YWC.f.aSyncChain.sequence[chainId].length==0)) {
		YWC.f.aSyncChain.sequence[chainId] = fileChainObjArr; }
	
	// fileChainObjArr expects array of objects like this:
	// { 'type':'script', 'id':'ywc-core', 'init':['$'], 'uri':'/public/ywc/js/ywc-core.js' }
	
	var insertLoop = false;
	var initLoop = false;
	for (var i = 0; (i < YWC.f.aSyncChain.sequence[chainId].length); i++) {
		var initName = "";
		if (	(i > 0)
			&&	(typeof YWC.f.aSyncChain.sequence[chainId][(i-1)].init == 'object')
			&& 	(YWC.f.aSyncChain.sequence[chainId][(i-1)].init.length > 0)
			) {
			for (j in YWC.f.aSyncChain.sequence[chainId][(i-1)].init) {
				if (typeof window[YWC.f.aSyncChain.sequence[chainId][(i-1)].init[j]] == 'undefined') {
					initLoop = true;
					initName = YWC.f.aSyncChain.sequence[chainId][(i-1)].init[j];
					break;
		}	}	}
		
		if (!initLoop) {
			if ( 	(YWC.f.aSyncChain.sequence[chainId][i].type != null)
				&&	(YWC.f.aSyncChain.sequence[chainId][i].id != null)
				&&	(YWC.f.aSyncChain.sequence[chainId][i].uri != null)
				&& YWC.f.coreLoadFileAsync(
					YWC.f.aSyncChain.sequence[chainId][i].type
					,YWC.f.aSyncChain.sequence[chainId][i].id
					,YWC.f.aSyncChain.sequence[chainId][i].uri
					,"YWC.f.coreLoadFileChainAsync('"+chainId+"');")
				) {
					insertLoop = true;
					break;
		}	} else {
		//	console.log('YWC: coreLoadFileChainAsync ('+YWC.f.aSyncChain.loopCount[chainId]+')'
		//			+' -> blocked loading of '+YWC.f.aSyncChain.sequence[chainId][i].id
		//			+' -> awaiting initialization of \''+initName+'\'');
			break;
		}
	}
	
	YWC.f.aSyncChain.loopCount[chainId]++;
	// set limit on loop to avoid runaway
	var aSyncLoopLimit = 250;
	var aSyncLoopDelay = 25;
	if ((YWC.f.aSyncChain.loopCount[chainId]/aSyncLoopLimit) > 0.8) { aSyncLoopDelay = 150; }
	
	if (YWC.f.aSyncChain.loopCount[chainId] < aSyncLoopLimit) {
		if (!insertLoop && initLoop){
			var runLoop = setTimeout("YWC.f.coreLoadFileChainAsync('"+chainId+"');",aSyncLoopDelay);
	//		console.log('YWC: coreLoadFileChainAsync -> fallback loop ('+YWC.f.aSyncChain.loopCount[chainId]+')');
		} else if (!insertLoop && !initLoop) {
			YWC.f.aSyncChain.loopCount[chainId] = aSyncLoopLimit;
			var endLoop = setTimeout(YWC.f.aSyncChain.callback[chainId],aSyncLoopDelay);
		}
	} else {
		console.log("YWC: coreLoadFileChainAsync -> halted after "+aSyncLoopLimit+" iterations");
	}
}

YWC.f.uiCssInsert = function(code) {
	if (typeof $ != 'undefined') {
		$("head").append("<style type=\"text/css\">"+code+"</style>");
	}
}



YWC.f.coreSetDefault = function(grp,ind,value,overWrite) {
	if (typeof ind == 'string') {
		if ((YWC[grp][ind] == null) || overWrite) {
			YWC[grp][ind] = value;
		}
	} else if (ind.length == 2) { 
		if ((YWC[grp][ind[0]] != null) && ((YWC[grp][ind[0]][ind[1]] == null) || overWrite)) {
			YWC[grp][ind[0]][ind[1]] = value;
		} else if (YWC[grp][ind[0]] == null) {
			YWC[grp][ind[0]] = {};
			YWC[grp][ind[0]][ind[1]] = value;
		}
	} else if (ind.length == 3) { 
		if ((YWC[grp][ind[0]] != null) && (YWC[grp][ind[0]][ind[1]] != null)
				&& ((YWC[grp][ind[0]][ind[1]][ind[2]] != null) || overWrite)) {
			YWC[grp][ind[0]][ind[1]][ind[2]] = value;
		} else if ((YWC[grp][ind[0]] != null) && (YWC[grp][ind[0]][ind[1]] == null)) {
			YWC[grp][ind[0]][ind[1]] = {};
			YWC[grp][ind[0]][ind[1]][ind[2]] = value;
		} else if (YWC[grp][ind[0]] == null) {
			YWC[grp][ind[0]] = {};
			YWC[grp][ind[0]][ind[1]] = {};
			YWC[grp][ind[0]][ind[1]][ind[2]] = value;
		}
	}
};


YWC.f.coreSetDateTime = function(){
	var dateTime = new Date();
	YWC.user.date.now = dateTime.getTime();
	YWC.user.date.zone.name = String(String(dateTime).split("(")[1]).split(")")[0];
	YWC.user.date.zone.offset = dateTime.getTimezoneOffset()*60000;
}

YWC.exec = {
	"execQueue":[]
	,"setQueue":function(f){YWC.exec.execQueue.push(f);}
	,"execDaemon":function(){
		var q = YWC.exec.execQueue;
		for (i = 0; i < q.length; i++) {
			window.setTimeout(q[i],25); YWC.exec.execQueue.splice(i,1);
		} window.setTimeout("YWC.exec.execDaemon();",67);
	}
};
YWC.exec.runDaemon = window.setTimeout("YWC.exec.execDaemon();",67);
YWC.exec.setQueue("YWC.f.coreSetDateTime();");


if (typeof $ != 'undefined') {
	$(window).resize(function(){
		YWC.exec.setQueue("if(typeof YWC.f.uiResetHoverBulge != 'undefined'){YWC.f.uiResetHoverBulge();}");
	});
} else {
	console.log('YWC: uiOnHashChange, uiResetHoverBulge could not be set (jQuery not found)');
}

YWC.f.uiAlertToggle = function(input){
	
	if (input == null) { var input = {}; }
	
	var msgHtml = "";
	if ((input.message != null) && (input.message.length > 0)) {
		msgHtml = "<div class=\"message\">"+input.message+"</div>";
	}
	
	var alertBox = $("div.ywc-alert");
	
	if (input.toggle == null) {
		if (alertBox.length == 0) { input.toggle = true; }
		else { input.toggle = false; }
	} else if (input.toggle) {
		alertBox.remove();
	} else {
	
	}
	
	if (input.toggle) {
		$("body").append(
			"<div class=\"ywc-alert ywc-crnr-10 ywc-unselectable ywc-trans-75\">"
				+"<i class=\"fa fa-refresh fa-spin\"></i>"
				+msgHtml
			+"</div>");
	} else {
		alertBox.remove();
	}
	
}


YWC.f.uiSetSquImg = function(inputObj,style,brdrColor){
	var wd = parseInt(inputObj.width);
	var ht = parseInt(inputObj.height);
	var obj = $(inputObj);
	if (style == null) { var style = 'out'; }
	if ((style == 'out') || (style == 'circle') || (style == 'border-radius')) {
		if (style == 'circle') {
			if (brdrColor == null) { var brdrColor = 'ffffff'; }
			obj.before('<img class="mask" unselectable="on"'
				+' src="'+YWC.uri.cdn+'ywc-image/mask/png/circle-'+brdrColor+'.png"'
				+' />').parent('div.ywc-thmb').addClass('ywc-mask-circle');
		} else if (style == 'border-radius') {
			obj
			//.before('<img class="mask" unselectable="on"'
			//	+' src="'+YWC.uri.cdn+'ywc-image/mask/png/circle-'+brdrColor+'.png"'
			//	+' />')
				.parent('div.ywc-thmb').addClass('ywc-mask-border-radius').addClass('ywc-crnr-5');
		}
		if (wd >= ht) { obj.css({width:((wd/ht)*100)+'%',left:(0-(wd/ht-1)*50)+'%',height:'100%',top:'0%',visibility:'visible'}); }
		else { obj.css({height:(100*ht/wd)+'%',width:'100%',top:(0-(ht/wd-1)*50)+'%',left:'0%',visibility:'visible'}); }
	} else if ((style == 'in') || (style == 'fit')) {
		if (wd >= ht) {
			obj.css({ height: (100*ht/wd)+'%', width: '100%', top:(50-50*ht/wd)+'%', visibility:'visible'}); }
		else { 
			obj.css({height:'100%', width:(100*wd/ht)+'%', left:(50-50*wd/ht)+'%', visibility:'visible'}); }
		if (style == 'fit') {
			var wdHt = [obj.width(),obj.height()];
			var divObj = obj.css({'top':'0%','left':'0%','width':'100%','height':'100%'}).parent('div.ywc-thmb');
			divObj.css({
				'width':wdHt[0]+'px'
				,'height':wdHt[1]+'px'
				,'border':'none'
				,'overflow':'visible'
				});
		}
	} else if (style == 'width') {
		var divObj = obj.parent('div.ywc-thmb');
		var divHt = divObj.height();
		var imgHt = obj.css({width:'100%',top:'0%',left:'0%',visibility:'visible'}).height();
		if (divHt > imgHt) {
			divObj.css({height:imgHt+'px'});
		} else if (divHt < imgHt) {	
			obj.css({top:Math.round(-(imgHt-divHt)/2)+'px'});
		}
	}
}



YWC.f.uiSetHoverBulge = function(obj,offset,ref,toggleSrc) {
	if (offset == null) { var offset = 8; }
	if (toggleSrc == null) { var toggleSrc = false; }
	var thisObj = $(obj);
	var thisPos = thisObj.position();
	var info = [thisPos.left,thisPos.top,thisObj.width(),thisObj.height()];
	var newInfo = [Math.round(info[0]-offset/2),Math.round(info[1]-offset/2),(info[2]+offset),(info[3]+offset)];
	if (ref != null) { var ratio = info[2]/info[3];
		if (ref == 'hz') {
			newInfo = [newInfo[0],Math.round(info[1]-offset/2/ratio),newInfo[2],Math.round(info[3]+offset/ratio)];
		} else if (ref == 'vt') {
			newInfo = [Math.round(info[0]-ratio*offset/2),newInfo[1],Math.round(info[2]+ratio*offset),newInfo[3]];
		}
	}
	var src = ['',''];
	if (toggleSrc) {
		src[0] = obj.src; src[1] = src[0].substr(0,src[0].lastIndexOf('.'))+'_'+src[0].substr(src[0].lastIndexOf('.'));
	}
	var origPos = ['left','right','top','bottom'];
	for (i in origPos) { var pos = obj.style[origPos[i]]/*thisObj.css(origPos[i])*/; if (pos!='auto') { origPos[i] = pos; } else { origPos[i] = ''; } }
	thisObj.attr({"onload":""
		,"data-ywc-orig-top":origPos[2],"data-ywc-orig-bottom":origPos[3]
		,"data-ywc-orig-left":origPos[0],"data-ywc-orig-right":origPos[1]
		,"data-ywc-orig-offset":offset,"data-ywc-orig-ref":ref,"data-ywc-orig-togglesrc":toggleSrc
		,"onmouseover":"YWC.f.uiDoBulge(this,["+newInfo[0]+","+newInfo[1]+","+newInfo[2]+","+newInfo[3]+"],'"+src[1]+"');"
		,"onmouseout":"YWC.f.uiDoBulge(this,["+info[0]+","+info[1]+","+info[2]+","+info[3]+"],'"+src[0]+"');"})
		.addClass("ywc-hover-bulge").css({left:info[0]+'px',top:info[1]+'px'});
}

YWC.f.uiResetHoverBulge = function() {
	$(".ywc-hover-bulge").each(function(){
		var obj = $(this); var newCss = {};
		var origProp = [obj.attr("data-ywc-orig-left"),obj.attr("data-ywc-orig-right")
				,obj.attr("data-ywc-orig-top"),obj.attr("data-ywc-orig-bottom")
				,obj.attr("data-ywc-orig-offset"),obj.attr("data-ywc-orig-ref"),obj.attr("data-ywc-orig-togglesrc")
				];
		if (origProp[0] != "") { newCss.left = origProp[0]; }
		if (origProp[1] != "") { newCss.right = origProp[1]; }
		if (origProp[2] != "") { newCss.top = origProp[2]; }
		if (origProp[3] != "") { newCss.bottom = origProp[3]; }
		obj.css(newCss);
		if (origProp[4] != "") { origProp[4] = parseInt(origProp[4]); }
		if (origProp[6] != "false") { origProp[6] = false; } else { origProp[6] = true; }
		YWC.f.uiSetHoverBulge(this,origProp[4],origProp[5],origProp[6]);
	});
}

YWC.f.uiDoBulge = function(obj,info,src) {
	$(obj).animate({'left':info[0]+'px','top':info[1]+'px','width':info[2]+'px','height':info[3]+'px'},100,function(){
		if (src != '') { this.src = src; }
	});
}

YWC.f.uiItemFadeIn = function(inputObj,toggle) {
	if (toggle == null) { var toggle = true; }
	var targetOpacity = 0;
	if (toggle) { targetOpacity = 1; }
	$(inputObj).animate({'opacity':targetOpacity},1000);
}

YWC.f.uiSetHoverFade = function(cstmSlctr) {
	var slctr = ".ywc-fader";
	if (cstmSlctr != null) {
		slctr = cstmSlctr;
		$(slctr).attr('onload','');
	}
	var fadeTime = 200;
	$(slctr).each(function(){
		var obj = $(this);
		var vals = [obj.css("opacity"),0,0];
		if (vals[0] == 1) { vals[1] = 1; vals[2] = 0.75; }
		else { vals[1] = vals[0]; vals[2] = 2*vals[0]; }
		obj.hover(
			function(){ $(this).fadeTo(fadeTime,vals[2]); }
			,function(){ $(this).fadeTo(fadeTime,vals[1]); }
		).attr('onload','');
	});
}

YWC.f.uiSetHoverClassToggle = function(cstmSlctr,className,replaceWithClass) {
	var params = "'"+className+"'";
	if (replaceWithClass != null) { params += ",'"+replaceWithClass+"'"; }
	$(cstmSlctr).attr({"onload":""
		,"onmouseover":"YWC.f.uiDoClassToggle(this,"+params+");"
		,"onmouseout":"YWC.f.uiDoClassToggle(this,"+params+");"
	});
}

YWC.f.uiDoClassToggle = function(inputObj,className,replaceWithClass) {
	var obj = $(inputObj);
	if (obj.hasClass(className)) {
		obj.removeClass(className).each(function(){
			if (replaceWithClass != null) { $(this).addClass(replaceWithClass); }
		});
	} else {
		obj.addClass(className).each(function(){
			if (replaceWithClass != null) { $(this).removeClass(replaceWithClass); }
		});
	}
}

YWC.f.uiSetHoverImageToggle = function(obj) {
	var src = obj.src; var newSrc = src.substr(0,src.lastIndexOf('.'))+'_'+src.substr(src.lastIndexOf('.'));
	$(obj).attr({"onmouseover":"this.src='"+newSrc+"';","onmouseout":"this.src='"+src+"';","onload":""});
}

YWC.f.uiDoImageToggle = function(obj,toggle) {
	var src = obj.src;
	var dotPos = src.lastIndexOf('.');
	if (toggle) {
		src = src.substr(0,dotPos)+'_'+src.substr(dotPos);
	} else if (src.substr(dotPos-1,1) == '_') {
		src = src.substr(0,dotPos-1)+src.substr(dotPos);
	}
	obj.src = src;
}


YWC.f.uiLoadJqueryUI = function(callback) {
	
	if (callback != null) { YWC.ui.jQueryUI.onLoad = callback; }
	
	var themeUri = "vendor/jquery-ui/jquery-ui-themes/"+YWC.ui.jQueryUI.v+"/"+YWC.ui.jQueryUI.theme+"/jquery-ui.min.css";
	if (YWC.ui.jQueryUI.themeUri != "") { themeUri = YWC.ui.jQueryUI.themeUri; }
	
	if (YWC.f.coreLoadFileAsync("script","jquery-ui"
			,YWC.uri.cdn+"vendor/jquery-ui/jquery-ui/"+YWC.ui.jQueryUI.v+"/jquery-ui.min.js"
			,"YWC.f.uiLoadJqueryUI();") ){

	} else if (YWC.f.coreLoadFileAsync("link","jquery-ui"
			,YWC.uri.cdn+themeUri
			,"YWC.f.uiLoadJqueryUI();") ){

	} else if ($().button) {
		var complete = setTimeout(YWC.ui.jQueryUI.onLoad,10);
	} else {
		var loop = setTimeout("YWC.f.uiLoadJqueryUI();",10);
	}
}


YWC.f.xHover = function(toggle,id,colors) {
	var clr = [YWC.popup.xColor,YWC.popup.xBgColor];
	if (typeof colors == "object") { clr = colors; }
	if (toggle) { clr = [clr[1],clr[0]]; }
	document.getElementById('ywc-x-1-'+id).style.color = '#'+clr[1];
	document.getElementById('ywc-x-2-'+id).style.color = '#'+clr[0];
	document.getElementById('ywc-x-3-'+id).style.color = '#'+clr[1];
}


//YWC.f.coreSetDefault("uri","cdn","//ywccdn.s3.amazonaws.com/public/");
//YWC.f.coreSetDefault("uri","cdn",YWC.uri.pre+"public/",true);


	
	