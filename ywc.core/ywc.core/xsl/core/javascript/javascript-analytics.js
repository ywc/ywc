var _gaq = _gaq || [];
if ((YWC.track.google != null) && (YWC.track.google.appId != "")) {
  _gaq.push(["_setAccount", YWC.track.google.appId]);
  _gaq.push(["_trackPageview"]);
  (function() { var ga = document.createElement("script"); ga.type = "text/javascript"; ga.async = true; ga.src = ("https:" == document.location.protocol ? "https://ssl" : "http://www") + ".google-analytics.com/ga.js"; var s = document.getElementsByTagName("script")[0]; s.parentNode.insertBefore(ga, s); })();
}
YWC.f.trackEvent = function(inp) {
  inp.fields=["category","action","label","value"];
  for (var i = 0; i < inp.fields.length; i++){if((typeof inp[inp.fields[i]]!=="string")&&(typeof inp[inp.fields[i]]!=="number")){inp[inp.fields[i]]=null;}}
  if ((YWC.track.google!=null)&&(YWC.track.google.appId!="")){ _gaq.push("_trackEvent", inp.category, inp.action, inp.label, inp.value); }
  console.log("YWC: trackEvent -> "+inp.category+", "+inp.action+", "+inp.label+", "+inp.value);
}