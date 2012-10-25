
(function(){

	if (typeof window.YWC == 'undefined') {		
		window.YWC = {"uri":{"pre":"//widget.enthu.se/","abs":window.location},"popup":{},"f":{},"map":{},"ui":{},"store":{},"list":{"data":{},"meta":{},"list":{}},"detail":{"data":{},"meta":{}},"input":{"value":{"text":{},"select":{},"checkbox":{},"file":{},"datetime":{},"hidden":{},"custom":{}},"meta":{"jsBlock":{},"dateTime":[{"format":{}}],"lastValue":{"text":{},"select":{},"checkbox":{},"file":{},"datetime":{},"hidden":{}}}},"track":{"google":{"appId":"","meta":{}},"mixpanel":{"appId":"","meta":{}}},"api":{},"user":{"id":"","name":"","email":"","scope":"","role":"","geo":{"lat":0,"lng":0},"date":{"now":0,"zone":{}}},"social":{"facebook":{"appId":null,"onload":null,"var":["FB"],"doInit":true,"srcUri":[],"srcParams":[]},"twitter":{"appId":null,"onload":null,"var":["twttr"],"doInit":true,"srcUri":[],"srcParams":[]},"googleplus":{"appId":null,"onload":null,"var":["gapi"],"doInit":true,"srcUri":[],"srcParams":[]},"pinterest":{"appId":null,"onload":null,"var":["gapi"],"doInit":true,"srcUri":[],"srcParams":[]}}};		
		
	}
	
	YWC.f.loadYwcRemotelyCallback = function(){ console.log('YWC: loadYwcRemotely -> complete'); };
	
	YWC.f.loadYwcRemotely = function(){
		if (typeof YWC.f.coreLoadFileChainAsync != 'undefined') {
			YWC.f.coreLoadFileChainAsync("ywc-load",[
			
				{'type':'script','id':'ywc-core-css','init':[],'uri':
					YWC.uri.pre+'ywc/css-as-jsonp/ywc-core'}
				,{'type':'script','id':'ywc-utils','init':[],'uri':
					YWC.uri.pre+'lib/ywc/1.0/js/ywc-utils.js'}
						
				,{'type':'script','id':'ywc-popup','init':[],'uri':
					YWC.uri.pre+'lib/ywc/1.0/js/ywc-popup.js'}
				,{'type':'script','id':'ywc-popup-css','init':[],'uri':
					YWC.uri.pre+'ywc/css-as-jsonp/ywc-popup'}
				
				,{'type':'script','id':'ywc-asset','init':[],'uri':
					YWC.uri.pre+'lib/ywc/1.0/js/ywc-asset.js'}
				,{'type':'script','id':'ywc-asset-css','init':[],'uri':
					YWC.uri.pre+'ywc/css-as-jsonp/ywc-asset'}
				
				,{'type':'script','id':'ywc-maps','init':[],'uri':
					YWC.uri.pre+'lib/ywc/1.0/js/ywc-map.js'}
				
				,{'type':'script','id':'enthuse-core-css','init':[],'uri':
					YWC.uri.pre+'ywc/css-as-jsonp/enthuse-core'}
					
				,{'type':'script','id':'enthuse-core','init':[],'uri':
					YWC.uri.pre+'lib/enthuse/2.0/js/enthuse-core.js'}

				,{'type':'script','id':'enthuse-home-css','init':[],'uri':
					YWC.uri.pre+'ywc/css-as-jsonp/enthuse-home'}

				,{'type':'script','id':'enthuse-home','init':[],'uri':
					YWC.uri.pre+'lib/enthuse/2.0/js/enthuse-home.js'}


				,{'type':'script','id':'enthuse-widget','init':[],'uri':
					YWC.uri.pre+'lib/enthuse/2.0/js/enthuse-widget.js?noCache='+Math.random()}				
				
				,{'type':'script','id':'enthuse-widget-css','init':['enthuseWidgetHtml'],'uri':
					YWC.uri.pre+'ywc/css-as-jsonp/enthuse-widget?noCache='+Math.random()}
					
//				,{'type':'script','id':'enthuse-widget-vamshi','init':[],'uri':
//					YWC.uri.pre+'lib/enthuse/2.0/widget/enthuse-widget-loadscript.js'}

				,{'type':'script','id':'enthuse-widget-tabs','init':['enthuseWidgetHtml'],'uri':
					YWC.uri.pre+'widget/tabs'}

//				,{'type':'script','id':'enthuse-widget-models','init':[],'uri':
//					YWC.uri.pre+'widget/models'}
				
				],"YWC.f.loadYwcRemotelyCallback();"
			);			
		} else {
			var loadYwcRemotelyLoop = setTimeout("YWC.f.loadYwcRemotely();",50);
		}
	}

	var s = document.createElement("script");
	s.type = "text/javascript"; s.async = true; s.id = "script-ywc-core";
	s.src = YWC.uri.pre+"lib/ywc/1.0/js/ywc-core.js";
	s.onload = setTimeout("YWC.f.loadYwcRemotely();",10);
	s.onreadystatechange = function() { setTimeout("YWC.f.loadYwcRemotely();",10); }
	var x = document.getElementsByTagName("head")[0]; x.appendChild(s);
	
})();



