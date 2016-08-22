WIPS.a00112.linebreak = 
{
    string: function()
    {
        var mac= /mac/i.test(navigator.platform);
        var win= /win/i.test(navigator.platform);
        var unix= /lin|unix|x11/i.test(navigator.platform);
		
        if (win)
            return "\r\n";
        /*else if (mac)
            return "\r";*/
        else
            return "\n";
    },
	
    length: function()
    {
        var win= /win/i.test(navigator.platform);
		
        return (win) ? 2 : 1;
    }
};

var BlockSitePrefs = 
{
    translateStr:undefined,
    
    isBlacklist: function(){

        if(document.getElementById("listtypeRadiogroup").selectedItem.label=="Blacklist"){
            return true;
        }
        return false;
    },
        
    storePrefs: function()
    {
        
        const BlockSitePrefBranch = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.BlockSite.");
	
        //store stats
        var prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.wips.");				
        prefs.setBoolPref("stats_permission.a00112",document.getElementById("stats").checked);
        
        // Store BlockSite.enabled
        BlockSitePrefBranch.setBoolPref("enabled", document.getElementById("blockSiteCheckbox").checked);
        // Store BlockSite.showWarning
        BlockSitePrefBranch.setBoolPref("showWarning", document.getElementById("blockSiteCheckboxWarning").checked);
        // Store BlockSite.autoCloseWarning
        //BlockSitePrefBranch.setBoolPref("autoCloseWarning",document.getElementById("autoCloseWarning").checked) ;
        // Store BlockSite.removeLinks
        BlockSitePrefBranch.setBoolPref("removeLinks", document.getElementById("blockSiteCheckboxRemoveLinks").checked);
        // Store BlockSite.authenticate
        BlockSitePrefBranch.setBoolPref("authenticate", document.getElementById("blockSiteCheckboxAuthentication").checked);
        // Store BlockSite.password
        if(document.getElementById("blockSitePassword").value != "")
            BlockSitePrefBranch.setCharPref("password", hex_sha256(document.getElementById("blockSitePassword").value + 'nh4da68h4jf6s4kj8g6d4df8b4d5'));
		
        // Store BlockSite.listtype
        BlockSitePrefBranch.setCharPref("listtype", document.getElementById("listtypeRadiogroup").selectedItem.id);

        // Store BlockSite.blacklist
        var locationList = document.getElementById("BlackListWebsites");
        var locationCount = locationList.getRowCount();
        
        
        var locationArray = new Array();
        var descArray = new Array();
        
        
        for(var i=0; i < locationCount; i++)
        {
            locationList.ensureIndexIsVisible(i);
            
            //saving locatiom
            locationArray.push(locationList.getItemAtIndex(i)
                .getElementsByTagName('listcell')[0]
                .getAttribute('label'));
            //saving description
            descArray.push(locationList.getItemAtIndex(i)
                .getElementsByTagName('listcell')[1]
                .getAttribute('label'));
            
        }
        
        var locationNsIString = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
        var descNsIString = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
        locationNsIString.data = locationArray.join("|||");
        descNsIString.data = descArray.join("|||");
        BlockSitePrefBranch.setComplexValue("blacklist", Components.interfaces.nsISupportsString, locationNsIString);
        BlockSitePrefBranch.setComplexValue("blacklistDesc", Components.interfaces.nsISupportsString, descNsIString);
        
        // Store BlockSite.whitelist
        locationList = document.getElementById("WhiteListWebsites");
        locationCount = locationList.getRowCount();
        
        
        locationArray = new Array();
        descArray = new Array();
        
        
        for(var i=0; i < locationCount; i++)
        {
            locationList.ensureIndexIsVisible(i);
            
            //saving locatiom
            locationArray.push(locationList.getItemAtIndex(i)
                .getElementsByTagName('listcell')[0]
                .getAttribute('label'));
            //saving description
            descArray.push(locationList.getItemAtIndex(i)
                .getElementsByTagName('listcell')[1]
                .getAttribute('label'));
            
        }
        
        locationNsIString = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
        descNsIString = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
        locationNsIString.data = locationArray.join("|||");
        descNsIString.data = descArray.join("|||");
        BlockSitePrefBranch.setComplexValue("whitelist", Components.interfaces.nsISupportsString, locationNsIString);
        BlockSitePrefBranch.setComplexValue("whitelistDesc", Components.interfaces.nsISupportsString, descNsIString);
        
        // BlockSiteObserver Module 
        Components.utils.import("chrome://a00112-wips/content/BlockSite.jsm");

        // Once load blocked page
        BlockSite.refreshBlockedLocationsArray();
        
    },
	
    readPrefs: function()
    {
        try{
            
            this.initTranslate();
            //listeners
            document.getElementById('blockSiteCheckboxAuthentication')
            .addEventListener('click', function(){
                if(document.getElementById('blockSiteCheckboxAuthentication').checked){
                    //todo not working!
                    document.getElementById('authMessage').value=BlockSitePrefs.translate('BlockSite.password');
                    document.documentElement.getButton("accept").disabled = true;
                }else{
                    document.getElementById('authMessage').value="";
                    document.documentElement.getButton("accept").disabled = false;
                }
            }, false);
            document.getElementById('blockSitePassword')
            .addEventListener('keyup', function(){
                if(document.getElementById('blockSitePassword').value.length < 1){
                    //todo not working!
                    document.getElementById('authMessage').value=BlockSitePrefs.translate('BlockSite.password');
                    document.documentElement.getButton("accept").disabled = true;
                }else{
                    document.getElementById('authMessage').value="";
                    document.documentElement.getButton("accept").disabled = false;
                }
            }, false);
            //listeners
            
            const BlockSitePrefBranch = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.BlockSite.");
            
            // read stats
            var prefs = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.wips.");
            document.getElementById("stats").checked=prefs.getBoolPref("stats_permission.a00112");
            
            // Read BlockSite.enabled
            if(BlockSitePrefBranch.prefHasUserValue("enabled"))
            {
                document.getElementById("blockSiteCheckbox").checked = BlockSitePrefBranch.getBoolPref("enabled");
            }
            else
            {
                BlockSitePrefBranch.setBoolPref("enabled", true);
                document.getElementById("blockSiteCheckbox").checked = true;
            }
		
            // Read BlockSite.showWarning
            if(BlockSitePrefBranch.prefHasUserValue("showWarning"))
            {
                document.getElementById("blockSiteCheckboxWarning").checked = BlockSitePrefBranch.getBoolPref("showWarning");
            }
            else
            {
                BlockSitePrefBranch.setBoolPref("showWarning", true);
                document.getElementById("blockSiteCheckboxWarning").checked = true;
            }
            //Read BlockSite.autoCloseWarning
            //document.getElementById("autoCloseWarning").checked = BlockSitePrefBranch.getBoolPref("autoCloseWarning");
		
		
            // Read BlockSite.removeLinks
            if(BlockSitePrefBranch.prefHasUserValue("removeLinks"))
            {
                document.getElementById("blockSiteCheckboxRemoveLinks").checked = BlockSitePrefBranch.getBoolPref("removeLinks");
            }
            else
            {
                BlockSitePrefBranch.setBoolPref("removeLinks", true);
                document.getElementById("blockSiteCheckboxRemoveLinks").checked = true;
            }
            
            
            // Read BlockSite.authenticate
            
            if(BlockSitePrefBranch.prefHasUserValue("authenticate"))
            {
                document.getElementById("blockSiteCheckboxAuthentication").checked = BlockSitePrefBranch.getBoolPref("authenticate");
            }
            else
            {
                BlockSitePrefBranch.setBoolPref("authenticate", false);
                document.getElementById("blockSiteCheckboxAuthentication").checked = false;
            }

            // Read BlockSite.listtype
            if(!BlockSitePrefBranch.prefHasUserValue("listtype"))
            {
                BlockSitePrefBranch.setCharPref("listtype", "blacklistRadio");
            }
            document.getElementById("listtypeRadiogroup").selectedItem = document.getElementById(BlockSitePrefBranch.getCharPref("listtype"));
            this.changeListType();
        
            // Read BlockSite.blacklist
            var blockedWebsitesString = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
	
            if(BlockSitePrefBranch.prefHasUserValue("blacklist"))
            {
                blockedWebsitesString = BlockSitePrefBranch.getComplexValue("blacklist", Components.interfaces.nsISupportsString).data;
                blockedWebsitesDescString = BlockSitePrefBranch.getComplexValue("blacklistDesc", Components.interfaces.nsISupportsString).data;
                var blockedWebsitesArray = blockedWebsitesString.split("|||");
                var blockedWebsitesDescArray = blockedWebsitesDescString.split("|||");
            }
            else
            {
                var blockedWebsitesArray = new Array();
                var blockedWebsitesDescArray = new Array();
            }
		
            var locationList = document.getElementById("BlackListWebsites");
		
            for(var i=0; i < blockedWebsitesArray.length; i++)
            {
                if(blockedWebsitesArray[i] != "")
                {
                    //locationList.appendItem(blockedWebsitesArray[i]);
                    var row = document.createElement('listitem');
                    var cell = document.createElement('listcell');
                    cell.setAttribute('label',blockedWebsitesArray[i]);
                    row.appendChild(cell);
                
                    cell = document.createElement('listcell');
                    
                    if(blockedWebsitesDescArray[i]=='undefined' || !blockedWebsitesDescArray[i]) 
                        cell.setAttribute('label',"");
                    else
                        cell.setAttribute('label',blockedWebsitesDescArray[i]);
                    row.appendChild(cell);
                    locationList.appendChild(row);
                }
            }
        
            // Read BlockSite.white
	
            blockedWebsitesString = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
	
            if(BlockSitePrefBranch.prefHasUserValue("whitelist"))
            {
                blockedWebsitesString = BlockSitePrefBranch.getComplexValue("whitelist", Components.interfaces.nsISupportsString).data;
                blockedWebsitesDescString = BlockSitePrefBranch.getComplexValue("whitelistDesc", Components.interfaces.nsISupportsString).data;
                blockedWebsitesArray = blockedWebsitesString.split("|||");
                blockedWebsitesDescArray = blockedWebsitesDescString.split("|||");
            }
            else
            {
                blockedWebsitesArray = new Array();
                blockedWebsitesDescArray = new Array();
            }
		
            locationList = document.getElementById("WhiteListWebsites");
		
            for(var i=0; i < blockedWebsitesArray.length; i++)
            {
                if(blockedWebsitesArray[i] != "")
                {
                    //locationList.appendItem(blockedWebsitesArray[i]);
                    var row = document.createElement('listitem');
                    var cell = document.createElement('listcell');
                    cell.setAttribute('label',blockedWebsitesArray[i]);
                    row.appendChild(cell);
                    cell = document.createElement('listcell');
                    if(blockedWebsitesDescArray[i]=='undefined' || !blockedWebsitesDescArray[i]) 
                        cell.setAttribute('label',"");
                    else
                        cell.setAttribute('label',blockedWebsitesDescArray[i]);
                    row.appendChild(cell);
                    locationList.appendChild(row);
                }
            }
        }catch(e){
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
	
    changeListType: function()
    {
      try{
        document.getElementById("listtypeCaption").label = document.getElementById("listtypeRadiogroup").selectedItem.label;
        if(document.getElementById("listtypeCaption").label=="Blacklist"){
            isBlackList=true;
            document.getElementById('WhiteVbox').setAttribute('collapsed', 'true');
            document.getElementById('BlackVbox').setAttribute('collapsed', 'false');
            
            
        }else{
            isBlackList=false;            
            document.getElementById('BlackVbox').setAttribute('collapsed', 'true');
            document.getElementById('WhiteVbox').setAttribute('collapsed', 'false');
            
            
        }
      }catch(e){}
    },
	
    editLocation: function()
    {
        
        var locationList = window.opener.document.getElementById('BlackListWebsites');
        var locationList2 = window.opener.document.getElementById('WhiteListWebsites');
        
        var selectedLocation = locationList.getSelectedItem(0);
        if(selectedLocation==null)
            selectedLocation=locationList2.getSelectedItem(0);
        
        
        document.getElementById('blockSiteLocation').value=selectedLocation
        .getElementsByTagName('listcell')[0]
        .getAttribute('label');
        
        document.getElementById('blockSiteLocationDesc').value=selectedLocation
        .getElementsByTagName('listcell')[1]
        .getAttribute('label');
        
    },
	
    updateLocation: function()
    {
        var locationList = window.opener.document.getElementById('BlackListWebsites');
        var selectedLocation = locationList.getSelectedItem(0);
        
        if(selectedLocation==null)	
        {
            locationList = window.opener.document.getElementById('WhiteListWebsites');
            selectedLocation = locationList.getSelectedItem(0);
        }
        var locationTextbox = this.cropUrl(document.getElementById('blockSiteLocation').value);
        var locationDescTextbox = document.getElementById('blockSiteLocationDesc').value;
        var message = window.opener.document.getElementById("blocksiteMessage");
        for(var i=0;i<locationList.itemCount;i++){
            if(locationList.getItemAtIndex(i).getElementsByTagName('listcell')[0].getAttribute('label') == locationTextbox && locationList.getItemAtIndex(i).getElementsByTagName('listcell')[0].getAttribute('label') != selectedLocation.getElementsByTagName('listcell')[0].getAttribute('label')){                
                message.setAttribute('style', 'margin-left:200px;color:red');
                message.setAttribute('value', BlockSitePrefs.translate('BlockSite.pageExist'));
                return;
            }
        }
        
        selectedLocation.getElementsByTagName('listcell')[0]
        .setAttribute('label',locationTextbox);
        selectedLocation.getElementsByTagName('listcell')[1]
        .setAttribute('label',locationDescTextbox);
        locationList.selectedIndex=-1;
    },
    
    cancelEdit: function(){
        window.opener.document.getElementById('WhiteListWebsites').selectedIndex=-1;
        window.opener.document.getElementById('BlackListWebsites').selectedIndex=-1;
    },
    
    addLocation: function(blackList)
    {
        
        var newLocation = document.getElementById("blockSiteNewLocation").value;
        var description = document.getElementById("blockSiteNewLocationDesc").value;
        newLocation=newLocation.toLowerCase();
        newLocation=this.cropUrl(newLocation);
        
        newLocation=newLocation.toLowerCase();
        newLocation=this.cropUrl(newLocation);
        
        if(blackList){
            var locationList = window.opener.document.getElementById("BlackListWebsites");
        }
        else{
            var locationList = window.opener.document.getElementById("WhiteListWebsites");    
        }
        
        var message = window.opener.document.getElementById("blocksiteMessage");
        for(var i=0;i<locationList.itemCount;i++){
            
            if(locationList.getItemAtIndex(i)
                .getElementsByTagName('listcell')[0]
                .getAttribute('label')==newLocation) {                
                message.setAttribute('style', 'margin-left:200px;color:red');
                message.setAttribute('value', BlockSitePrefs.translate('BlockSite.pageExist'));
                //                setTimeout(function(){                    
                //                    var m = document.getElementById("blocksiteMessage");
                //                    m.setAttribute('value', '');
                //                },3000);
                
                return;
            } 
        }
        
        if(newLocation){
            var row = document.createElement('listitem');
            var cell = document.createElement('listcell');
            cell.setAttribute('label',newLocation);
            row.appendChild(cell);
            cell = document.createElement('listcell');
            cell.setAttribute('label',description);
            row.appendChild(cell);
            locationList.appendChild(row);
            //            message.setAttribute('style', 'margin-left:200px;color:green');
            message.setAttribute('value', '');
        }
    
    },
	
    removeLocation: function()
    {
        
        if(this.isBlacklist()){
            var locationList = document.getElementById("BlackListWebsites");
        }else{
            var locationList = document.getElementById("WhiteListWebsites");
        }	
        locationList.removeItemAt(locationList.selectedIndex);
        locationList.selectedIndex=-1;
        
    },
	
    removeAllLocations: function()
    {
        if(this.isBlacklist()){
            var locationList = document.getElementById("BlackListWebsites");
        }else{
            var locationList = document.getElementById("WhiteListWebsites");            
        }
        while(locationList.getRowCount())
        {
            
            locationList.removeItemAt(0);
        }
    },
	
    importList: function()
    {
        var filePickerImport = Components.classes["@mozilla.org/filepicker;1"].createInstance(Components.interfaces.nsIFilePicker);
        var streamImport = Components.classes["@mozilla.org/network/file-input-stream;1"].createInstance(Components.interfaces.nsIFileInputStream);
        var streamIO = Components.classes["@mozilla.org/scriptableinputstream;1"].createInstance(Components.interfaces.nsIScriptableInputStream);
        var overwriteCurrentList = false;
        var input;
        var inputArray;
        var validFile = false;
		
        filePickerImport.init(window, "Select a File", filePickerImport.modeOpen);
        filePickerImport.appendFilters(filePickerImport.filterText);
        if(filePickerImport.show() != filePickerImport.returnCancel)
        {
            
            streamImport.init(filePickerImport.file, 0x01, 0444, null);
            streamIO.init(streamImport);
            input = streamIO.read(streamImport.available());
            streamIO.close();
            streamImport.close();
            // now: unix + mac + dos environment-compatible
            try{
                linebreakImport = input.match(/(?:\[Block[Ss]ite\])(((\n+)|(\r+))+)/m)[1]; // first: whole match -- second: backref-1 -- etc..
                inputArray = input.split(linebreakImport);
            }catch(e){
                window.open('chrome://a00112-wips/content/Usage.xul', '', 'chrome,centerscreen')
                return;
            }
			
            var headerRe = /\[Block[Ss]ite\]/; // tests if the first line is BlockSite's header
            
            if (headerRe.test(inputArray[0])) 
            {
                inputArray.shift();
                var promptService = Components.classes["@mozilla.org/embedcomp/prompt-service;1"].getService(Components.interfaces.nsIPromptService); 
                var msg = "Do you want to Replace your current locations?\n..or Append to them?", title = "BlockSite Import", appendLabel = "Append", replaceLabel = "Replace", cancelLabel="Cancel Import"; 
                var flags = promptService.BUTTON_TITLE_IS_STRING * promptService.BUTTON_POS_2 + promptService.BUTTON_TITLE_IS_STRING * promptService.BUTTON_POS_1 + promptService.BUTTON_TITLE_IS_STRING * promptService.BUTTON_POS_0 + (promptService.BUTTON_POS_0_DEFAULT?promptService.BUTTON_POS_0_DEFAULT:0); 
                var buttonPressed = promptService.confirmEx(window,title,msg,flags,cancelLabel,replaceLabel,appendLabel,null,{});
                if (buttonPressed == 0) return; // second confirm -- user cancelled.
                var shouldAppend = (buttonPressed == 2);
				
                if(!shouldAppend)
                {
                    this.removeAllLocations();
                }
                if(this.isBlacklist()){
                    var locationList = document.getElementById("BlackListWebsites");
                }else{
                    var locationList = document.getElementById("WhiteListWebsites");
                }                        
                for(var i=0; i<inputArray.length; i++)
                {
                    
                    
                    if(inputArray[i]){                        
                        var location=inputArray[i].split(",",1);
                        var description=inputArray[i].substring(location[0].length+1);
                        
                        var row = document.createElement('listitem');
                        var cell = document.createElement('listcell');
                        cell.setAttribute('label',location);
                        row.appendChild(cell);
                        cell = document.createElement('listcell');
                        cell.setAttribute('label',description);
                        row.appendChild(cell);
                        locationList.appendChild(row);
                    }
                }
            }
        }
    },
	
    exportList: function()
    {
        var filepickerExport = Components.classes["@mozilla.org/filepicker;1"].createInstance(Components.interfaces.nsIFilePicker);
        var exportStream = Components.classes["@mozilla.org/network/file-output-stream;1"].createInstance(Components.interfaces.nsIFileOutputStream);

        filepickerExport.init(window, "Select a File", filepickerExport.modeSave);
        filepickerExport.defaultExtension=".txt";
        filepickerExport.appendFilters(filepickerExport.filterText);

        if (filepickerExport.show() != filepickerExport.returnCancel) {
            if (filepickerExport.file.exists())
                filepickerExport.file.remove(true);
            filepickerExport.file.create(filepickerExport.file.NORMAL_FILE_TYPE, 0666);

            exportStream.init(filepickerExport.file, 0x02, 0x200, null);
            exportStream.write("[BlockSite]" + WIPS.a00112.linebreak.string(), 11 + WIPS.a00112.linebreak.length());
			
            if(this.isBlacklist()){
                var locationList = document.getElementById("BlackListWebsites");
            }else{
                var locationList = document.getElementById("WhiteListWebsites");
            }
            
            var locationCount = locationList.getRowCount();
		
                
                
                
            for(var i=0; i<locationCount; i++)
            {
                locationList.ensureIndexIsVisible(i);
                var location = locationList.getItemAtIndex(i)
                .getElementsByTagName('listcell')[0]
                .getAttribute('label');
                var description =locationList.getItemAtIndex(i)
                .getElementsByTagName('listcell')[1]
                .getAttribute('label');
                exportStream.write(location+',' +description, location.length+description.length+1);
                exportStream.write(WIPS.a00112.linebreak.string(), WIPS.a00112.linebreak.length());
            }
			
            exportStream.close();
        }
    },
    
    openAddPage:function(){
        if(this.isBlacklist()){
            window.open('chrome://a00112-wips/content/SetWebsiteBlack.xul', '', 'chrome,centerscreen'); 
        }else{
            window.open('chrome://a00112-wips/content/SetWebsiteWhite.xul', '', 'chrome,centerscreen');
        }
    },
    
    // TRANSLATE
    initTranslate: function(){
        this.translateStr = document.getElementById("translate-strings-a00112");      
    //this.locale = this.translate('locale');
    },
    translate: function(str){
        if(this.translateStr==undefined){
            this.translateStr=window.opener.document.getElementById("translate-strings-a00112");
        }
        return this.translateStr.getString(str);
    }, 
    
    initAdvanced: function(){
        const BlockSitePrefBranch = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.BlockSite.");
        document.getElementById("advancedRadiogroup").selectedItem = document.getElementById(BlockSitePrefBranch.getCharPref("advanced"));
    },
    
    saveAdvanced: function(){
        const BlockSitePrefBranch = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefService).getBranch("extensions.BlockSite.");
        BlockSitePrefBranch.setCharPref("advanced", document.getElementById("advancedRadiogroup").selectedItem.id);
    }
    
}


