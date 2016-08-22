var  EXPORTED_SYMBOLS = ['BlockSite','BlockSiteObserverService','BlockSiteObserver'];

var BlockSiteMainWindow = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator).getMostRecentWindow("navigator:browser");

BlockSiteConvert2RegExp = function(pattern)
{
    var res = "";
    //console(pattern);
    if (/^\/.*\/$/.test(pattern))  // pattern is a regexp already
        res = pattern.substr(1, pattern.length - 2);
    else
    {
//        console(pattern);
        res = pattern.replace(/\*+/g, "*");	// (1)
        //console("1." + res);
        res = res.replace(/(\W)/g, "\\$1"); 	// (2)
//        console("2." + res);
        res = res.replace(/\\\*/g, ".*");    	// (3)
//        console("3." + res);
        res = res.replace(/^\\\|/, "^");	// (4)
//        console("4." + res);
        res = res.replace(/\\\|$/, "$");	// (5)
//        console("5." + res);
    //res = res.replace(/^(\.\*)/,"");	// (6)
    //res = res.replace(/(\.\*)$/,"");	// (7)
    }
	
    try
    {
        
        return new RegExp('^' + res, "i");
    }
    catch(error)
    {
        return false;
    }
}

var BlockSite = 
{
    blockedLocationsArray:[],
    
    alertsService: Components.classes["@mozilla.org/alerts-service;1"].getService(Components.interfaces.nsIAlertsService),
    
    refreshBlockedLocationsArray: function(){
        const BlockSitePrefBranch = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.BlockSite.");
        if(this.isBlackList(BlockSitePrefBranch)){
			     this.blockedLocationsArray = BlockSitePrefBranch.getComplexValue("blacklist", Components.interfaces.nsISupportsString).data.split("|||");
        }else{
           this.blockedLocationsArray = BlockSitePrefBranch.getComplexValue("whitelist", Components.interfaces.nsISupportsString).data.split("|||");
        }
    },
    
    cropUrl:function(url){
        url = url.replace(/^(http(s)?:\/\/)?(www\.)?/,'');
        var array = url.split('/');
        if(array[1] && array[1] != ''){
            return url;
        }else{
            return array[0];
        }
    },
    
    checkArrayR: function(arr, value)
    {
        value=this.cropUrl(value);
        for (var i=0; i < arr.length; i++) 
        {
            var regexp = BlockSiteConvert2RegExp(this.cropUrl(arr[i]));
            
            if(regexp)
            {
                if(regexp.test(value) || regexp.test("www."+value))
                {
                    return true;
                }
            }
        }
    
        return false;
    },

    showPrefs: function(notification, description)
    {
        BlockSiteMainWindow.open("chrome://a00112-wips/content/BlockSitePrefs.xul", "BlockSite Preferences", "chrome,centerscreen,resizable=no");
    },
    
    showBlockWarningBar: function()
    {
        
        var messageBarText = BlockSiteMainWindow.document.getElementById("a00112-wips.locale").getString("BlockSite.messageBarText");
        
        this.simpleDesktopNotify(messageBarText);
        
        /*var notificationBox = gBrowser.getNotificationBox();
        var notification = notificationBox.getNotificationWithValue("website-blocked");
		
        if(notification)
        {
            notification.label = messageBarText;
        }
        else
        {
            const priority = notificationBox.PRIORITY_WARNING_MEDIUM;
            notificationBox.appendNotification(messageBarText, "website-blocked", "chrome://browser/skin/Info.png", priority, null);
        }
        if(autoclose){
            setTimeout(function(){
                var notificationBox = gBrowser.getNotificationBox();
                var notification = notificationBox.getNotificationWithValue("website-blocked");
                if(notification){
                    notificationBox.removeNotification(notification);
                }
            },5000);
        }*/
        
    },
    
    simpleDesktopNotify: function(text){
        this.alertsService.showAlertNotification('chrome://a00112-wips/content/img/icon48.png','Block Site',text,false);
    },
	
    isBlackList: function(prefBranch)
    {
        if (!prefBranch.prefHasUserValue("listtype"))
            return true;
        return prefBranch.getCharPref("listtype") == "blacklistRadio";
    },
	
    checkLocation: function(location)
    {
        const BlockSitePrefBranch = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.BlockSite.");
        if(this.isBlackList(BlockSitePrefBranch)){
            if(BlockSitePrefBranch.prefHasUserValue("blacklist"))
            {
                //var blockedLocationsString = BlockSitePrefBranch.getComplexValue("blacklist", Components.interfaces.nsISupportsString).data;
                if(this.blockedLocationsArray.length > 0)
                {
                    //var blockedLocationsArray = blockedLocationsString.split("|||");				
				
                    if(this.checkArrayR(this.blockedLocationsArray, location)){
                    
                        return true;
                    }
                }
                return false;
            }
        }else{
            if(BlockSitePrefBranch.prefHasUserValue("whitelist"))
            {
                //var blockedLocationsString = BlockSitePrefBranch.getComplexValue("whitelist", Components.interfaces.nsISupportsString).data;
                if(this.blockedLocationsArray.length > 0)
                {
                    //var blockedLocationsArray = blockedLocationsString.split("|||");				
				
                    if(this.checkArrayR(this.blockedLocationsArray, location)){
                        return false;
                    }
                }
                return true;
            }
        }
        
        
        return false;
		
    },
	
    checkAnchor: function(anchor)
    {
        const BlockSitePrefBranch = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.BlockSite.");
        if(this.isBlackList(BlockSitePrefBranch)){
            if(BlockSitePrefBranch.prefHasUserValue("blacklist"))
            {
                //var blockedLocationsString = BlockSitePrefBranch.getComplexValue("blacklist", Components.interfaces.nsISupportsString).data;
                if(this.blockedLocationsArray.length > 0)
                {
                    //var blockedLocationsArray = blockedLocationsString.split("|||");
				
                    if(this.checkArrayR(this.blockedLocationsArray, anchor.href))
                        return true;
                }
            }
            return false;
        }else{
            if(BlockSitePrefBranch.prefHasUserValue("whitelist"))
            {
                //var blockedLocationsString = BlockSitePrefBranch.getComplexValue("whitelist", Components.interfaces.nsISupportsString).data;
                if(this.blockedLocationsArray.length > 0)
                {
                    //var blockedLocationsArray = blockedLocationsString.split("|||");
            				
                    if(this.checkArrayR(this.blockedLocationsArray, anchor.href))
                        return false;
                }
            }
            return true;
                        
        }	
    },
	
    processAnchors: function(event)
    {
      try{
        //this.refreshBlockedLocationsArray();
        
        const BlockSitePrefBranch = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.BlockSite.");
        var anchorElements = event.target.getElementsByTagName("a");
			
			  for(var i=0; i < anchorElements.length; i++)
        {
            if(BlockSite.checkAnchor(anchorElements[i]))
            {
                anchorElements[i].setAttribute('href', '#');
                anchorElements[i].setAttribute('onclick', 'return false');
                if(BlockSitePrefBranch.prefHasUserValue("showWarning") && BlockSitePrefBranch.getBoolPref("showWarning"))
                    anchorElements[i].setAttribute('title', 'THIS LINK IS BLOCKED!');
            //                            var tempFragment = document.createDocumentFragment();
            //                            var childNodes = anchorElements[i].childNodes;
            //                            var parentNode = anchorElements[i].parentNode;
            //            				
            //                            for(var j=0; j < childNodes.length; j++)
            //                            {
            //                                tempFragment.appendChild(childNodes[j].cloneNode(true));
            //                            }
            //            				
            //                            parentNode.replaceChild(tempFragment, anchorElements[i]);
            //                            i--; //List is live, so replacing the node means that anchorElements[i] is refering to the next node already
            }
        }
      }catch(e){}
    },
	
    BlockSiteMain: function(event)
    {
        const BlockSitePrefBranch = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.BlockSite.");
		
        if(BlockSitePrefBranch.prefHasUserValue("enabled") && BlockSitePrefBranch.getBoolPref("enabled"))
        {			
            // earlier versions did not have a remove links preference, so only disable the functionality if the user has
            // specifically unchecked the "remove links" checkbox in the preferences
            if(BlockSitePrefBranch.prefHasUserValue("removeLinks") && (BlockSitePrefBranch.getBoolPref("removeLinks") == false))
            {
                return;
            }

            if(event.type === "DOMContentLoaded" || event.type == "change")
            {			
                // Anchors
                BlockSite.processAnchors(event);
            }
        }
    },
    
    AddPage: function(url){
        
        const BlockSitePrefBranch = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.BlockSite.");
        
        if(this.isBlackList(BlockSitePrefBranch)){
            //save page to blacklist
            var blockedLocationsString = BlockSitePrefBranch.getComplexValue("blacklist", Components.interfaces.nsISupportsString).data;
            var blockedLocationsArray = blockedLocationsString.split("|||");
            for(var i = 0;i<blockedLocationsArray.length;i++){
                if(blockedLocationsArray[i]==this.cropUrl(url))
                    return;
            }
            blockedLocationsArray.push(this.cropUrl(url));
            var locationNsIString = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
            locationNsIString.data = blockedLocationsArray.join("|||");
            BlockSitePrefBranch.setComplexValue("blacklist", Components.interfaces.nsISupportsString, locationNsIString);
            ///save empty description
            var blockedDescString = BlockSitePrefBranch.getComplexValue("blacklistDesc", Components.interfaces.nsISupportsString).data;
            var blockedDescArray = blockedDescString.split("|||");
            blockedDescArray.push("");
            locationNsIString.data="";
            locationNsIString.data = blockedDescArray.join("|||");
            BlockSitePrefBranch.setComplexValue("blacklistDesc", Components.interfaces.nsISupportsString, locationNsIString);
            
        
        }else{
            //save page to whitelist
            var blockedLocationsString = BlockSitePrefBranch.getComplexValue("whitelist", Components.interfaces.nsISupportsString).data;
            var blockedLocationsArray = blockedLocationsString.split("|||");
            for(var i = 0;i<blockedLocationsArray.length;i++){
                if(blockedLocationsArray[i]==this.cropUrl(url))
                    return;
            }
            blockedLocationsArray.push(this.cropUrl(url));           
            var locationNsIString = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
            locationNsIString.data = blockedLocationsArray.join("|||");
            BlockSitePrefBranch.setComplexValue("whitelist", Components.interfaces.nsISupportsString, locationNsIString);
            //save empty description
            var blockedDescString = BlockSitePrefBranch.getComplexValue("whitelistDesc", Components.interfaces.nsISupportsString).data;
            var blockedDescArray = blockedDescString.split("|||");
            blockedDescArray.push("");
            locationNsIString.data = blockedDescArray.join("|||");
            BlockSitePrefBranch.setComplexValue("whitelistDesc", Components.interfaces.nsISupportsString, locationNsIString);
        }
        
        this.refreshBlockedLocationsArray();
           
    }
    
}

