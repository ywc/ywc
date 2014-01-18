/**
* YWC Maps Plugin
*/
// Check for YWC function namespace
if (typeof window.YWC.f != "object") { window.YWC.f = {}; }

// Check for YWC map namespace
if (typeof window.YWC.map != "object") { window.YWC.map = {}; }

// Check for YWC map google namespace
if (typeof window.YWC.map.google != "object") { window.YWC.map.google = {}; }

YWC.f.mapResetObj = function(ind) {
	var ind = ''+ind;
	window.YWC.map.google[ind] = { 'obj':null,'targetDiv':null
		,'onLoad':null,'overlayObj':null,'boundsObj':null,'markers':{},'geocoderObj':null
		,'refmarker':null, 'searchRegion':'US', 'idle':false, 'dragIdle':true, 'onDrop':null
		,'visibleGroups':['all'], 'clusterObj': null
		,'focus':{ 'lat':-34.397, 'lng':150.644 }
		,'bounds':{ 'ne':{ 'lat':-34.397, 'lng':150.644 }, 'sw':{ 'lat':-34.397, 'lng':150.644 } }
		,'autoScaleToggle':false,'searchBoxToggle':false
		,'consoleBoxToggle':false,'markerClusterToggle':false
		,'mapType':'roadmap','z':15,'centerLat':-34.397,'centerLng':150.644
	};
};

YWC.f.mapSetUserGeo = function(iteration,forceUpdate) {
	if (iteration == null) { var iteration = 'html5'; }
	if (forceUpdate == null) { var forceUpdate = false; }
	if (forceUpdate || ((YWC.user.geo.lat == 0) && (YWC.user.geo.lng == 0))) {
		if (navigator.geolocation && (iteration === 'html5')) {
			navigator.geolocation.getCurrentPosition( function(position){
				YWC.user.geo.lat = position.coords.latitude;
				YWC.user.geo.lng = position.coords.longitude;
			},function(){
				YWC.f.mapSetUserGeo('ipinfodb');
			});
		} else if (iteration === 'ipinfodb') {
			$.ajax({dataType:"jsonp",url:YWC.api.ipinfodb.uri,data:{'format':'json','key':YWC.api.ipinfodb.key}
				,success: function(data){
					if ((data.statusCode === 'OK') && (data.latitude != null) && (data.longitude != null)) {
						YWC.user.geo.lat = parseFloat(data.latitude);
						YWC.user.geo.lng = parseFloat(data.longitude);
					} else {
						YWC.f.mapSetUserGeo('other_api');
					}
				}
			});
		} else {
			console.log('YWC: could not determine client geo-location.');
		}
	}
}


YWC.f.mapInit = function(mapId,mapParams,onLoad) {
	
	if (mapId == null) { for (i in YWC.map.google) { var mapId = i; break; } }
	
	YWC.f.mapSetParams(mapId,mapParams);
	if (onLoad != null) { YWC.map.google[mapId].onLoad = onLoad; }
	
	var themeUri = "public/vendor/jquery-ui/jquery-ui-themes/"+YWC.ui.jQueryUI.v+"/"+YWC.ui.jQueryUI.theme+"/jquery-ui.min.css";
	if (YWC.ui.jQueryUI.themeUri != "") { themeUri = YWC.ui.jQueryUI.themeUri; }
	
	for (i in YWC.map.google) { var firstMapId = i; break; }
	// check to see if other instances of mapInit are still initializing, and loop until they are completed
	if ((firstMapId != mapId) && (YWC.map.google[firstMapId].obj == null)) {
		var x = setTimeout("YWC.f.mapInit('"+mapId+"',{});",250);
	
	} else if ((typeof google == 'undefined') || (google == null) || (typeof google.maps == 'undefined')) {
		YWC.f.coreLoadFileAsync("script","google-maps"
			,"//maps.googleapis.com/maps/api/js?ywc_v=3.0&sensor=false&callback=YWC.f.mapInit","");
	} else if (YWC.f.coreLoadFileAsync("script","google-maps-richmarker"
			,YWC.uri.cdn+"public/vendor/google-maps/rich-marker/1.0/src/richmarker-compiled.js"
			,"YWC.f.mapInit('"+mapId+"',{})")){
			
	} else if (YWC.f.coreLoadFileAsync("script","google-maps-markerclusterer"
			,YWC.uri.cdn+"public/vendor/google-maps/marker-clusterer-plus/2.0.6/src/markerclusterer_packed.js"
			,"YWC.f.mapInit('"+mapId+"',{})")){

	} else if (YWC.f.coreLoadFileAsync("script","jquery-ui"
			,YWC.uri.cdn+"public/vendor/jquery-ui/jquery-ui/"+YWC.ui.jQueryUI.v+"/jquery-ui.min.js"
			,"YWC.f.mapInit('"+mapId+"',{})")){

	} else if (YWC.f.coreLoadFileAsync("link","jquery-ui"
			,YWC.uri.pre+themeUri
			,"YWC.f.mapInit('"+mapId+"',{})")){
				
	} else if (typeof MarkerClusterer != 'undefined') {
		var x = setTimeout("YWC.f.mapSet('"+mapId+"');",10);
	} else {
		var x = setTimeout("YWC.f.mapInit('"+mapId+"',{});",10);
	}
}

