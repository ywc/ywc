
YWC.f.coreSetDefault("popup","isMouseDown",false);
YWC.f.coreSetDefault("popup","popupObj",null);
YWC.f.coreSetDefault("popup","globalXpos",0);
YWC.f.coreSetDefault("popup","globalYpos",0);
YWC.f.coreSetDefault("popup","dragUpdateFreq",25);
YWC.f.coreSetDefault("popup","dragEnabled",true);
YWC.f.coreSetDefault("popup","fadeInTime",200);
YWC.f.coreSetDefault("popup","xWidth",33);
YWC.f.coreSetDefault("popup","xOffset",0);
YWC.f.coreSetDefault("popup","xType","box");
YWC.f.coreSetDefault("popup","xInvert",false);
YWC.f.coreSetDefault("popup","xColor","9f9f9f");
YWC.f.coreSetDefault("popup","xBgColor","ffffff");
YWC.f.coreSetDefault("popup","xToggle",true);
YWC.f.coreSetDefault("popup","escToKill",true);
YWC.f.coreSetDefault("popup","bgClickToKill",false);
YWC.f.coreSetDefault("popup","marginWidth",33);
YWC.f.coreSetDefault("popup","bgColor","ffffff");
YWC.f.coreSetDefault("popup","bgToggle",true);
YWC.f.coreSetDefault("popup","anchorMargin",33);
YWC.f.coreSetDefault("popup","anchorArrowToggle",true);
YWC.f.coreSetDefault("popup","anchorOn","right");
//YWC.f.coreSetDefault("popup","anchorCenterToggle",false);
YWC.f.coreSetDefault("popup","shadowToggle",true);
YWC.f.coreSetDefault("popup","shadowColor","666666");
YWC.f.coreSetDefault("popup","brdrRadius",33);
YWC.f.coreSetDefault("popup","brdrColor","9f9f9f");
YWC.f.coreSetDefault("popup","brdrWidth",1);
YWC.f.coreSetDefault("popup","hazeColor","000000");
YWC.f.coreSetDefault("popup","hazeOpacity",0.5);
YWC.f.coreSetDefault("popup","allowCache",false);

YWC.popup.hoverState = {};
YWC.popup.hoverAction = {};

YWC.f.popupMouseUp = function() { YWC.popup.isMouseDown = false; };
YWC.f.popupMouseMoves = function(ev) { ev = ev || window.event; if (ev != null) { var target = ev.target || ev.srcElement; var mousePos = YWC.f.popupMouseCoords(ev); YWC.popup.globalXpos = mousePos.x; YWC.popup.globalYpos = mousePos.y; } }
YWC.f.popupMouseCoords = function(ev) { if (ev.pageX || ev.pageY) { return { x:ev.pageX, y:ev.pageY }; } else { return { x:(ev.clientX+document.body.scrollLeft-document.body.clientLeft), y:(ev.clientY+document.body.scrollTop-document.body.clientTop) }; } }
YWC.f.popupMovePopupStart = function(popup_id) { YWC.popup.isMouseDown = true; YWC.popup.popupObj = $('div#'+popup_id+':first'); YWC.popup.popupBufferObj = $('div#'+popup_id+'-buffer:first'); if (YWC.popup.popupBufferObj.length > 0) { YWC.popup.popupBufferObj.css('visibility','visible'); } YWC.f.popupMovePopup(YWC.popup.globalXpos,YWC.popup.globalYpos); }
YWC.f.popupMovePopup = function(xpos,ypos) { if (YWC.popup.isMouseDown == true) { var pos = YWC.popup.popupObj.position(); YWC.popup.popupObj.css({'left':(pos.left+YWC.popup.globalXpos-xpos)+'px','top':(pos.top+YWC.popup.globalYpos-ypos)+'px'}); var t = setTimeout("YWC.f.popupMovePopup("+YWC.popup.globalXpos+","+YWC.popup.globalYpos+");",YWC.popup.dragUpdateFreq); } else { if (YWC.popup.popupBufferObj.length > 0) { YWC.popup.popupBufferObj.css('visibility','hidden'); } YWC.popup.popupObj = null; YWC.popup.popupBufferObj = null; } }

