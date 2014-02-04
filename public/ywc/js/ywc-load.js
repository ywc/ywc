
(function(){

	if (typeof window.YWC == 'undefined') {		
		window.YWC = {"uri":{"pre":"//widget.enthu.se/","abs":window.location},"popup":{},"f":{},"ui":{},"store":{},"list":{"data":{},"meta":{},"list":{}},"detail":{"data":{},"meta":{}},"input":{"value":{"text":{},"select":{},"checkbox":{},"file":{},"datetime":{},"hidden":{},"custom":{}},"meta":{"jsBlock":{},"validation":{"required":{},"type":{}},"dateTime":[{"format":{}}],"lastValue":{"text":{},"select":{},"checkbox":{},"file":{},"datetime":{},"hidden":{}}}},"track":{"google":{"appId":"","domain":"","meta":{}}},"api":{},"user":{"id":"","name":"","email":"","scope":"","role":"","geo":{"lat":0,"lng":0},"date":{"now":0,"zone":{}}}};		
		
	}
	
	YWC.f.loadYwcRemotelyCallback = function(){ console.log('YWC: loadYwcRemotely -> complete'); };
	
	YWC.f.loadYwcRemotely = function(){
		if (typeof YWC.f.coreLoadFileChainAsync != 'undefined') {
			YWC.f.coreLoadFileChainAsync("ywc-load",[
			
				{'type':'script','id':'ywc-core-css','init':[],'uri':
					YWC.uri.pre+'ywc/css-as-jsonp/ywc-core'}
				,{'type':'script','id':'ywc-utils','init':[],'uri':
					YWC.uri.cdn+'ywc/js/ywc-utils.js'}
						
				,{'type':'script','id':'ywc-popup','init':[],'uri':
					YWC.uri.cdn+'ywc/js/ywc-popup.js'}
				,{'type':'script','id':'ywc-popup-css','init':[],'uri':
					YWC.uri.pre+'ywc/css-as-jsonp/ywc-popup'}
				
				,{'type':'script','id':'ywc-asset','init':[],'uri':
					YWC.uri.cdn+'ywc/js/ywc-asset.js'}
				,{'type':'script','id':'ywc-asset-css','init':[],'uri':
					YWC.uri.pre+'ywc/css-as-jsonp/ywc-asset'}
				
				],"YWC.f.loadYwcRemotelyCallback();"
			);			
		} else {
			var loadYwcRemotelyLoop = setTimeout("YWC.f.loadYwcRemotely();",50);
		}
	}

	var s = document.createElement("script");
	s.type = "text/javascript"; s.async = true; s.id = "script-ywc-core";
	s.src = YWC.uri.cdn+"ywc/js/ywc-core.js";
	s.onload = setTimeout("YWC.f.loadYwcRemotely();",10);
	s.onreadystatechange = function() { setTimeout("YWC.f.loadYwcRemotely();",10); }
	var x = document.getElementsByTagName("head")[0]; x.appendChild(s);
	
})();