YWC.f.mapSetParams = function(mapId,mapParams) {
	
	if (YWC.map.google[mapId] == null) {
		YWC.f.mapResetObj(mapId);
	}
	for (paramInd in mapParams) {
//		if ((paramInd == 'centerLat') || (paramInd == 'centerLng')) {
//			mapParams[paramInd] = parseFloat(mapParams[paramInd]);
//		}
		YWC.map.google[mapId][paramInd] = mapParams[paramInd];
	}
}


YWC.f.mapSet = function(mapId) {
	if (mapId == null) { for (i in YWC.map.google) { var mapId = i; break; } }
		
	var gMapOptions = {
			mapTypeId: google.maps.MapTypeId[YWC.map.google[mapId].mapType.toUpperCase()]
			, zoom: parseInt(YWC.map.google[mapId].z)
			, center: new google.maps.LatLng(
				parseFloat(YWC.map.google[mapId].centerLat),parseFloat(YWC.map.google[mapId].centerLng))
			, disableDefaultUI:true
			, mapTypeControl:true
			, zoomControl:true
			, zoomControlOptions:{
				style:google.maps.ZoomControlStyle.DEFAULT
				,position:google.maps.ControlPosition.RIGHT_CENTER
			}
			,mapTypeControlOptions:{
				style:google.maps.MapTypeControlStyle.DROPDOWN_MENU
				,position:google.maps.ControlPosition.RIGHT_TOP
			}
		};
	
	$(YWC.map.google[mapId].targetDiv).each(function(){
		if ($(this).find("div.ywc-map-inner-container").length == 0) {
			$(this).addClass("ywc-map-container")
				.prepend("<div class=\"ywc-map-inner-container\"></div>")
				.each(function(){
					YWC.map.google[mapId].obj = new google.maps.Map(this,gMapOptions);
					YWC.map.google[mapId].overlayObj = new google.maps.OverlayView();
					YWC.map.google[mapId].overlayObj.draw = function(){};
					YWC.map.google[mapId].overlayObj.setMap(YWC.map.google[mapId].obj);
					google.maps.event.addListener(YWC.map.google[mapId].obj
						,"bounds_changed",function(){YWC.f.mapSetStats(mapId);});
					google.maps.event.addListener(YWC.map.google[mapId].obj
						,"tilesloaded",function(){YWC.f.mapSetStats(mapId);});
					google.maps.event.addListener(YWC.map.google[mapId].obj
						,"idle",function(){YWC.f.mapSetStats(mapId);YWC.map.google[mapId].idle=true;});
			});
		} else if (YWC.map.google[mapId].obj != null) {
			YWC.map.google[mapId].obj.setOptions(gMapOptions);
		}		
	});	
	
	// reset bounds
	if ((YWC.map.google[mapId].boundsObj == null) || (YWC.map.google[mapId].autoScaleToggle)) {
		YWC.map.google[mapId].boundsObj = new google.maps.LatLngBounds();
	}
	
	if (YWC.map.google[mapId].geocoderObj == null) {
		YWC.map.google[mapId].geocoderObj = new google.maps.Geocoder();
	}
	
	if (MarkerClusterer != null) {
		YWC.map.google[mapId].clusterObj = new MarkerClusterer(YWC.map.google[mapId].obj,[]);
	}
	
	if (YWC.map.google[mapId].searchBoxToggle) { YWC.f.mapDrawSearch(mapId); }
	if (YWC.map.google[mapId].consoleBoxToggle) { YWC.f.mapDrawConsole(mapId); }
	if (YWC.map.google[mapId].onDrop != null) { YWC.f.mapSetDroppable(mapId); }
	if (YWC.map.google[mapId].onLoad != null) { var c = setTimeout(YWC.map.google[mapId].onLoad,10); }

}