document.onmousemove = YWC.f.popupMouseMoves;
document.onmouseup = YWC.f.popupMouseUp;

YWC.f.popupLoad = function(inputParams) {
	
	var scrollTop = document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop;
	if (inputParams.top == null) { inputParams.top = 90; }
	inputParams.top = inputParams.top+scrollTop;
	
	if (inputParams.group == null) { inputParams.group = "univ"; }
	if (inputParams.params == null) { inputParams.params = {}; }
	if (inputParams.id == null) { inputParams.id = ""+Math.round(Math.random()*10000000000); }
	if (inputParams.z == null) { inputParams.z = 1; }
	if (inputParams.cssClasses == null) { inputParams.cssClasses = ""; }
	if (inputParams.fadeInTime == null) { inputParams.fadeInTime = YWC.popup.fadeInTime; }
	if (inputParams.escToKill == null) { inputParams.escToKill = YWC.popup.escToKill; }
	if (inputParams.bgClickToKill == null) { inputParams.bgClickToKill = YWC.popup.bgClickToKill; }
	if (inputParams.hazeColor == null) { inputParams.hazeColor = YWC.popup.hazeColor; }
	if (inputParams.hazeOpacity == null) { inputParams.hazeOpacity = YWC.popup.hazeOpacity; }
	if (inputParams.allowCache == null) { inputParams.allowCache = YWC.popup.allowCache; }
	
	// determine whether to draw a background, attempting not to stack backgrounds unless forced by bgToggle
	if ($("div.ywc-popup-bg:visible[id!=ywc-popup-bg-"+inputParams.group+"-"+inputParams.z+"]").length > 0) {
		if (inputParams.bgToggle == null) { inputParams.bgToggle = false; }
	} else {
		if (inputParams.bgToggle == null) { inputParams.bgToggle = YWC.popup.bgToggle; }
	}
	
	var bgHtml = "";
	if (inputParams.bgToggle && ($("div#ywc-popup-bg-"+inputParams.group+"-"+inputParams.z).length == 0)) {
		bgHtml = "<div id=\"ywc-popup-bg-"+inputParams.group+"-"+inputParams.z+"\""
			+" class=\"ywc-popup-bg ywc-trans-0 ywc-unselectable\" unselectable=\"on\"></div>";
	}
	
	//makes sure the popup won't be blocked (should be improved...)
	if (inputParams.z == 1) {
		YWC.f.popupKill(2);
	}
	
	$("div#ywc-popup-container-"+inputParams.group+"-"+inputParams.z).remove();
	
	$("body").append("<div id=\"ywc-popup-container-"+inputParams.group+"-"+inputParams.z+"\""
				+" class=\"ywc-popup-container\"></div>"+bgHtml);
	var targetObj = $("div#ywc-popup-container-"+inputParams.group+"-"+inputParams.z);

	var setStyle = {'visibility':'visible'};
	if (BrowserDetect.browser === 'Explorer') {
		setStyle = {'left':'0%','width':'100%','height':'400%','visibility':'visible'};
	}
	
	if (inputParams.anchorObj == null) {
		inputParams.anchorArrowToggle = false;
		inputParams.anchorOn = 'none';
	}
	
	inputParams.targetObj = targetObj;
	
	targetObj.css(setStyle).html(YWC.f.popupGenerateHtml(inputParams)).fadeTo(inputParams.fadeInTime,1);
	
	if (inputParams.bgToggle) {
		$("div#ywc-popup-bg-"+inputParams.group+"-"+inputParams.z)
			.css({'visibility':'visible','background-color':'#'+inputParams.hazeColor})
			.fadeTo('fast',inputParams.hazeOpacity,function(){
				if (inputParams.bgClickToKill) {
					$(this).attr("onclick","YWC.f.popupKill('"+inputParams.z+"');");
				}
		});
	}
	
	if (inputParams.escToKill) {
		$(document).bind('keyup',function(pressed){
			if (pressed.which == 27) {
				pressed.preventDefault();
				YWC.f.popupKill(inputParams.z);
			}
		});
	}
	
	if (inputParams.source != null) {
		YWC.f.popupDrawShadow(inputParams);
		var innerBox = targetObj.find("td#popup-contents-"+inputParams.id);
		YWC.popup.hoverState[inputParams.id] = false;
		if (inputParams.source.indexOf("<") == -1) {
			if (inputParams.source.indexOf('http') == -1) { inputParams.source = YWC.uri.pre+inputParams.source; }
			if (!inputParams.allowCache) { inputParams.source = inputParams.source+'?ywcNoCache='+Math.round(Math.random()*10000000000); }
			if (inputParams.params.preUri == null) { inputParams.params.preUri = YWC.uri.pre; }
			innerBox.load(inputParams.source, inputParams.params, function() {
				innerBox.siblings("td").find("div.min-height").remove();
				if (inputParams.callback != null) { var popupCallback = setTimeout(inputParams.callback,10); }
			});
		} else {
			innerBox.html(inputParams.source);
			innerBox.siblings("td").find("div.min-height").remove();
			if (inputParams.callback != null) { var popupCallback = setTimeout(inputParams.callback,10); }
		}
	}
}

