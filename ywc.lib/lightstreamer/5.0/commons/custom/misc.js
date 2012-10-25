/*
 * This file collects some code that is shared among the provided demo applications.
 *
 * This code lies at an intermediate level between the library code and the application-
 * specific code. Feel free both to reuse it for your own applications or to bypass it.
 * For example, you may remove the optional snippets, customize any part, and move this
 * code directly into your Push-Page.
 * 
 * In a nutshell, this code defines a couple of functions used by the Push-Page to
 * create the actual PushPage and LightstreamerEngine objects. At the same time, a
 * handy visual indicator of the connection status is implemented. Finally, if the
 * application-specific code needs to define some callbacks (onEngineReady or
 * onEngineLost for PushPage; onStatusChange for LightstreamerEngine), the custom
 * code is added to the implementations of such callbacks done for the status indicator.
 */


//////////////// Master Push-Page Creation and Configuration

// Create the PushPage object and configure it by defining some callbacks.

function initializeDemoPushPage(miscPath, showStatus, onEngineReady, onEngineLost) {
  var pushPage = new PushPage();

  pushPage.context.setDebugAlertsOnClientError(true); // (set false in PRODUCTION)
 pushPage.context.setDomain('enthu.se'); // (set the domain when deploying on WEB SERVER)

  // define the OPTIONAL callbacks needed to display the connection status
  // and to implement some application-specific logic
  // (the attachCallbacksAndStatusManager function is defined at the end of this file)
  attachCallbacksAndStatusManager(pushPage, miscPath, showStatus, onEngineReady, onEngineLost);

  // the PushPage object is now configured and ready to be processed by the framework
  pushPage.bind();

  //////////////// (OPTIONAL) Block Escape Key
  // This optional code snippet blocks the pressure of the Escape key,
  // to prevent the stream connection from being interrupted.

  document.onkeydown = checkEscape;
  document.onkeypress = checkEscape;
  function checkEscape(e) {
    if (!e) e = event;
    if (e.keyCode == 27) return false;
  }

  return pushPage;
}


// Seek or create the Lightstreamer Engine and define some callbacks.

function initializeDemoEngine(pushPage, lsLibPath, onStatusChange, existingMasterRef) {
  pushPage.onStatusChangeLocal = onStatusChange;

  // if the page that includes this script does not define a reference to an
  // already existing Master Push-Page, let's define the callback needed to create
  // the Engine (but used only if this page is actually the first Master Push-Page;
  // see createEngine below)
  if (existingMasterRef == null) {
    pushPage.onEngineCreation = function(lsEngine) {
      lsEngine.context.setDebugAlertsOnClientError(true); // (set false in PRODUCTION)
	  lsEngine.connection.setLSHost('ac-push.enthu.se'); // (set the hostname when deploying on WEB SERVER)
      lsEngine.connection.setLSPort(8080); // (set the port when deploying on WEB SERVER)
      lsEngine.connection.setAdapterName("ACRS"); // the name of the Adapter Set
      lsEngine.connection.setUserName("c9f2bfd0-6325-4dbf-af9d-efb79c6c8680"); // the name of the Adapter Set
      lsEngine.changeStatus("STREAMING"); // let's try with a streaming connection
    };
  }

  // if the page that includes this script does not define a reference to an
  // already existing Master Push-Page, let's use createEngine to see if a compatible
  // Master Push-Page can be found automatically (or, if it cannot, to create it);
  // otherwise let's use seekEngine with the provided reference to directly attach
  // to the Master Push-Page
  if (existingMasterRef == null) {
    // create the LightstreamerEngine, possibly sharing it with other applications
    // that are based on the "DEMO" Adapter Set; note that all Engine attributes
    // (and the onEngineCreation event handler code in particular) should be
    // identical for all the involved demos.
    // If a similar Engine already exists on another Master Push-Page, it will be
    // leveraged rather than creating a new one
    pushPage.createEngine("DemoCommonEngine", lsLibPath, "SHARE_SESSION", true);
  } else {
    // seek the LightstreamerEngine created by another Master Push-Page
    pushPage.seekEngine("DemoCommonEngine", existingMasterRef);
  }
}
//lsPage.seekEngine("MyApplication", self.parent.frames.PAGE_A);

