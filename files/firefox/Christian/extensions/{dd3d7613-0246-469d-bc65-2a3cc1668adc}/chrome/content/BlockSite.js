// BlockSiteObserver Module 
Components.utils.import("chrome://a00112-wips/content/BlockSite.jsm");

// Once load blocked page
BlockSite.refreshBlockedLocationsArray();

// Event listener
window.document.getElementById("appcontent").addEventListener("DOMContentLoaded", BlockSite.BlockSiteMain, false);

// Remove observer when current window closes
/*window.addEventListener("unload", function(){
    WIPS.a00112.observerService.removeObserver(BlockSiteObserver, "http-on-examine-response");
    WIPS.a00112.observerService.removeObserver(BlockSiteObserver, "http-on-modify-request");
}, false);*/
