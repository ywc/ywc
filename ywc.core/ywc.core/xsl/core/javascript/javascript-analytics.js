﻿
if ((YWC.track.google != null) && (YWC.track.google.appId != "") && (YWC.track.google.domain != "")) { (function(i,s,o,g,r,a,m){i["GoogleAnalyticsObject"]=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,"script","//www.google-analytics.com/analytics.js","ga"); ga("create",YWC.track.google.appId,YWC.track.google.domain); ga("send","pageview"); }

YWC.f.trackEvent = function(inp) {
  inp.fields=["category","action","label","value"];
  for (var i = 0; i < inp.fields.length; i++){if((typeof inp[inp.fields[i]]!=="string")&&(typeof inp[inp.fields[i]]!=="number")){inp[inp.fields[i]]=null;}}
  if ((YWC.track.google!=null)&&(YWC.track.google.appId!="")&&(YWC.track.google.domain!="")){ ga("send", "event", inp.category, inp.action, inp.label, inp.value); }
  console.log("YWC: trackEvent -> "+inp.category+", "+inp.action+", "+inp.label+", "+inp.value);
}