//////////////// Callback definitions and (OPTIONAL) Visual Status Notification

// The optional part of this function (activated by the "showStatus" switch)
// implements a widget that displays the status of the connection. A transparent
// tab is attached to the upper-left window border, with the meanings below:
//   - Long tab: this is a Master Push-Page.
//   - Short tab this is a Push-Page.
//   - Grey light: waiting for the LightstreamerEngine object.
//   - Red light: disconnected from the Server (possibily trying to reconnect).
//   - Yellow light: the connection is stalled.
//   - Green light: connected to the Server. In this case, on the
//        Master Push-Page tab an icon shows if streaming (two arrows in the same
//        direction) or polling (two arrows in opposite directions) is being used.
// Some explanation text will appear when the mouse pointer is over the widget.
//
// The part of this function independent of the "showStatus" switch is used for
// defining some callback functions used by application-specific code. The callbacks
// are: onEngineReady and onEngineLost for the PushPage object; onStatusChange for
// the LightstreamerEngine object.

function attachCallbacksAndStatusManager(pushPage, miscPath, showStatus, onEngineReady, onEngineLost) {

  if (showStatus) {
    // folder containing the status images
    var statusImgDir = miscPath + "img/";

    // prefetch the images (especially useful for mobile devices)
    var prefetcher = new Array(9);
    for (i = 0; i <= 9; i++) {
      prefetcher[i] = new Image();
    }
    prefetcher[0].src = statusImgDir + "status_waiting.png";
    prefetcher[1].src = statusImgDir + "status_disconnected.png";
    prefetcher[2].src = statusImgDir + "status_disconnected_master.png";
    prefetcher[3].src = statusImgDir + "status_connected_streaming_master.png";
    prefetcher[4].src = statusImgDir + "status_connected_polling_master.png";
    prefetcher[5].src = statusImgDir + "status_connected_streaming.png";
    prefetcher[6].src = statusImgDir + "status_connected_polling.png";
    prefetcher[7].src = statusImgDir + "status_stalled.png";
    prefetcher[8].src = statusImgDir + "status_stalled_master.png";

    // prepare the HTML snippets to write to the page
    var imgHtml1 = "<div style='position: ";
    var imgHtml2 = "top: 0px; left: 0px; z-index: 99999;' onmouseover='document.getElementById(\"statusDiv\").style.visibility=\"visible\"' onmouseout='document.getElementById(\"statusDiv\").style.visibility=\"hidden\"'><img name='statusImg' src='" + statusImgDir + "status_waiting.png' /></div>";
    var textHtml1 = "<div id='statusDiv' style='position: ";
    var textHtml2 = "top: 10px; left: 20px; z-index: 99999; visibility: hidden; border: 1px solid #C0C0C0; padding: 3px; margin: 0px; font-family: Arial, Helvetica, sans-serif; font-size: 10px; color: #333333; background-color: #FFFFFF; filter:alpha(opacity=90); -moz-opacity:0.9; -khtml-opacity: 0.9; opacity: 0.9;'>Waiting for Push Engine creation...</div>";

    // create a container div element to host the other divs defined below
    var statusContainer = document.createElement("div");
    document.getElementsByTagName("body")[0].appendChild(statusContainer);
    // create the div elements to host the status image and text and
    // position them "absolute" or "fixed" based on the browser type
    // IE < 7
    statusContainer.innerHTML = "<!--[if lt IE 7]>" + imgHtml1 + "absolute; " + imgHtml2 + textHtml1 + "absolute; " + textHtml2 + "<![endif]-->";
    // IE >= 7 and all other browsers
    if (!document.statusImg) {
      statusContainer.innerHTML = imgHtml1 + "fixed; " + imgHtml2 + textHtml1 + "fixed; " + textHtml2;
    }
  }

  // define the callbacks on the Push-Page and the Engine needed by the optional status notification;
  // because such callbacks need to be leveraged by some application-specific code too, a simple extension
  // mechanism has been implemented below to inject custom code defined in the Push-Page.

  // we get the reference to the current Engine (be it here or on another Push-Page)
  pushPage.onEngineReady = function(lsEngine) {

    // define the callback on the Engine status change and change the image accordingly
    lsEngine.onStatusChange = function(newStatus) {
      if (showStatus) {
        var statusImgSrc;
        var statusText;
        if (newStatus == "STREAMING") {
          statusImgSrc = "status_connected_streaming" + (pushPage.isMasterPushPage() ? "_master" : "") + ".png";
          statusText = "Connected to Push Server<br />(Streaming" + (pushPage.isMasterPushPage() ? " - Master page" : "") + ")";
        } else if (newStatus == "POLLING") {
          statusImgSrc = "status_connected_polling" + (pushPage.isMasterPushPage() ? "_master" : "") + ".png";
          statusText = "Connected to Push Server<br />(Smart polling" + (pushPage.isMasterPushPage() ? " - Master page" : "") + ")";
        } else if (newStatus == "STALLED") {
          statusImgSrc = "status_stalled" + (pushPage.isMasterPushPage() ? "_master" : "") + ".png";
          statusText = "Connection to Push Server stalled" + (pushPage.isMasterPushPage() ? "<br /> (Master page)" : "");
        } else if (newStatus == "DISCONNECTED") {
          statusImgSrc = "status_disconnected" + (pushPage.isMasterPushPage() ? "_master" : "") + ".png";
          statusText = "Disconnected from Push Server" + (pushPage.isMasterPushPage() ? "<br /> (Master page)" : "");
        } else if (newStatus == "CONNECTING") {
          statusImgSrc = "status_disconnected" + (pushPage.isMasterPushPage() ? "_master" : "") + ".png";
          statusText = "Trying to connect to Push Server..." + (pushPage.isMasterPushPage() ? "<br /> (Master page)" : "");
        }
        document.statusImg.src = statusImgDir + statusImgSrc;
        document.getElementById("statusDiv").innerHTML = statusText;
        // on Safari write to the status bar, to overwrite a misleading download message
        if (navigator.vendor && navigator.vendor.indexOf("Apple") != -1) window.status = " ";        
      }
      
      // if the page that includes this script defines the onStatusChange function,
      // let's execute it as the final part of the lsEngine.onStatusChange() implementation
      if (pushPage.onStatusChangeLocal != null) {
        lsEngine.onStatusChangeExtension = pushPage.onStatusChangeLocal;
        lsEngine.onStatusChangeExtension(newStatus);
      }
    };

    // if the page that includes this script defines the onEngineReady function,
    // let's execute it as the final part of the pushPage.onEngineReady() implementation
    if (onEngineReady != null) {
      this.onEngineReadyExtension = onEngineReady;
      this.onEngineReadyExtension(lsEngine);
    }
    
    // take the very current engine status into considerations
    lsEngine.onStatusChange(lsEngine.getStatus());

  };

  // the Engine has been lost; change the status image accordingly
  pushPage.onEngineLost = function() {
    if (showStatus) {
      document.statusImg.src = statusImgDir + "status_waiting.png";
      document.getElementById("statusDiv").innerHTML = "Waiting for Push Engine creation...";
    }
    
    // if the page that includes this script defines the onEngineLost function,
    // let's execute it as the final part of the pushPage.onEngineLost() implementation
    if (onEngineLost != null) {
      this.onEngineLostExtension = onEngineLost;
      this.onEngineLostExtension();
    }
  };
}