YWC.f.mapSetStats = function(mapId,setFocus) {
	
	var center = YWC.map.google[mapId].obj.getCenter();
	YWC.map.google[mapId].centerLat = center.lat().toFixed(8);
	YWC.map.google[mapId].centerLng = center.lng().toFixed(8);
	var bounds = YWC.map.google[mapId].obj.getBounds();
	YWC.map.google[mapId].bounds.ne.lat = bounds.getNorthEast().lat().toFixed(8);
	YWC.map.google[mapId].bounds.ne.lng = bounds.getNorthEast().lng().toFixed(8);
	YWC.map.google[mapId].bounds.sw.lat = bounds.getSouthWest().lat().toFixed(8);
	YWC.map.google[mapId].bounds.sw.lng = bounds.getSouthWest().lng().toFixed(8);
	YWC.map.google[mapId].z = YWC.map.google[mapId].obj.getZoom();
	YWC.map.google[mapId].idle = false;
	if (setFocus != null) {
		YWC.map.google[mapId].focus.lat = setFocus.lat().toFixed(8);
		YWC.map.google[mapId].focus.lng = setFocus.lng().toFixed(8);
		YWC.map.google[mapId].idle = true;
	}

	if (YWC.map.google[mapId].consoleBoxToggle) { 	
		$(YWC.map.google[mapId].targetDiv).find("div.console-text").html(	
			"Zoom: "+YWC.map.google[mapId].z+" -- "
			+"Center: "+YWC.map.google[mapId].centerLat+" , "+YWC.map.google[mapId].centerLng+" ; "
			+"<br />"
			+"SW: "+YWC.map.google[mapId].bounds.sw.lat+","+YWC.map.google[mapId].bounds.sw.lng
			+" -- "
			+"NE: "+YWC.map.google[mapId].bounds.ne.lat+","+YWC.map.google[mapId].bounds.ne.lng
		);
	}
}

YWC.f.mapGetMarkerById = function(id) {
	return document.getElementById('ywc-map-marker-'+id);
}

YWC.f.mapSetMarker = function(mapId,markerId,data) {
	
	if (YWC.map.google[mapId]['markers'] == null) {  YWC.map.google[mapId]['markers'] = {}; }
	
	if ((Math.round(parseFloat(data.latitude))!=0)||(Math.round(parseFloat(data.longitude))!=0)) {
	
		if (YWC.map.google[mapId]['markers'][markerId] == null) { YWC.map.google[mapId]['markers'][markerId] = {'obj':null}; }
		
		//get format array in order to check input data and set fallback defaults
		var markerFormat = YWC.f.mapInitMarker();
	
		// with that array, run the check
		for (i=0;i<markerFormat.name.length;i++) {
			
			if (markerFormat.format[i] == 'float') { var dataVal = parseFloat(data[markerFormat.name[i]]); }
			else if (markerFormat.format[i] == 'int') { var dataVal = parseInt(data[markerFormat.name[i]]); }
			else if (markerFormat.format[i] == 'string') { var dataVal = ''+data[markerFormat.name[i]]; }
			else { var dataVal = data[markerFormat.name[i]]; }
			
			if (data[markerFormat.name[i]] == null) {
				YWC.map.google[mapId]['markers'][markerId][markerFormat.name[i]] = markerFormat.fallback[i];
			} else if (dataVal != YWC.map.google[mapId]['markers'][markerId][markerFormat.name[i]]) {
				YWC.map.google[mapId]['markers'][markerId][markerFormat.name[i]] = dataVal;
			}
		}
	}
}

