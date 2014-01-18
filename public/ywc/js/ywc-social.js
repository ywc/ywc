



YWC.social.facebook.srcUri[0] = "//connect.facebook.net/en_US/all.js#xfbml=1&status=1&cookie=1&oauth=1";
YWC.social.twitter.srcUri[0] = "//platform.twitter.com/anywhere.js";
YWC.social.twitter.srcUri[1] = "//platform.twitter.com/widgets.js";
YWC.social.googleplus.srcUri[0] = "//apis.google.com/js/plusone.js";
YWC.social.pinterest.srcUri[0] = "//assets.pinterest.com/js/pinit.js";
//YWC.social.googlemaps.srcUri[0] = "//maps.googleapis.com/maps/api/js?sensor=false";

YWC.social.twitter.srcParams[0] = {id:YWC.social.twitter.appId};



YWC.f.socialDrawLikeBttn = function(site,uri,attr,targetSlctr) {
	if (typeof targetSlctr == 'undefined') { var targetSlctr = 'div.ywc-'+site+'-like-container'; }
	
	if (typeof attr.send == 'undefined') { attr.send = false; }
	var extraAttr = ""; for (i in attr) { 
		if (i != 'count') { extraAttr += ' '+i+'="'+String(attr[i]).replace(/"/g,"'")+'"'; }
	}
	if (site == "facebook") {
		if (attr['style']=='vertical') { extraAttr += ' layout="box_count"'; }
		else { extraAttr += ' layout="button_count"'; }
		var html = '<fb:like href="'+uri+'" show_faces="false"'+extraAttr+'></fb:like>';
		if (attr['count']=='false') { html = '<iframe src="//www.facebook.com/plugins/like.php'
			+'?href&amp;send=false&amp;layout=standard&amp;width=450';
		 for (i in attr) { html += '&amp;='+(attr[i]+"").replace(/"/g,"'"); }	
		 html += '&amp;height=35&amp;appId='+YWC.social.facebook.appId+'" scrolling="no"'
		+' frameborder="0" style="border:none;overflow:hidden;width:58px;height:35px;"'
		+' allowTransparency="true"></iframe>'; }
	} else if (site == "twitter") {
		if (attr['count']=='false') { extraAttr += ' data-count="none"'; }
		if (attr['style']=='vertical') { extraAttr += ' data-count="vertical"'; }
		var html = '<a href="https://twitter.com/share" class="twitter-share-button"'
			+' data-url="'+uri+'"'+extraAttr+'>Tweet</a>';
	} else if (site == "googleplus") {
		if (attr['count']=='false') { extraAttr += ' data-annotation="none" data-size="tall"'; }
		if (attr['style']=='vertical') { extraAttr += ' data-size="tall"'; }
		var html = '<div class="g-plusone" data-href="'+uri+'"'+extraAttr+'></div>';
	} else if (site == "pinterest") {	
		if (attr['style']=='vertical') { extraAttr += ' count-layout="vertical"'; }
		else { extraAttr += ' count-layout="horizontal"'; }
		var html = '<a class="pin-it-button" '+extraAttr+' href="http://pinterest.com/pin/create/button/?url='
			+encodeURIComponent('http://enthu.se/')
			+'&media='+encodeURIComponent('http://enthu.se/image')
			+'"><img border="0" src="//assets.pinterest.com/images/PinExt.png" title="Pin It" /></a>';
	}
	
	
	YWC.f.socialExec(site,function(){
		$(targetSlctr).each(function(){
			$(this).html(html);
			console.log('YWC: drawing '+site+' like button');
			if (window[YWC.social[site]['var'][0]] != null) {
				if (site == "facebook") {
					FB.XFBML.parse(this);
				} else if (site == "twitter") {
					twttr.widgets.load();
				} else if (site == "googleplus") {
	//				seems to work automatically, but I doubt that's actually reliably true...
				} else if (site == "pinterest") {
	//				not yet built
				}
			}
		});
	});
}

YWC.f.socialCheckAuth = function(site,authCallback) {
//	console.log('ywcSocialAuth');
	if (site == 'facebook') {
		FB.getLoginStatus(function(response){
			console.log('FB Login: '+response.status);
			if (response.status === 'connected') {
				YWC.f.socialCheckAuthPopup('facebook',authCallback);
			} else {
				YWC.f.socialCheckAuthPopup('facebook',authCallback);
			}
		});

	} else if (site == 'twitter') {
			
		twttr.anywhere(function(T){
			if (!T.isConnected()){
				YWC.f.socialCheckAuthPopup('twitter',authCallback);
			} else {
				if (typeof authCallback != 'undefined') {
					var exec = setTimeout(authCallback,10);
				}
			}
		});
	}
	
}

YWC.f.socialCheckAuthPopup = function(site,authCallback) {
	
	var popupParams = { 'width':250, 'top': Math.round($(window).height()/2-200), 'z':2, 'xToggle':false };
	if (site == 'facebook') {
		popupParams.callback = function(){
			$(".ywc-social-facebook-login-bttn").click(function(){
				FB.login(function(){
					var killPopup = setTimeout("YWC.f.popupKill(2);",500);
					var exec = setTimeout(authCallback,10);
				},{ scope:'publish_stream' });
			});
		};
	} else if (site == 'twitter') {
		window.ywcSocialAuthCallbackTwitter = function() {
			var killPopup = setTimeout("YWC.f.popupKill(2);",500);
			var exec = setTimeout(authCallback,10);
			if (typeof authCallback != 'undefined') {
				twttr.anywhere(function(T){
					if (!T.isConnected()){ 
						T.bind("authComplete", authCallback);
					}
				});
			}
			
		};
		popupParams.callback = function(){
			$(".ywc-social-twitter-login-bttn").click(function(){
				//	twttr.anywhere(function(T){ T.signIn(); });
				enthuseLogIn('twitter','',true,'ywcSocialAuthCallbackTwitter');
			});
		};
	}

	popupParams.source = "<div class=\"ywc-social-"+site+"-login\" style=\""
			+"position:relative;float:left;width:230px;margin-left:10px;margin-top:0px;text-align:center;border:none;"
		+"\"><span style=\""
			+"position:relative;clear:both;font-size:18px;"
		+"\">In order to complete your request, please sign into your "+site+" account:</span>"
		+"<br /><br /><img style=\"position:relative;width:230px;clear:both;cursor:pointer;\""
			+" src=\""+YWC.uri.pre+"lib/ywc-image/bttn/social/"+site+"-login-02.png\""
			+" class=\"ywc-social-"+site+"-login-bttn\" onLoad=\"YWC.f.uiSetHoverImageToggle(this)\" />"
		+"</div>";
	
	YWC.f.popupLoad(popupParams);

}

YWC.f.socialSubmitPost = function(site,params,callback) {
	// possible inputs to params object: link, title, body, image, caption
	
	var sendParams = {link:'',title:'',body:'',image:'',caption:''};
	for (i in params) { sendParams[i] = params[i]; }
	
	if (window[YWC.social[site]['var'][0]] != null) {
		if (site == "facebook") {
			
			if (params.title != null) { sendParams.name = params.title; }
			if (params.image != null) { sendParams.picture = params.image; }
			if (params.body != null) { sendParams.caption = params.body; }
			if (params.caption != null) { sendParams.description = params.caption; }
			
			FB.api('/me/feed','post', sendParams, function(response) {
				if (!response || response.error) {
					console.log('FB Error: '+response.error.type)
					if (response.error.type === "OAuthException") {
						YWC.f.socialCheckAuth(site,function(){ YWC.f.socialSubmitPost(site,params,callback); });
					} else {
					}
				} else {
					var exec = setTimeout(callback,10);
				}
			});
			
		} else if (site == "twitter") {
			
			var message = "";
			if (sendParams.link != '') { message += " "+sendParams.link; }
			sendParams.body = YWC.f.strLimitLength(sendParams.body,(140-message.length))+message;
			twttr.anywhere(function(T){
				if (T.isConnected()){
					T.Status.update(sendParams.body);
				} else if (typeof twttr.anywhere.token != 'undefined') {
					T.Status.update(sendParams.body);
				} else {
					YWC.f.socialCheckAuth('twitter',function(){ twttr.anywhere(function(T){ T.Status.update(sendParams.body); }); });
			//		alert('wasnt logged');
				}
			});

		}
	}
}

YWC.f.socialExec = function(site,callback) {
	
	if (typeof window[YWC.social[site]['var'][0]] == 'undefined') {
		window[YWC.social[site]['var'][0]] = null;
		var exec = setTimeout(function(){YWC.f.socialExec(site,callback);},10);
	} else if (YWC.f.socialDrawHelperHtml(site)) {
		var exec = setTimeout(function(){YWC.f.socialExec(site,callback);},10);
	} else if ((YWC.social[site].srcUri[0] != null)
		&& YWC.f.coreLoadFileAsync("script", "social-"+site+"-0", YWC.f.socialAppendSourceParams(site,0), function(){YWC.f.socialExec(site,callback);})){

	} else if ((YWC.social[site].srcUri[1] != null)
		&& YWC.f.coreLoadFileAsync("script", "social-"+site+"-1", YWC.f.socialAppendSourceParams(site,1), function(){YWC.f.socialExec(site,callback);})){
		
	} else if ((window[YWC.social[site]['var'][0]] != null)
		&& YWC.f.socialInit(site)
		) {
		var exec = setTimeout(function(){YWC.f.socialExec(site,callback);},10);
	} else if (window[YWC.social[site]['var'][0]] != null) {
//		console.log('YWC.f.socialExec ('+site+') -> complete -> running callback');
		var exec = setTimeout(callback,10);
		YWC.social[site].onload = null;
	} else {
		var exec = setTimeout(function(){YWC.f.socialExec(site,callback);},10);
	}
}

YWC.f.socialDrawHelperHtml = function(site) {
	var rtrn = false;
	if ((site == 'facebook') && (!document.getElementById("fb-root"))) {
		var i = document.createElement("div");
		i.id = "fb-root";
		document.getElementsByTagName("body")[0].appendChild(i);
		rtrn = true;
	}
	return rtrn;
}


YWC.f.socialAppendSourceParams = function(site,i) {
	var rtrn = YWC.social[site].srcUri[i];
	
	if (YWC.social[site].srcParams[i] != null) {
		rtrn += "?x-ywc-social-id="+site+"-"+i;
		for (paramName in YWC.social[site].srcParams[i]) {
			rtrn += "&"+paramName+"="+YWC.social[site].srcParams[i][paramName];
		}
	}
	return rtrn;
}

YWC.f.socialInit = function(site) {

	if (site=="facebook") {
		if (typeof window.fbAsyncInit == 'undefined') {
			window.fbAsyncInit = function(){
				console.log('YWC: socialInit '+site);
				FB.init({ appId:YWC.social.facebook.appId
					,status:true, cookie:true, xfbml:true
					,logging:true, oauth:true, frictionlessRequests:true });
				FB.getLoginStatus(function(response){
				//	console.log('FB Login Status: '+response.status);
					YWC.social[site].doInit = false;
				});
			};
		} else {
			YWC.social[site].doInit = false;
		}
	} else if (site == 'twitter') {
		if ((typeof twttr != 'undefined') && (typeof twttr.anywhere != 'undefined')) {
			console.log('YWC: socialInit '+site);
			twttr.anywhere.config({ 
				callbackURL: document.location.protocol+"//"+document.domain+"/lib/ywc/oauth/twitter/?appId="+YWC.social.twitter.appId });
			twttr.anywhere(function(T){ window.YWC.social[site].doInit = false;});
		}
	} else {	
		YWC.social[site].doInit = false;
	} 
	
	return YWC.social[site].doInit;
}



YWC.f.socialSearchAttach = function(site,targetInputId,onSelectJs,extraParams) {
	if (extraParams == null) { var extraParams = {}; }
	YWC.f.socialExec(site,function(){
//	YWC.f.socialCheckAuth(site,function(){
	YWC.f.uiLoadJqueryUI(function(){
		$("input#ywc-input-text-"+targetInputId).autocomplete({
			source: function(request,response) { YWC.f.socialSearchRequest(request,response,site,extraParams); }
			,select: onSelectJs
			,delay:250, minLength:3, autoFocus:false
			}).data('autocomplete')._renderItem = function(ul,item) {
				return $('<li></li>').data('item.autocomplete',item)
				.append('<a>'+item.label+'</a>').appendTo(ul);
		};
	});
//	});
	});
}

YWC.f.socialSearchRequest = function(request,response,site,extraParams) {
	
	var sendParams = {'limit':8,'type':'user'};
	// extraParams can pass in changes to the default search behavior, such as changing the type, limit, etc.
	for (i in extraParams) { sendParams[i] = extraParams[i]; }
	
	if (site == 'facebook') {
		FB.api("search", {type: sendParams.type, q: request.term, limit: sendParams.limit }, function(data) {
        	response(YWC.f.socialSearchParse(data,site));
    	});
	} else if (site == 'twitter') {	
	
	}
}

YWC.f.socialSearchParse = function(response,site) {
    var srcArray = []; var resultsArray = [];
	if (site == 'facebook') { srcArray = response.data; }
	else if (site == 'twitter') { srcArray = response; }
	for (i in srcArray) { resultsArray.push(YWC.f.socialSearchDrawItem(srcArray[i],site)); }
    return resultsArray;
}

YWC.f.socialSearchDrawItem = function(inputParams,site) {
	
	var rtrnObj = {'id':null,'value':null,'label':null};
	var innerObj = {'meta':'.','img':'','title':''};
	
	if (site == 'facebook') {
		innerObj.title = inputParams.name;
		innerObj.img = '//graph.facebook.com/'+inputParams.id+'/picture';
		if (inputParams.category != null) { innerObj.meta = inputParams.category; }
		rtrnObj.id = inputParams.id;
		rtrnObj.value = inputParams.name;
	} else if (site == 'twitter') {
	
	}
	
	rtrnObj.label = '<span style="font-weight:bold;">'
				+'<img style="position:relative;float:left;width:35px;height:35px;margin-right:8px;"'
					+' src="'+innerObj.img+'" onLoad="" />'
					+innerObj.title
				+'<span style="font-size:90%;font-weight:normal;">'
				+'<br />'+innerObj.meta
			//	+' ( Likes: <span id="autocomplete_likes_count_'+result.id+'">Loading...</span> )'
				+'</span>'
			+'</span>';
			
	return rtrnObj;
	
}
