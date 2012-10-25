/**
* YWC Utilities Plugin
*/
// Check for YWC function namespace
if (typeof window.YWC.f != "object") { window.YWC.f = {}; }

/**
* Escapes quotations marks in a string
* @param {string} s The string to be analyzed
* @returns {string} The escaped string
* @public
*/
YWC.f.strEscQuot = function(s) {
	if (typeof s === "string") {
		return s.replace(/"/g, "\\\"");
	} else {
		throw new Error("YWC: strEscQuot -> input not string. returning empty string.");
		return "";
	}
}

/**
* Escapes apostrophes in a string
* @param {string} s The string to be analyzed
* @returns {string} The escaped string
* @public
*/
YWC.f.strEscApos = function(s) {
	if (typeof s === "string") {
		return s.replace(/'/g, "\\'");
	} else {
		throw new Error("YWC: strEscApos -> input not string. returning empty string.");
		return "";
	}
}

/**
* Escapes ampersands in a string
* @param {string} s The string to be analyzed
* @returns {string} The escaped string
* @public
*/
YWC.f.strEscAmp = function(s) {
	if (typeof s === "string") {
		return s.replace(/&/g, "&amp;");
	} else {
		throw new Error("YWC: strEscAmp -> input not string. returning empty string.");
		return "";
	}
}

/**
* Removes whitespace on either end of a string
* @param {string} s The string to be analyzed
* @returns {string} The trimmed string
* @public
*/
YWC.f.strTrim = function(s){
	if (typeof s === "string") {
		if (typeof $ !== "undefined") {
			return $.trim(s);
		} else {
			return s.replace(/^\s\s*/, "").replace(/\s\s*$/, "");
		}
	} else { 
		throw new Error("YWC: strTrim -> input not string. returning empty string.");
		return "";
	}
}

/**
* Reverses the letters of a string
* @param {string} s The string to be reversed
* @returns {string} The reversed string
* @public
*/
YWC.f.strRev = function(s) {
	var s_ = "";
	var i = s.length;
	while (i > 0) {
		s_ += s.substring(i-1,i);
		i--;
	}
	return s_;
}

/**
* Returns a shortened version of a string, if the string exceeds a certain length
* @param {string} str The string to be analyzed
* @param {int} len The maximum allowable length of the string
* @returns {string} The shortened string
* @public
*/
YWC.f.strLimitLength = function(str,len) {
	if (str.length > len) {
		return str.substr(0,len-2) + "...";
	} else {
		return str;
	}
}

/**
* Checks a string to determine if it is a valid email address
* @param {string} str The string to be analyzed
* @returns {boolean} Whether or not the string could be an email address
* @public
*/
YWC.f.strEmailValidate = function(str) {
	var rgx = new RegExp(/^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i);
	return rgx.test(str);
}

/**
* Uppercase the first character of each word in a string
* @param {string} s The string to be analyzed
* @returns {string} The string with the first character of each word capitalized, if that character is alphabetic
* @public
*/
YWC.f.strUpperCaseWords = function(s){
	return (s+'').replace(/^([a-z])|\s+([a-z])/g,
		function($1) {
			return $1.toUpperCase();
		}
	);
}

/**
* Analyze input string and format hyperlinks or Twitter links, if found
* @param {string} str The string to be analyzed
* @param {boolean} alsoFormatTwitter Whether or not to also format Twitter # and @ links
* @returns {string} String with links formatted as HTML hyperlinks
* @public
*/
YWC.f.strFormatLinks = function(str,alsoFormatTwitter){
	var breakLoop = false;
	var outStr = "";
	if ((str != null) && (str != "")) {
		str = ' '+str;
		for (var i = 0; (!breakLoop && (i < 10)); i++) {
			if ((str.indexOf('http://') > -1) || (str.indexOf('https://') > -1)) {
				var ind = str.indexOf('http://');
				if (ind == -1) { ind = str.indexOf('https://'); }
				if (ind == -1) { ind = str.indexOf('ftp://'); }
				var len = str.substr(ind,str.substr(ind).indexOf(' ')).length;
				if (str.substr(ind).indexOf(' ') == -1) {
					len = str.substr(ind).length;
				}
				outStr += str.substr(0,ind)
					+'<a href="'+str.substr(ind,len)+'" target="_blank">'
					+str.substr(ind,len)+'</a>';
				str = str.substr(ind+len);
			} else {
				outStr += str.substr(0);
				breakLoop = true;
			}
		}
		
		if ((alsoFormatTwitter != null) && alsoFormatTwitter) {
			breakLoop = false;
			str = " "+outStr;
			outStr = "";
			for (var i = 0; (!breakLoop && (i < 10)); i++) {
				var inds = [str.indexOf(' #'),str.indexOf(' @')];
				if ((inds[0] > -1)||(inds[1] > -1)) {
					var ind = inds[0]; var preUri = 'search/';
					if ((inds[0] < 0)||((inds[1] > -1) && (inds[1] < inds[0]))) {
						ind = inds[1]; preUri = '';
					}
					var len = str.substr(ind+1,str.substr(ind+1).indexOf(' ')).length;
					if (str.substr(ind+1).indexOf(' ') == -1) {
						len = str.substr(ind+1).length;
					}
					outStr += str.substr(0,ind)+' '
						+'<a href="http://twitter.com/#!/'+preUri+encodeURIComponent(str.substr(ind+1,len))+'" target="_blank">'
						+str.substr(ind+1,len)+'</a>';
					str = str.substr(ind+1+len);
				} else {
					outStr += str.substr(0);
					breakLoop = true;
				}
			}
		}
	}
	return outStr;
}

/**
* Return the number of indices at the first level of an object
* @param {object} obj The obj to be analyzed
* @returns {int} The number of indices
* @public
*/
YWC.f.objLength = function(obj) {
	var size = 0, key;
	for (key in obj) {
		if (obj.hasOwnProperty(key)) {
			size++;
		}
	}
	return size;
}

/**
* Filter the contents of an array, removing duplicate values
* @param {array} inputArr The array to be analyzed
* @returns {array} The filtered array, or the original array if required library jQuery is not present
* @public
*/
YWC.f.arrSelectDistinct = function(inputArr) {
	if (typeof $ !== "undefined") {
		var uniques = [];
    	for (var i=inputArr.length; i--;) {
        	var val = $.trim(inputArr[i]);
        	if ($.inArray( val, uniques ) === -1) {
				uniques.unshift(val);
			}
    	}
		return uniques;
	} else {
		throw new Error("YWC: arrSelectDistinct -> jQuery not found");
		return inputArr;
	}
}

/**
* Converts a length of time (in milliseconds) into a human readable time duration
* @param {int} ms The length of time, in milliseconds
* @returns {string} The formatted human readable time duration
* @public
*/
YWC.f.strTimePeriod = function(ms){
	
	if (typeof ms === 'string') {
		ms = parseInt(ms.replace(/ /g,'').replace(/,/g,''));
	}
	
	var mins = (ms/60000);
	var hours = (mins/60);
	var days = (hours/24);
	var weeks = (days/7);
	var months = (days/30);
	
	mins = Math.round(mins);
	hours = Math.round(hours);
	days = Math.round(days);
	weeks = Math.round(weeks);
	months = Math.round(months);
	
	var out = "";
	if (months >= 1) { out = months+" month"; if (months > 1) { out += "s"; } }
	else if (weeks >= 1) { out = weeks+" week"; if (weeks > 1) { out += "s"; } }
	else if (days >= 1) { out = days+" day"; if (days > 1) { out += "s"; } }
	else if (hours >= 1) { out = hours+" hour"; if (hours > 1) { out += "s"; } }
	else if (mins >= 0) { out = mins+" minute"; if (mins > 1) { out += "s"; } }
	else { out = "Less than a minute"; }
	
	return out;
}

/**
* Converts a human readable time value (12:15 pm, for example) into a length of time since midnight, in milliseconds
* @param {string} timeStr The human readable time value (12:15 pm, for example)
* @returns {int} The length of time elapsed between midnight, and the given time, in milliseconds
* @public
*/
YWC.f.strTimeToMilliSeconds = function(timeStr) {
	var arr = timeStr.split(':');
	var hr = parseInt(arr[0]);
	if ((arr[0].length>1)&&(arr[0].substring(0,1)=="0")) { hr = parseInt(arr[0].substring(1,2)); }
	
	var mn = parseInt(arr[1].substring(0,2));
	if (arr[1].substring(0,1)=="0") { mn = parseInt(arr[1].substring(1,2)); }
	
	if (arr[1].indexOf(' ') > -1) {
		var AmPm = arr[1].substr(1+arr[1].indexOf(' ')).toLowerCase();
		if ((AmPm=="am")&&(hr==12)) { hr = 0; }
		else if ((AmPm=="pm")&&(hr!=12)) { hr = hr+12; }
	}
	return (hr*3600+mn*60)*1000;
}


/**
* Converts (hopefully) any input time value into a number of possible standard timestamp formats
* @param {?} inputDateTime The provided timestamp, in virtually any format
* @param {object} wh Options specifying the desired output format
* @returns {?} The converted timestamp in a variety of possible formats
* @public
*/
YWC.f.dateConvert = function(inputDateTime,wh) {
	
	var timeStamp = 0;
	if (wh.debug === true) { console.log('YWC: dateConvert -> input: '+inputDateTime); }
	if (String(inputDateTime).length >= 14) {
		inputDateTime = String(inputDateTime);
		if (inputDateTime.lastIndexOf('E') > -1) {
			timeStamp = parseInt(parseFloat(inputDateTime.substr(0,inputDateTime.length-3))
							*Math.pow(10,parseInt(inputDateTime.substr(inputDateTime.lastIndexOf('E')+1))));
		} else {
			timeStamp = Date.parse(inputDateTime);
		}
	} else {
		timeStamp = parseInt(inputDateTime);
		if (timeStamp < 10000000000) { timeStamp = timeStamp*1000; }
	}
	
	if (isNaN(timeStamp)) {
		// if string conversion fails (Safari + IE), then manually set year+month+day+hour+minute+second
		timeStamp = (new Date(
			parseInt(inputDateTime.substr(0,4)),parseInt(inputDateTime.substr(5,2),10)-1
			,parseInt(inputDateTime.substr(8,2),10),parseInt(inputDateTime.substr(11,2),10)
			,parseInt(inputDateTime.substr(14,2),10),parseInt(inputDateTime.substr(17,2),10)
		)).valueOf();
		if (YWC.user.date.zone.offset == null) { YWC.f.coreSetDateTime(); }
		timeStamp = timeStamp-YWC.user.date.zone.offset;
		if (wh.debug === true) { console.log('YWC: initial conversion error -> '+inputDateTime+' -> '+timeStamp); }
	}
	
	var obj = new Date();
	
	if (typeof wh.resolutionInSeconds == 'undefined') { wh.resolutionInSeconds = 1; }
	var roundTo = parseInt(wh.resolutionInSeconds)*1000;
	obj.setTime(Math.round(timeStamp/roundTo)*roundTo);
	
	if (wh != null) {
		if (wh.type === 'object') {
			return obj;
		} else if (wh.type === 'ms') {
			return obj.valueOf();
		} else if (wh.type === 'sql') {
			var str = obj.getUTCFullYear()+'-';
			var mnth = obj.getUTCMonth(); if (mnth < 9) { str += '0'; } str += (1+mnth)+'-';
			var date = obj.getUTCDate(); if (date < 10) { str += '0'; } str += (0+date);
			str += ' ';
			var hrs = obj.getUTCHours(); if (hrs < 10) { str += '0'; } str += hrs+':';
			var mins = obj.getUTCMinutes(); if (mins < 10) { str += '0'; } str += mins+':';
			var secs = obj.getUTCSeconds(); if (secs < 10) { str += '0'; } str += secs;
			var zone = 0; /*obj.getTimezoneOffset();*/ if (zone > 0) { str += ' -'; } else { str += ' +'; }
			str += "0000"; //Math.abs(Math.round(zone/60)*1000).toPrecision(4);
			return str;
		} else if (wh.type === 'xml') {
			var str = obj.getUTCFullYear()+'-';
			var mnth = obj.getUTCMonth(); if (mnth < 9) { str += '0'; } str += (1+mnth)+'-';
			var date = obj.getUTCDate(); if (date < 10) { str += '0'; } str += (0+date);
			str += 'T';
			var hrs = obj.getUTCHours(); if (hrs < 10) { str += '0'; } str += hrs+':';
			var mins = obj.getUTCMinutes(); if (mins < 10) { str += '0'; } str += mins+':';
			var secs = obj.getUTCSeconds(); if (secs < 10) { str += '0'; } str += secs;
//			var zone = 0; /*obj.getTimezoneOffset();*/ if (zone > 0) { str += ' -'; } else { str += ' +'; }
//			str += "0000"; //Math.abs(Math.round(zone/60)*1000).toPrecision(4);
			str += "Z";
			return str;			
		} else {
			var rtrn = "";
			
			// just use Javascript to produce default date string
			if (wh.format === "local") {
				if (wh.type.indexOf('date') > -1) {
					rtrn += obj.toLocaleDateString();
				} else {
					rtrn += ' time...';
				}
				
			// use custom date output format	
			} else {
				wh.format = ' '+wh.format;
				rtrn = wh.format;
				
				var monthName = ['january','febuary','march','april','may','june','july','august','september','october','november','december'];
				var dayName = ['sunday','monday','tuesday','wednesday','thursday','friday','saturday'];
			
				// search and replace terms as defined here: http://php.net/manual/en/function.date.php (though not fully implemented)
				
				if (wh.format.indexOf('d') > -1) { var dt = obj.getDate(); if (dt < 10) { dt = "0"+dt; } rtrn = rtrn.replace(/d/,dt); }
				if (wh.format.indexOf('m') > -1) { var mn = (obj.getMonth()+1); if (mn < 10) { mn = "0"+mn; } rtrn = rtrn.replace(/m/,mn); }
				if (wh.format.indexOf('Y') > -1) { rtrn = rtrn.replace(/Y/,obj.getFullYear()); }
				if (wh.format.indexOf('y') > -1) { rtrn = rtrn.replace(/y/,(''+obj.getFullYear()).substr(2)); }
				if (wh.format.indexOf('G') > -1) { var hr = obj.getHours(); rtrn = rtrn.replace(/G/,hr); }
				if (wh.format.indexOf('g') > -1) { var hr = obj.getHours();
					if (hr > 12) { hr = (hr-12); } if (hr == 0) { hr = 12; } rtrn = rtrn.replace(/g/,hr);
				}
				if (wh.format.indexOf('H') > -1) { var hr = obj.getHours(); rtrn = rtrn.replace(/g/,hr); }
				if (wh.format.indexOf('i') > -1) { var mn = obj.getMinutes(); if (mn < 10) { mn = "0"+mn; } rtrn = rtrn.replace(/i/,mn); }
				if (wh.format.indexOf('s') > -1) { var sc = obj.getSeconds(); if (sc < 10) { sc = "0"+sc; } rtrn = rtrn.replace(/s/,sc); }
				if ((wh.format.indexOf(' A') > -1) || (wh.format.indexOf(' a') > -1)) { var hr = obj.getHours();
					var ampm = " PM"; if (hr < 12) { ampm = " AM"; }
					rtrn = rtrn.replace(/ A/,' '+ampm); rtrn = rtrn.replace(/ a/,' '+ampm.toLowerCase());
				}
				if (wh.format.indexOf(' l') > -1) { rtrn = rtrn.replace(/ l/,' '+dayName[obj.getDay()]); }
				if (wh.format.indexOf(' D') > -1) { rtrn = rtrn.replace(/ D/,' '+dayName[obj.getDay()].substr(0,3)); }
				if (wh.format.indexOf(' F') > -1) { rtrn = rtrn.replace(/ F/,' '+monthName[obj.getMonth()]); }
				if (wh.format.indexOf(' M') > -1) { rtrn = rtrn.replace(/ M/,' '+monthName[obj.getMonth()].substr(0,3)); }
				if (wh.format.indexOf(' e') > -1) { // set environment time zone
					if (YWC.user.date.zone.name == null) { YWC.f.coreSetDateTime(); }
					rtrn = rtrn.replace(/ e/,' '+YWC.user.date.zone.name);
				}
				
				rtrn = YWC.f.strUpperCaseWords(rtrn).replace(/ Am/,' am').replace(/ Pm/,' pm');
				
			}
		}
		
		return rtrn;	
	} else {
		return "could not convert date/time";
	}
}