YWC.f.mapInitMarker = function() {
	var out = { 'name':[], 'format':[], 'fallback':[] };
	out.name.push('latitude'); out.format.push('float'); out.fallback.push(0);
	out.name.push('longitude'); out.format.push('float'); out.fallback.push(0);
	out.name.push('title'); out.format.push('string'); out.fallback.push('');
	out.name.push('group'); out.format.push('array'); out.fallback.push([]);
//	out.name.push('info'); out.format.push('string'); out.fallback.push('');
	out.name.push('flat'); out.format.push('boolean'); out.fallback.push(false);
	out.name.push('z'); out.format.push('int'); out.fallback.push(1);
	out.name.push('icon'); out.format.push('string'); out.fallback.push(null);
	out.name.push('iconSize'); out.format.push('int'); out.fallback.push(30);
	out.name.push('iconBorderWidth'); out.format.push('int'); out.fallback.push(1);
	out.name.push('iconBorderColor'); out.format.push('string'); out.fallback.push('#444444');
	out.name.push('visible'); out.format.push('boolean'); out.fallback.push(true);
	out.name.push('draggable'); out.format.push('boolean'); out.fallback.push(false);
	out.name.push('raiseOnDrag'); out.format.push('boolean'); out.fallback.push(false);
	out.name.push('applyAutoScale'); out.format.push('boolean'); out.fallback.push(true);
	out.name.push('applyCluster'); out.format.push('boolean'); out.fallback.push(true);
	out.name.push('showLabel'); out.format.push('boolean'); out.fallback.push(true);
	
	out.name.push('dragend'); out.format.push('function'); out.fallback.push(null);
	out.name.push('click'); out.format.push('function'); out.fallback.push(null);
	
	out.name.push('clickMenu'); out.format.push('object'); out.fallback.push(null);
	
	return out;
}

