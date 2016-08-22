var prefService = Components.classes["@mozilla.org/preferences-service;1"].getService(Components.interfaces.nsIPrefBranch);

function init(){
    document.getElementById('addon_name').innerHTML = WIPS.a00112.config.title;
    document.getElementById('button_ok').addEventListener('click',function(){
        prefService.setBoolPref('extensions.wips.stats_permission.a00112',true);
        prefService.setBoolPref('extensions.wips.preferences.a00112.special_thanks',true);
        window.close();
    },false);
    document.getElementById('button_no').addEventListener('click',function(){
        prefService.setBoolPref('extensions.wips.stats_permission.a00112',false);
        prefService.setBoolPref('extensions.wips.preferences.a00112.special_thanks',true);
        window.close();
    },false);
}

window.addEventListener("load", function(){
    init();
}, false);