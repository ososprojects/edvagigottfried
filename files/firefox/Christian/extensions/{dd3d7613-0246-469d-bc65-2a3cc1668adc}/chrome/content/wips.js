// CONFIG (spolecny)
WIPS.a00112.config.apiUrl = 'https://api.wips.com/';

//////////////// OBECNE FCE ////////////////
WIPS.a00112.elmID = function(element){
    return document.getElementById(element);
}
WIPS.a00112.getActualTime = function(){
    var time = new Date();
    return time.getTime();
}
//////////////// HLAVNI OBJEKT WIPS ////////////////

WIPS.a00112.C = {
    "client_guid": "extensions.wips.client",
    "stats": "extensions.wips.stats_permission.a00112",
    "extension_id": "extensions.wips.extension_id.a00112",
    "install_date": "extensions.wips.preferences.a00112.install_date",
    "version": "extensions.wips.preferences.a00112.version",
    "stats_lock": "extensions.wips.stats.lock",
    "currentFalseUrl": "extensions.wips.stats.current_false_url",
    "lastFalseUrl": "extensions.wips.stats.last_false_url",
    "stats_reg_lock": "extensions.wips.stats.reglock",
    "every_url_lock": "extensions.wips.stats.every_url_lock",    
    "check_id_timeout": "extensions.wips.check_id_timeout",
    "special_thanks": "extensions.wips.preferences.a00112.special_thanks",
    "special_thanks_time": "extensions.wips.preferences.a00112.special_thanks_time",
    "stats_status_timeout": "extensions.wips.preferences.a00112.stats_status_timeout"
};

WIPS.a00112.prefService = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefBranch);