YWC.f.popupGenerateHtml = function(inputParams) {
	
	var z = 1; if (inputParams.z != null) { z = parseInt(inputParams.z); }
	var id = ''; if (inputParams.id != null) { id = inputParams.id; }

	var top = 0;
	if (inputParams.top != null) { top = parseInt(inputParams.top); }

	var left = 0;
	if (inputParams.left != null) { left = parseInt(inputParams.left); }

	var width = 700;
	if (inputParams.width != null) { width = parseInt(inputParams.width); }		
	
	var anchorMargin = YWC.popup.anchorMargin;
	if (inputParams.anchorMargin != null) { anchorMargin = parseInt(inputParams.anchorMargin); }

	YWC.popup.hoverAction[inputParams.id] = ['',''];
	if (inputParams.hoverOverAction != null) {
		YWC.popup.hoverAction[inputParams.id][0] = inputParams.hoverOverAction; }
	if (inputParams.hoverOutAction != null) {
		YWC.popup.hoverAction[inputParams.id][1] = inputParams.hoverOutAction; }	

	var anchorArrowToggle = YWC.popup.anchorArrowToggle;
	if (inputParams.anchorArrowToggle != null) { anchorArrowToggle = inputParams.anchorArrowToggle; }
	
	var anchorOn = YWC.popup.anchorOn;
	if (inputParams.anchorOn != null) { anchorOn = inputParams.anchorOn; }
	
	var dragEnabled = YWC.popup.dragEnabled;
	if (inputParams.dragEnabled != null) { dragEnabled = inputParams.dragEnabled; }
	
	var cssClasses = "";
	if (inputParams.cssClasses != null) { cssClasses = inputParams.cssClasses; }
		
	var marginWidth = YWC.popup.marginWidth;
	if (inputParams.marginWidth != null) { marginWidth = parseInt(inputParams.marginWidth); }
	
	var brdrWidth = YWC.popup.brdrWidth;
	if (inputParams.brdrWidth != null) { brdrWidth = parseInt(inputParams.brdrWidth); }	

	var brdrRadius = YWC.popup.brdrRadius;
	if (inputParams.brdrRadius != null) { brdrRadius = parseInt(inputParams.brdrRadius); }	
	
	var xType = YWC.popup.xType;
	if (inputParams.xType != null) { xType = inputParams.xType; }

	var xToggle = YWC.popup.xToggle;
	if (inputParams.xToggle != null) { xToggle = inputParams.xToggle; }	
	
	var xWidth = YWC.popup.xWidth;
	if (inputParams.xWidth != null) { xWidth = parseInt(inputParams.xWidth); }
	
	var xOffset = YWC.popup.xOffset;
	if (inputParams.xOffset != null) { xOffset = parseInt(inputParams.xOffset); }
	
	var xBgColor = YWC.popup.xBgColor;
	if (inputParams.xBgColor != null) { xBgColor = inputParams.xBgColor; }
	
	var xColor = YWC.popup.xColor;
	if (inputParams.xColor != null) { xColor = inputParams.xColor; }

	var xInvert = YWC.popup.xInvert;
	if (inputParams.xInvert != null) { xInvert = inputParams.xInvert; }	
	
	var brdrColor = YWC.popup.brdrColor;
	if (inputParams.brdrColor != null) { brdrColor = inputParams.brdrColor; }	

	var bgColor = YWC.popup.bgColor;
	if (inputParams.bgColor != null) { bgColor = inputParams.bgColor; }
	
	var positionParams = {
		'left':left, 'top':top, 'width':width
		,'anchorObj':inputParams.anchorObj, 'targetObj':inputParams.targetObj
		,'anchorMargin':anchorMargin, 'anchorOn':anchorOn
		,'marginWidth':marginWidth, 'brdrWidth':brdrWidth, 'brdrRadius':brdrRadius
	};
	
	var pos = YWC.f.popupCalculateOffset(positionParams);
	
	var minHeight = Math.round(width/5);
	if (anchorArrowToggle) { minHeight = Math.abs(pos.arrowY)+2*anchorMargin; }
	
	var dragHtml = {'js':'','css':''};
	if (dragEnabled) {
		dragHtml.js = 'YWC.f.popupMovePopupStart(\'ywc-popup-'+id+'\');';
		dragHtml.css = 'cursor:move;';
	}
	
	// var xImg = {'src':YWC.uri.pre+'img/special/popupx/'+xType+'/'+xBgColor+'/'+xColor,'mouseOff':'.png','mouseOn':'_.png'};
	// if (xInvert) { xImg.mouseOn = '.png'; xImg.mouseOff = '_.png'; }
	
	var xHtml = '<div class="ywc-popup-x ywc-x ywc-unselectable" unselectable="on" onClick="YWC.f.popupKill('+z+')"'
			+' style="'
				+'top:'+(brdrWidth-xOffset)+'px;'
				+'right:-'+(brdrWidth+xOffset)+'px;'
				+'width:'+xWidth+'px;'
				+'height:'+xWidth+'px;'
				+'font-size:'+xWidth+'px'
			+'"'
			+' onMouseOver="YWC.f.xHover(true,\''+id+'\');"'
			+' onMouseOut="YWC.f.xHover(false,\''+id+'\');"'
			+'>'
//				+'<img id="ywc-popup-x-img-'+id+'" class="ywc-unselectable" unselectable="on" alt="Close" title="Close"'
//				+' src="'+xImg.src+xImg.mouseOff+'" />'
				+'<i id="ywc-x-1-'+id+'" class="ywc-x-1 fa fa-'+((xType=='box') ? 'square' : 'circle')+'" style="color:#'+xBgColor+';"></i>'
				+'<i id="ywc-x-2-'+id+'" class="ywc-x-2 fa fa-'+((xType=='box') ? 'square' : 'circle')+'" style="color:#'+xColor+';"></i>'
				+'<i id="ywc-x-3-'+id+'" class="ywc-x-3 fa fa-times" style="color:#'+xBgColor+';"></i>'
			+'</div>';
			
	if (!xToggle) { xHtml = ''; }

	var brdrTop = '<div class="brdr-top"'
		+' onMouseOver="YWC.f.popupSetHover(\''+id+'\',true);"'
		+' onMouseOut="YWC.f.popupSetHover(\''+id+'\',false);"'
		+' style="'
			+'height:'+marginWidth+'px;'
			+'width:'+(width+2*marginWidth)+'px;'
			+YWC.f.popupCornerCss(brdrRadius,'top','left')
			+YWC.f.popupCornerCss(brdrRadius,'top','right')
			+'background-color:#'+bgColor+';'
			+'border-top:solid '+brdrWidth+'px #'+brdrColor+';'
			+'border-left:solid '+brdrWidth+'px #'+brdrColor+';'
			+'border-right:solid '+brdrWidth+'px #'+brdrColor+';'
			+dragHtml.css
		+'" onMouseDown="'+dragHtml.js+'">'
		+'</div>';

	var brdrBottom = '<div class="brdr-bttm" style="'	
			+'left:-'+brdrWidth+'px;'
			+'"><div style="'
		+'height:'+marginWidth+'px;'
		+'width:'+(width+2*marginWidth)+'px;'
		+'background-color:#'+bgColor+';'
		+YWC.f.popupCornerCss(brdrRadius,'bottom','left')
		+YWC.f.popupCornerCss(brdrRadius,'bottom','right')
		+'border-bottom:solid '+brdrWidth+'px #'+brdrColor+';'
		+'border-left:solid '+brdrWidth+'px #'+brdrColor+';'
		+'border-right:solid '+brdrWidth+'px #'+brdrColor+';'
		+dragHtml.css
		+'"'
		+' onMouseDown="'+dragHtml.js+'">'
		+'</div></div>';

	var brdrLeftRight = '<td style="'
			+'width:'+marginWidth+'px;'
			+dragHtml.css
		+'" onMouseDown="'+dragHtml.js+'">'
		+'<div class="min-height" style="height:'+minHeight+'px;"></div>'
		+'</td>';	
	
	var anchorArrowBrdrColor = brdrColor;
	if (BrowserDetect.browser === 'Explorer') { anchorArrowBrdrColor = bgColor; }
	
	var anchorArrow = '';
	
	if (inputParams.anchorOn != 'none') {
		anchorArrow = '<div class="anchor-arrows"'
				+' onMouseOver="YWC.f.popupSetHover(\''+id+'\',true);"'
				+' onMouseOut="YWC.f.popupSetHover(\''+id+'\',false);"'
				+' style="'
				+'top:'+(pos.arrowY)+'px;'
				+'width:'+(width+(2*marginWidth))+'px;'
				+'">'
				+'<div class="main" style="'
					+'top:'+(0-anchorMargin+brdrRadius)+'px;'
					+'left:'+(pos.arrowX)+'px;'
					+'border:solid '+anchorMargin+'px transparent;'
					+'border-bottom:solid '+anchorMargin+'px #'+bgColor+';'
				+'"></div><div class="main" style="'
					+'top:'+(anchorMargin+brdrRadius)+'px;'
					+'left:'+(pos.arrowX)+'px;'
					+'border:solid '+anchorMargin+'px transparent;'
					+'border-top:solid '+anchorMargin+'px #'+bgColor+';'
				+'"></div>'
				+'<div class="bg" style="'
					+'top:'+(0-anchorMargin+brdrRadius+pos.arrowBgY)+'px;'
					+'left:'+(pos.arrowBgX)+'px;'
					+'border:solid '+anchorMargin+'px transparent;'
					+'border-bottom:solid '+anchorMargin+'px #'+anchorArrowBrdrColor+';'
				+'"></div><div class="bg" style="'
					+'top:'+(anchorMargin+brdrRadius+pos.arrowBgY)+'px;'
					+'left:'+(pos.arrowBgX)+'px;'
					+'border:solid '+anchorMargin+'px transparent;'
					+'border-top:solid '+anchorMargin+'px #'+anchorArrowBrdrColor+';'
				+'"></div>'
			+'</div>'
			/*
			+'<div class="anchor-arrows-block" style="'
				+'background-color:#'+bgColor+';'
				+'width:'+(brdrWidth)+'px;'
				+'height:'+Math.round(2*anchorMargin-(2*brdrWidth)*arrowRatio)+'px;'
				+'top:'+Math.round(brdrRadius+2*brdrWidth*arrowRatio-anchorArrowVert-arrowRatio)+'px;'
				+'left:'+anchorArrowPos[inputParams.anchorOn]['block']+'px;'
			+'"></div>'
			*/
			;
	}
			
	var dragBufferOuter = '<img src="'+YWC.uri.pre+'public/ywc-image/core/trans.gif"'
		+' id="ywc-popup-'+id+'-buffer"'
		+' style="visibility:hidden;position:absolute;border:none;left:-'+(1*marginWidth)+'px;top:-'+(2*marginWidth)+'px;width:'+(width+(4*marginWidth))+'px;height:'+(width+(4*marginWidth))+'px;background-color:blue;z-index:0;-moz-user-select:none;user-select:none;" unselectable="on" />';		

	var boxHtml = '<div class="ywc-popup '+cssClasses+'" id="ywc-popup-'+id+'" style="'
		+'width:'+(width+(2*marginWidth))+'px;'
		+'left:'+pos.popupX+'px;'
		+'top:'+pos.popupY+'px;'
		+'">'
	+ brdrTop
	+'<div class="popup-inner"'
		+' onMouseOver="YWC.f.popupSetHover(\''+id+'\',true);"'
		+' onMouseOut="YWC.f.popupSetHover(\''+id+'\',false);"'
		+' style="'
		+'width:'+(width+2*marginWidth)+'px;'
		+'top:'+marginWidth+'px;'
		+'background-color:#'+bgColor+';'
		+'border-left:solid '+brdrWidth+'px #'+brdrColor+';'
		+'border-right:solid '+brdrWidth+'px #'+brdrColor+';'
		+'">'
	+'<table class="popup-inner"'
		+'><tr>'+brdrLeftRight+'<td id="popup-contents-'+id+'">'

	+'<div class="popup-loading" style="'
		+'width:'+width+'px;'
		+'height:'+minHeight+'px;'
		+'">'
			+'<i class="fa fa-refresh fa-spin ywc-trans-80 ywc-popup-loading" style="'
			+'font-size:'+(Math.round(width/5)-8)+'px;'
			+'margin-top:'+(Math.round((minHeight-width/5)/2)+4)+'px;'
			+'height:'+Math.round(width/5)+'px;'
			+'color:#'+YWC.popup.brdrColor+';'
			+'"></i>'
	+'</div>'
	
		+'</td>'+brdrLeftRight+'</tr>'
 	+'</table>'
	+brdrBottom
	+'</div>'
	+dragBufferOuter
	+xHtml
	+anchorArrow
	+'</div>';

	if (BrowserDetect.browser === 'Explorer') {
		boxHtml = '<div class="ywc-popup-ie-fix">'+boxHtml+'</div>';
	}

return boxHtml

}

