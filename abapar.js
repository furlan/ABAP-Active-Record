sap.ui.define(["sap/ui/model/odata/ODataModel", "sap/ui/model/json/JSONModel"], 
    function(ODataModel, JSONModel){
    "use strict";
    
    console.log("abapar.js");
    // instantiate a Something and call foo() on it
    //console.log(new abapar().foo());
    var abapar = function(){};
    
    abapar.prototype.foo = function() {
        
        return "text";
    
    };

    return abapar;

}); 