YWC.f.mapDrawMarker = function(mapId,markerId,toggle) {
	
	// shortcut to marker object
	var marker = YWC.map.google[mapId]['markers'][markerId];
	
	if 	(	(marker.latitude != null) && (parseInt(marker.latitude) > -90) && (parseInt(marker.latitude) < 90)
		&& 	(marker.longitude != null) && (parseInt(marker.longitude) > -360) && (parseInt(marker.longitude) < 360)
		) {
		
	// if not a uri for icon, create appropriate uri
	if ((marker.icon==null)||(marker.icon.indexOf('/')==-1)) {
		if (marker.icon==null) { marker.icon = "red"; }
		marker.icon = "//www.google.com/intl/en_us/mapfiles/ms/micons/"+marker.icon+".png";
		marker.flat = true;
		marker.raiseOnDrag = true;
		marker.iconBorderWidth = 0;
	}
	
	//shortcut to latlng
	var thisLatLng = new google.maps.LatLng(marker.latitude,marker.longitude);
	
	var markerLabel = '';
	if (marker.showLabel && (marker.title != '')) {
		markerLabel = '<div class="marker-label" style="'
			+'left:'+(marker.iconBorderWidth-Math.round(0.2*marker.iconSize))+'px;'
			+'width:'+Math.round(1.4*marker.iconSize)+'px;'
			+'top:'+(marker.iconSize+2+(2*marker.iconBorderWidth))+'px;'
			+'"'
		+'>'+YWC.f.strLimitLength(marker.title,25)+'</div>';
	}
	
	var hoverClass = '';
	if ((marker.click != null) || (marker.clickMenu != null)) {
		hoverClass = ' ywc-map-marker-hover'
	} else if (marker.draggable) {
		hoverClass = ' ywc-map-marker-draggable'
	}
	
	var thisHtml = '<div class="ywc-map-marker'+hoverClass+'" id="ywc-map-marker-'+markerId+'"'
					+' style="'
						+'width:'+marker.iconSize+'px;'
						+'height:'+marker.iconSize+'px;'
					+'">'
					+'<div class="marker-thmb" style="'	
						+'border:solid '+marker.iconBorderWidth+'px '+marker.iconBorderColor+';'
					+'"><img src="'+marker.icon+'" onLoad="YWC.f.uiSetSquImg(this,\'out\')" /></div>'
					+markerLabel
					+'</div>'
					;
					
	var mapOptions = { map: YWC.map.google[mapId].obj
						, draggable: marker.draggable, clickable: true, raiseOnDrag: marker.raiseOnDrag
						, visible: marker.visible, zIndex: marker.z, position: thisLatLng
						, title: marker.title, content: thisHtml, flat: marker.flat
					};
	
	if (marker.obj == null) {
		// if marker doesn't exist yet, create it
 		YWC.map.google[mapId]['markers'][markerId].obj = new RichMarker(mapOptions);
			//	new google.maps.Marker(mapOptions);
	} else if ((toggle==null)||(toggle)) {
		// if marker does exist, define new options
		YWC.map.google[mapId]['markers'][markerId].obj.setOptions(mapOptions);
	} else {
		// if toggle is off, remove marker from map
		mapOptions.map = null;
		YWC.map.google[mapId]['markers'][markerId].obj.setOptions(mapOptions);
		if (YWC.map.google[mapId].markerClusterToggle) {
			YWC.map.google[mapId].clusterObj.removeMarker(YWC.map.google[mapId].markers[markerId].obj);
		}
	}
	
	
	// clear listeners
	google.maps.event.clearInstanceListeners(YWC.map.google[mapId]['markers'][markerId].obj);
	
	if ((toggle==null)||(toggle)) {

		google.maps.event.addListener( YWC.map.google[mapId]['markers'][markerId].obj, 'drag', function(){
			YWC.map.google[mapId].dragIdle = false;
		} );
		
		google.maps.event.addListener( YWC.map.google[mapId]['markers'][markerId].obj, 'dragend', function(){
			YWC.map.google[mapId].markers[markerId].latitude = parseFloat(this.getPosition().lat().toFixed(8));
			YWC.map.google[mapId].markers[markerId].longitude = parseFloat(this.getPosition().lng().toFixed(8));
			YWC.exec.setQueue("YWC.map.google['"+mapId+"'].dragIdle=true;");
			if (marker.dragend != null) { YWC.exec.setQueue(marker.dragend); }
		} );
		
		if (marker.click != null) {
			google.maps.event.addListener( YWC.map.google[mapId]['markers'][markerId].obj, 'click', function(){
				if (YWC.map.google[mapId].dragIdle) { YWC.exec.setQueue(marker.click); }
			} );
		} else if (marker.clickMenu != null) {
			google.maps.event.addListener( YWC.map.google[mapId]['markers'][markerId].obj, 'click', function(){
				if (YWC.map.google[mapId].dragIdle) { YWC.exec.setQueue("YWC.f.mapDrawClickMenu('"+mapId+"','"+markerId+"',true);"); }
			} );
		}
		
		// add marker to autoscale calculation, if applicable
		if (YWC.map.google[mapId].autoScaleToggle && marker.applyAutoScale) {
			YWC.map.google[mapId]['boundsObj'].extend(thisLatLng);
		}
		
		// add marker to cluster calc
		if (YWC.map.google[mapId].markerClusterToggle && marker.applyCluster) {
			YWC.map.google[mapId].clusterObj.addMarker(YWC.map.google[mapId].markers[markerId].obj);
		}
	}
} else {
	console.log('YWC: Map point not drawn due to out-of-range coordinates: '+marker.latitude+', '+marker.longitude);
}
}

YWC.f.mapDrawAllMarkers = function(mapId) {
	
	for (i in YWC.map.google[mapId].markers) {
		YWC.f.mapDrawMarker(mapId,i,true);
	}
	
	if (	(YWC.map.google[mapId].autoScaleToggle)
		&&	(YWC.f.objLength(YWC.map.google[mapId]['markers'])>1)) {
		var performAutoScale = 0;
		for (i in YWC.map.google[mapId].markers) {
			if (YWC.map.google[mapId].markers[i].applyAutoScale) { performAutoScale++; }
		}
		if (performAutoScale > 1) {
			YWC.map.google[mapId].obj.fitBounds(YWC.map.google[mapId]['boundsObj']);	
		}
	}
}