YWC.f.popupCalculateOffset = function(positionParams) {

	var marginAndBrdr = (positionParams.marginWidth+positionParams.brdrWidth);
	
	var rtrn = {
		'popupX': (positionParams.left-positionParams.width/2-marginAndBrdr)
		,'popupY': (positionParams.top)
		,'arrowX': 0, 'arrowY': 0
		,'arrowBgX': 0, 'arrowBgY': 0
	};
	
	if (positionParams.anchorObj != null) {
	
		positionParams.anchorObj = $(positionParams.anchorObj);
		
		var brdrX = parseInt(positionParams.anchorObj.css("border-left-width"));
		if (isNaN(brdrX)) { brdrX = 1; }
		var brdrY = parseInt(positionParams.anchorObj.css("border-top-width"));
		if (isNaN(brdrY)) { brdrY = 1; }
	
		var arrowBrdrWidth = 2*Math.cos(Math.PI/4)*positionParams.brdrWidth;
		
		var offset = { 
			'anchor': positionParams.anchorObj.offset()
			,'target': positionParams.targetObj.offset()
		};

		var anchor = {
			'wd': (parseInt(positionParams.anchorObj.width())+2*brdrX)
			,'ht': (parseInt(positionParams.anchorObj.height())+2*brdrY)
		};
		
		rtrn.popupX = offset.anchor.left-offset.target.left;
		rtrn.popupY = offset.anchor.top-offset.target.top+anchor.ht/2-positionParams.brdrRadius-marginAndBrdr;
		
		rtrn.arrowY = marginAndBrdr;
		
		if ((positionParams.anchorOn === 'left') || (positionParams.anchorOn === 'right')) {
			
			rtrn.popupY = rtrn.popupY-positionParams.anchorMargin+positionParams.top;
			rtrn.arrowY = rtrn.arrowY-positionParams.top;
			if (rtrn.arrowY < marginAndBrdr) {
				rtrn.popupY = offset.anchor.top-offset.target.top;
				rtrn.arrowY = 0;
			}
			
			if (positionParams.anchorOn == 'left') {
				rtrn.popupX = rtrn.popupX-positionParams.width-2*marginAndBrdr-positionParams.anchorMargin;
				rtrn.arrowBgX = rtrn.arrowX+2*marginAndBrdr+positionParams.width-positionParams.anchorMargin;
				rtrn.arrowX = rtrn.arrowBgX-arrowBrdrWidth;
			} else if (positionParams.anchorOn == 'right') {
				rtrn.popupX = rtrn.popupX+anchor.wd+positionParams.anchorMargin;
				rtrn.arrowBgX = rtrn.arrowX-positionParams.anchorMargin;
				rtrn.arrowX = rtrn.arrowBgX+arrowBrdrWidth;
			}
			
		} else if ((positionParams.anchorOn === 'bottom') || (positionParams.anchorOn === 'top')) {
			
			rtrn.popupX = rtrn.popupX+anchor.wd/2-positionParams.width/2-marginAndBrdr+positionParams.left;
			rtrn.arrowX = positionParams.width/2+marginAndBrdr-positionParams.anchorMargin-positionParams.left;
			if (rtrn.arrowX < marginAndBrdr) {
				rtrn.popupX = rtrn.popupX+rtrn.arrowX-marginAndBrdr;
				rtrn.arrowX = marginAndBrdr;
			} else if (rtrn.arrowX > (positionParams.width-2*positionParams.anchorMargin+marginAndBrdr)) {
				rtrn.popupX = rtrn.popupX+rtrn.arrowX-positionParams.width+2*positionParams.anchorMargin-marginAndBrdr;
				rtrn.arrowX = positionParams.width-2*positionParams.anchorMargin+marginAndBrdr;
			}
			rtrn.arrowBgX = rtrn.arrowX;
				
			rtrn.popupY = offset.anchor.top-offset.target.top+anchor.ht+positionParams.anchorMargin;
			rtrn.arrowY = arrowBrdrWidth-positionParams.anchorMargin-positionParams.brdrRadius;
			rtrn.arrowBgY = -arrowBrdrWidth;
			
		}
		
		if (BrowserDetect.browser === 'Explorer') {
			rtrn.popupX = rtrn.popupX-Math.round($(document).width()/2);
		}
	}
	
	for (i in rtrn) { rtrn[i] = Math.round(rtrn[i]); }
	
	return rtrn;

}