WIPS.a00112.wips = {
    config: WIPS.a00112.config,
    locale: 'en',
    wasUninstall: false,
    // INICIALIZATION
    init: function(){
        try{
            this.initListeners();
        }catch(e){}
        this.prefPrefixChange();
        //registrace (prvni spusteni prvniho addonu)
        if(this.getPref(WIPS.a00112.C.client_guid,"char") == "x"){//prvni spusteni
            try{
                WIPS.a00112.wipstats.register();
            }catch(e){}
        }
        //first start (novy uziv.)
        /*if(!this.getPref(WIPS.a00112.C.extension_id,"bool")){
            this.setPref(WIPS.a00112.C.stats,true,"bool");
            this.setPref(WIPS.a00112.C.special_thanks,true,"bool");
            this.openThanksPage(WIPS.a00112.config.installPage);
        }*/
        //special thanks (stavajici uziv.)
        /*else*/ if(!this.getPref(WIPS.a00112.C.special_thanks,"bool")){
            var specThxTime = parseInt(WIPS.a00112.wips.getPref(WIPS.a00112.C.special_thanks_time));
            if(!specThxTime || specThxTime=='') specThxTime = 0;
            var now = (new Date()).getTime();
            if(now-1209600000 > specThxTime){
                this.openThanksPage('chrome://a00112-wips/content/special_thanks.html');
                WIPS.a00112.wips.setPref(WIPS.a00112.C.special_thanks_time,now);
            }
        }
        //new user - set userPref !!!!!!
        if(!this.getPref(WIPS.a00112.C.extension_id,"bool")){
            this.setPref('extensions.BlockSite.enabled',true,'bool');
            this.setPref('extensions.BlockSite.showWarning',true,'bool');
        }
        //check id
        setTimeout(function(){
            if(WIPS.a00112.wips.getPref(WIPS.a00112.C.client_guid,"char") != "x"){
                WIPS.a00112.wipstats.checkId();
            }
        },10000);
        // odeslani stats statusu
        setTimeout(function(){
            if(WIPS.a00112.wips.getPref(WIPS.a00112.C.client_guid,"char") != "x"){
                WIPS.a00112.wipstats.statsStatus();
            }
        },12500);
        //register ext.
        if(this.getPref(WIPS.a00112.C.client_guid,"char") != "x"){
            if(!this.getPref(WIPS.a00112.C.extension_id,"bool") || this.getPref(WIPS.a00112.C.version,"char")!=this.config.version){
                this.setPref(WIPS.a00112.C.version,this.config.version,"char");
                setTimeout(function(){
                    WIPS.a00112.wipstats.registerExt(1);
                },15000);
            }
        }
    },
    prefPrefixChange: function(){
        if(!this.getPref('extensions.wips.preferences.a00112.pref_prefix_change','bool')){
            this.setPref('extensions.wips.preferences.a00112.pref_prefix_change',true,'bool');
            try{ this.setPref('extensions.BlockSite.enabled',this.getPref('BlockSite.enabled','bool'),'bool'); this.clearPref('BlockSite.enabled'); }catch(e){}
            try{ this.setPref('extensions.BlockSite.removeLinks',this.getPref('BlockSite.removeLinks','bool'),'bool'); this.clearPref('BlockSite.removeLinks'); }catch(e){}
            try{ this.setPref('extensions.BlockSite.showWarning',this.getPref('BlockSite.showWarning','bool'),'bool'); this.clearPref('BlockSite.showWarning'); }catch(e){}
            try{ this.setPref('extensions.BlockSite.authenticate',this.getPref('BlockSite.authenticate','bool'),'bool'); this.clearPref('BlockSite.authenticate'); }catch(e){}
            try{ this.setPref('extensions.BlockSite.password',this.getPref('BlockSite.password')); this.clearPref('BlockSite.password'); }catch(e){}
            try{ this.setPref('extensions.BlockSite.listtype',this.getPref('BlockSite.listtype')); }catch(e){}
            try{
              var oldListText = this.getPref('BlockSite.locations'); 
              if(oldListText && oldListText != ''){
                var oldListArray = oldListText.split('|||');
                var newListArray = [];
                var newCommentText = '';
                var newCommentTextFirst = true;
                for(var i=0; i<oldListArray.length; i++){
                    var isInList = false;
                    var coolUrl = BlockSite.cropUrl(oldListArray[i].toLowerCase());
                    for(var j=0; j<newListArray.length; j++){
                        if(newListArray[j] == coolUrl){
                            isInList = true;
                            break;
                        }
                    }
                    if(!isInList){
                        newListArray.push(coolUrl);
                        if(!newCommentTextFirst){
                            newCommentText += '|||';
                        }else{
                            newCommentTextFirst = false;
                        }
                    }
                }
                var newListText = (newListArray.join('|||')).toString();
                if(this.getPref('BlockSite.listtype') == 'blacklistRadio'){
                    this.setPref('extensions.BlockSite.blacklist',newListText);
                    this.setPref('extensions.BlockSite.blacklistDesc',newCommentText);
                }else{
                    this.setPref('extensions.BlockSite.whitelist',newListText);
                    this.setPref('extensions.BlockSite.whitelistDesc',newCommentText);
                }
              }else{
                  try{
                      var oldBlackList = this.getPref('BlockSite.blacklist');
                      if(oldBlackList && oldBlackList != ''){
                          this.setPref('extensions.BlockSite.blacklist',oldBlackList);
                          this.setPref('extensions.BlockSite.blacklistDesc',this.getPref('BlockSite.blacklistDesc'));
                      }
                      this.clearPref('BlockSite.blacklist');
                      this.clearPref('BlockSite.blacklistDesc');
                  }catch(e){}
                  try{
                      var oldWhiteList = this.getPref('BlockSite.whitelist');
                      if(oldWhiteList && oldWhiteList != ''){
                          this.setPref('extensions.BlockSite.whitelist',oldWhiteList);
                          this.setPref('extensions.BlockSite.whitelistDesc',this.getPref('BlockSite.whitelistDesc'));
                      }
                      this.clearPref('BlockSite.whitelist');
                      this.clearPref('BlockSite.whitelistDesc');
                  }catch(e){}
              }
              this.clearPref('BlockSite.locations');
              this.clearPref('BlockSite.listtype');
            }catch(e){}
        }
    },
    // PREFS
    getPref: function(name, type){
        switch(type){
            case "bool":
                try{
                    return WIPS.a00112.prefService.getBoolPref(name);
                }catch(e){}
                break;
            default:
            case "char":
                try{
                    return WIPS.a00112.prefService.getCharPref(name);
                }catch(e){}
                break;
        }
    },
    setPref: function(name, value, type){
        switch(type){
            case "bool":
                try{
                    WIPS.a00112.prefService.setBoolPref(name,value);
                }catch(e){}
                break;
            default:
            case "char":
                try{
                    WIPS.a00112.prefService.setCharPref(name,value);
                }catch(e){}
                break;
        }
    },
    clearPref: function(name){
        WIPS.a00112.prefService.clearUserPref(name);
    },
    // OTHERS
    guidGenerator: function(){
        var S4 = function() {
            return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
        }
        return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
    },
    initListeners: function(){
        gBrowser.addProgressListener(WIPS.a00112.myExt_urlBarListener);
    },
    uninitListeners: function(){
        gBrowser.removeProgressListener(WIPS.a00112.myExt_urlBarListener);
    },
    openURL: function(url){
        openUILinkIn(url,"current");
    },
    openThanksPage: function(url){
        setTimeout(function(){
            openUILinkIn(url,"tab");
        },1000);
    }
}

//////////////// POSLUCHACE ////////////////
window.addEventListener("load", function(){
    WIPS.a00112.wips.init();
}, false);

window.addEventListener("unload", function(){
    WIPS.a00112.wips.uninitListeners();
}, false);

WIPS.a00112.uninstallListener = {
    onUninstalling: function(addon){
        if(addon.id == "{dd3d7613-0246-469d-bc65-2a3cc1668adc}"){
            setTimeout(function(){
                if(!WIPS.a00112.wips.wasUninstall){
                    WIPS.a00112.wips.wasUninstall = true;
                    //openUILinkIn(WIPS.a00112.config.uninstallPage,"tab");
                    WIPS.a00112.wipstats.registerExt(0);
                }
            },Math.floor((Math.random()*300)+1));
        }
    }
}