YWC.f.mapDrawSearch = function(mapId) {
	if (!document.getElementById("ywc-map-search-container-"+mapId)) {
		var mapCont = $(YWC.map.google[mapId].targetDiv);
		var mapWidth =  mapCont.width();
		mapCont.prepend("<div class=\"ywc-map-extra-container ywc-map-search-container\""
						+" id=\"ywc-map-search-container-"+mapId+"\""
						+" style=\"left:"+YWC.f.mapGetElementPosLeft(mapId,'search')+"px;\">"
						+"<img class=\"bttn\" onLoad=\"YWC.f.uiSetHoverImageToggle(this)\" alt=\"Search Map\""
							+" src=\""+YWC.uri.pre+"public/ywc-image/bttn/misc/search-01.png\""
							+" onClick=\"YWC.f.mapToggleElement('"+mapId+"','search')\" />"
						+"<img class=\"ywc-map-extra-close\" onLoad=\"YWC.f.uiSetHoverImageToggle(this)\" alt=\"Close Search\""
							+" src=\""+YWC.uri.pre+"img/special/popupx/box/eeeeee/9f9f9f.png\""
							+" onClick=\"YWC.f.mapToggleElement('"+mapId+"','search')\""
							+" style=\"left:"+(mapWidth-40)+"px;\" />"
						+"<div class=\"text\" style=\"width:"+Math.round(mapWidth/2)+"px;\"></div>"
						+"<label class=\"text\" style=\"left:"+(Math.round(mapWidth/2)+40)+"px;\">in:</label>"
						+"<div class=\"country\" style=\""
							+"left:"+(Math.round(mapWidth/2)+65)+"px;"
							+"width:"+Math.round(mapWidth/3)+"px;"
							+"\"></div>"						
					+"</div>");
	
		mapCont.find("div.text").load(YWC.uri.pre+'ywc/ui-input/text'
			,{	'id':'ywc-map-search-'+mapId,'placeholder':'Start typing a place name...'
				,'class':'ywc-map-search','fontSize':14,'eraseBttn':1,'eraseBttnJs':'','preUri':YWC.uri.pre
			},function(){
				YWC.f.mapSetSearch(mapId);
			});
		mapCont.find("div.country").load(YWC.uri.pre+'ywc/ui-input/text'
			,{	'id':'ywc-map-country-'+mapId,'placeholder':'Country Name...','value':'United States'
				,'class':'ywc-map-search','fontSize':14,'eraseBttn':1,'eraseBttnJs':'','preUri':YWC.uri.pre
			},function(){

			});
	}	
}

YWC.f.mapDrawConsole = function(mapId) {
	if (!document.getElementById("ywc-map-console-container-"+mapId)) {
		var mapCont = $(YWC.map.google[mapId].targetDiv);
		mapCont.prepend("<div class=\"ywc-map-extra-container ywc-map-console-container\""
						+" id=\"ywc-map-console-container-"+mapId+"\""
						+" style=\"left:"+YWC.f.mapGetElementPosLeft(mapId,'console')+"px;\">"
					+"<div class=\"console-text\""
						+" style=\"width:"+(mapCont.width()-90)+"px;\"></div>"
						+"<img class=\"bttn\" onLoad=\"YWC.f.uiSetHoverImageToggle(this)\" alt=\"\""
							+" src=\""+YWC.uri.pre+"public/ywc-image/bttn/misc/compass-01.png\""
							+" onClick=\"YWC.f.mapToggleElement('"+mapId+"','console')\" />"
						+"<img class=\"ywc-map-extra-close\" onLoad=\"YWC.f.uiSetHoverImageToggle(this)\" alt=\"Close Console\""
							+" src=\""+YWC.uri.pre+"img/special/popupx/box/eeeeee/9f9f9f.png\""
							+" onClick=\"YWC.f.mapToggleElement('"+mapId+"','console')\""
							+" style=\"left:"+(mapCont.width()-40)+"px;\" />"
					+"</div>");
	}
}

YWC.f.mapGetElementPosLeft = function(mapId,wh) {
	var rtrn = 0;
	if (wh == 'search') {
		return rtrn;
	} else {
		if (YWC.map.google[mapId].searchBoxToggle) { rtrn = rtrn+41; }
		if (wh == 'console') {
			return rtrn;
		} else {
		}
	}	
}