// Observer for HTTP requests to block the sites we don't want
var BlockSiteObserver = 
{
    observe: function(aSubject, aTopic, aData)
    {
        //try{
            
            const BlockSitePrefBranch = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.BlockSite.");
            if(BlockSitePrefBranch.getCharPref("advanced")=="blockIncoming"){
                if (aTopic != 'http-on-examine-response')
                    return;
            }else{
                if (aTopic != 'http-on-modify-request')
                    return;
            }
            aSubject.QueryInterface(Components.interfaces.nsIHttpChannel);
            
            
            if(BlockSitePrefBranch.prefHasUserValue("enabled") && BlockSitePrefBranch.getBoolPref("enabled"))
            {
                
                if(!BlockSite.isBlackList(BlockSitePrefBranch)){
                    
                    if(aSubject.contentType!="text/html"){
                        return;
                    }
                }
                
                //BlockSite.refreshBlockedLocationsArray();
                
                if (BlockSite.checkLocation(aSubject.URI.spec))
                {
                    if (BlockSitePrefBranch.prefHasUserValue("showWarning") && BlockSitePrefBranch.getBoolPref("showWarning"))
                        
                        //if(BlockSitePrefBranch.prefHasUserValue("autoCloseWarning")){
                        BlockSite.showBlockWarningBar();
                        /*}else{
                            BlockSite.showBlockWarningBar(false);
                        }*/
                    aSubject.loadFlags = Components.interfaces.nsICachingChannel.LOAD_ONLY_FROM_CACHE;
                    aSubject.cancel(Components.results.NS_BINDING_ABORTED);
                }
            }
                    
        //}catch(e){}
    },

    QueryInterface: function(iid)
    {
        if (!iid.equals(Components.interfaces.nsISupports) &&
            !iid.equals(Components.interfaces.nsIObserver))
            throw Components.results.NS_ERROR_NO_INTERFACE;

        return this;
    }
};

// Add our observer
var BlockSiteObserverService = Components.classes["@mozilla.org/observer-service;1"].getService(Components.interfaces.nsIObserverService);
BlockSiteObserverService.addObserver(BlockSiteObserver, "http-on-examine-response", false);
BlockSiteObserverService.addObserver(BlockSiteObserver, "http-on-modify-request", false);
//WIPS.a00112.observerService.addObserver(BlockSiteObserver, "content-document-global-created", false);