YWC.f.popupKill = function(z,force,popupGroup) {
	
	if (popupGroup == null) { var popupGroup = "univ"; }
	
	var obj = $("div#ywc-popup-container-"+popupGroup+"-"+z
				+", div#ywc-popup-bg-"+popupGroup+"-"+z);
	
	if (force === true) {
		obj.remove();
	} else {
		obj.fadeTo('fast',0,function(){
			$(this).remove();	
		});
	}
	
	$(document).unbind('keyup');

}

YWC.f.popupSetHover = function(id,toggle) {
	
	YWC.popup.hoverState[id] = toggle;
	
	var ywcPopupHoverExec = setTimeout(function(){
		if ((typeof YWC.popup.hoverAction[id] != 'undefined')
		 	&&(YWC.popup.hoverState[id] == toggle)
		) {
			if (toggle) {
				YWC.exec.setQueue(YWC.popup.hoverAction[id][0]);
			} else {
				YWC.exec.setQueue(YWC.popup.hoverAction[id][1]);
			}
		}
	},50);
}

YWC.f.popupDrawShadow = function(inputParams,lastHeight) {

	if (inputParams.shadowToggle == null) { inputParams.shadowToggle = YWC.popup.shadowToggle; }
	
	if (inputParams.shadowToggle && (BrowserDetect.browser != 'Explorer')) {
		
		var outerBox = $("div#ywc-popup-"+inputParams.id);
		
		if (outerBox.length > 0) {	
			
			var innerBox = outerBox.find("td#popup-contents-"+inputParams.id);
			var boxHeight = parseInt(innerBox.height());
			
			if ((lastHeight == null) || (lastHeight != boxHeight)) {
				
				if (inputParams.shadowColor == null) { inputParams.shadowColor = YWC.popup.shadowColor; }	
				if (inputParams.brdrRadius == null) { inputParams.brdrRadius = YWC.popup.brdrRadius; }	
				if (inputParams.brdrRadiusCss == null) { inputParams.brdrRadiusCss = YWC.f.popupCornerCss(inputParams.brdrRadius); }
				if (inputParams.marginWidth == null) { inputParams.marginWidth = YWC.popup.marginWidth; }	
				if (inputParams.brdrWidth == null) { inputParams.brdrWidth = YWC.popup.brdrWidth; }	
				if (inputParams.shadowId == null) { inputParams.shadowId = 'ywc-popup-drop-shadow-'+inputParams.group+'-'+inputParams.z; }	
	
				if ((lastHeight != null) && (lastHeight != boxHeight)) {
					$("div#"+inputParams.shadowId).remove();
				}
		
				$('<div id="'+inputParams.shadowId+'" class="drop-shadow" style="'
					+'height:'+(boxHeight+(2*inputParams.marginWidth)-2)+'px;'
					+'width:'+(parseInt(innerBox.width())+(2*inputParams.marginWidth)-2)+'px;'
					+'border:solid '+inputParams.brdrWidth+'px #'+inputParams.shadowColor+';'
					+inputParams.brdrRadiusCss
					+'-webkit-box-shadow:0px 0px 5px 2px #'+inputParams.shadowColor+';'
					+'-moz-box-shadow:0px 0px 5px 2px #'+inputParams.shadowColor+';'
					+'-o-box-shadow:0px 0px 5px 2px #'+inputParams.shadowColor+';'
					+'box-shadow:0px 0px 5px 2px #'+inputParams.shadowColor+';'
					+'"></div>').appendTo(outerBox);
			}
			
			YWC.exec.setQueue(function(){
				setTimeout(function(){YWC.f.popupDrawShadow(inputParams,boxHeight);},250);
			});
		}
	}

}

YWC.f.popupCornerCss = function(radius,topBottom,leftRight) {
	var html = "";
	if (topBottom != null) {
		html = "-moz-border-radius-"+topBottom+leftRight+":"+radius+"px;"
			+"-webkit-border-"+topBottom+"-"+leftRight+"-radius:"+radius+"px;"
			+"-khtml-border-"+topBottom+"-"+leftRight+"-radius:"+radius+"px;"
			+"border-"+topBottom+"-"+leftRight+"-radius:"+radius+"px;";
	} else {
		html = "-moz-border-radius:"+radius+"px;"
			+"-webkit-border-radius:"+radius+"px;"
			+"-khtml-border-radius:"+radius+"px;"
			+"border-radius:"+radius+"px;";
	}
	return html;
}