YWC.f.mapToggleElement = function(mapId,wh) {
	var mapExtraCont = $("div#ywc-map-"+wh+"-container-"+mapId);
	if (mapExtraCont.width() > 40) {
		mapExtraCont.animate({'width':'40px','left':YWC.f.mapGetElementPosLeft(mapId,wh)+'px'}
			,"fast",function(){ $(this).css({'z-index':2}) });
		if (wh == 'search') { YWC.f.inputTextClear("ywc-map-search-"+mapId,true,false); }
	} else {
		mapExtraCont.css({'z-index':3}).animate({
				'left':'0px'
				,'width':($(YWC.map.google[mapId].targetDiv).width()-2)+'px'
			},"fast",function(){
				if (wh == 'search') { 
					$("input#ywc-input-text-ywc-map-search-"+mapId).focus();
				}
		});
	}
}

YWC.f.mapSetSearch = function(mapId) {
	$("input#ywc-input-text-ywc-map-search-"+mapId).autocomplete({
		source: function(request, response) {
			YWC.map.google[mapId].geocoderObj.geocode( { 'address': request.term
						, 'region':YWC.map.google[mapId].searchRegion 
				}, function(results, status) {
				response($.map(results, function(item) {
				return { label:item.formatted_address
						, value:item.formatted_address
						, latitude:item.geometry.location.lat()
						, longitude:item.geometry.location.lng()
					}
				}));
			});
		}
		,select: function(event, ui) {
			var location = new google.maps.LatLng(ui.item.latitude, ui.item.longitude);
			if (YWC.map.google[mapId].refmarker != null) { YWC.map.google[mapId].refmarker.setOptions({ map: null }); }
			YWC.map.google[mapId].refmarker = new google.maps.Circle({
					strokeColor:"#222222",fillColor:"#222222",strokeOpacity:0.5,strokeWeight:2,fillOpacity:0.1
					,map: YWC.map.google[mapId].obj, radius: 200, clickable: false, zIndex: 0
					,center: location
				});
			YWC.map.google[mapId].obj.panTo(location);
		}
	});
}



YWC.f.mapDrawClickMenu = function(mapId,markerId,toggle) {
	if (toggle) {
		var markerObj = YWC.map.google[mapId]['markers'][markerId];
		var markerPos = YWC.map.google[mapId].overlayObj.getProjection().fromLatLngToContainerPixel(
				markerObj.obj.getPosition());
		var pos = [Math.round(markerPos.x),Math.round(markerPos.y)];
		
		var clickMenu = '';
		if (markerObj.clickMenu != null) {
			clickMenu = '<div class="ywc-crnr-5 marker-click-menu" id="marker-click-menu-'+markerId+'"'
					+' style="'
						+'left:'+(pos[0]+markerObj.iconSize*0.6)+'px;'
						+'top:'+(pos[1]-markerObj.iconSize*1.1)+'px;'
						+'">';
			for (c in markerObj.clickMenu) {
				clickMenu += '<div class="marker-click-menu-item"'
							+' onClick="YWC.f.mapDrawClickMenu(\''+mapId+'\',\''+markerId+'\',false);'
								+markerObj.clickMenu[c].replace(/"/g,'\\"')
							+'">'+c+'</div>';
			}		
			clickMenu += '</div>'
				+'<div class="marker-click-menu-bg ywc-crnr-5" onClick="YWC.f.mapDrawClickMenu(\''+mapId+'\',\'\',false)"></div>';
		}
		$(YWC.map.google[mapId].targetDiv).prepend(clickMenu);
	} else {
		$(YWC.map.google[mapId].targetDiv).find("div.marker-click-menu, div.marker-click-menu-bg").remove();
	}
}


YWC.f.mapSetDroppable = function(mapId) {
	if (typeof YWC.map.google[mapId] != 'undefined') {
		$(YWC.map.google[mapId].targetDiv).droppable({drop:function(event,ui){
			var containerPos = $(this).offset();
			var latLngObj = YWC.map.google[mapId].overlayObj.getProjection().fromContainerPixelToLatLng(
				new google.maps.Point(
					ui.offset.left-containerPos.left+Math.round(ui.draggable.width()/2)
					,ui.offset.top-containerPos.top+Math.round(ui.draggable.height()/2)
				));
			// sets mapObj.focus to dropped latLng...
			YWC.f.mapSetStats(mapId,latLngObj);
			// ... then executes onDrop function, if it exists
			if (YWC.map.google[mapId].onDrop != null) { var c = setTimeout(YWC.map.google[mapId].onDrop,10); }
		}});
	}
}
