// This script converts patterns to regexps.
// Thanks Wladimir Palant ;-)

WIPS.a00112.convert2RegExp = function(pattern)
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

