sap.ui.define([
    "sap/ui/model/odata/ODataModel", 
    "sap/ui/model/json/JSONModel", 
]), function(Object, JSONModel){
    "use strict";
    
    var aarModel = function (serviceUri, tableName ) {
	
        this.aarModel = tableName; 
        
        this.oData = new ODataModel(serviceUri);
        sap.ui.getCore().setModel(this.oData, "aarOData");
        
        this.oJSON = new JSONModel();
        sap.ui.getCore().setModel(this.oJSON, "aarJSON");
        
        this.oJSONEntity = new JSONModel();
        sap.ui.getCore().setModel(this.oJSONEntity, "aarJSONEntity");
        
    };

    aarModel.prototype.getModel = function(){
        return this.aarModel;
    };
	
    aarModel.prototype.retrieveSet = function(fieldsList,filterCondition) {
        console.log("getSet");
        
        var batchChanges = []; 
        var addBatchChanges = []; 
        var oEntry = {};
        
        oEntry.model = this.aarModel;
        oEntry.method = "retrieveSet";
        batchChanges.push( this.oData.createBatchOperation( "requestSet", "POST", oEntry));
        
        for (i = 0; i < fieldsList.length; i++) {
            
            oEntry = {};
            
            oEntry.parameters = fieldsList[i];			
            
            batchChanges.push( this.oData.createBatchOperation( "requestSet('')", "PUT", oEntry));
            
        };
        
        var field;
        
        var whereConditions = [];
        
        for (field in filterCondition) {
            whereConditions.push(field + " EQ '" + filterCondition[field] + "'");
        };


        for (i = 0; i < whereConditions.length; i++) {
            
            oEntry = {};
            
            oEntry.parameters = whereConditions[i];	
            
            if	(i < whereConditions.length - 1) {
                
                //oEntry.parameters += " AND";
                
            };
            
            batchChanges.push( this.oData.createBatchOperation( "requestSet('')", "PUT", oEntry));
            
        };
        
        
        addBatchChanges.push(this.oData.createBatchOperation( "resultSet?$format=json", "GET"));
        //addBatchChanges.push(oData.createBatchOperation( "resultSet", "GET"));
        
        this.oData.addBatchChangeOperations(batchChanges);
        
        this.oData.addBatchReadOperations(addBatchChanges);

        this.oData.setUseBatch(true);
        //oData.setHeaders({"Content-Type" : "multipart/mixed;boundary=batch"});
        this.oData.setHeaders({"Content-Type" : "application/http"});
                
        this.oData.submitBatch(
            function(oDataResponse,oResponse,aErrorResponses){  // Success
                sap.ui.getCore().getModel("aarJSON").setJSON(oDataResponse.__batchResponses[1].body); 		
            },
            
            function(oError){           // Error
                
                sap.ui.commons.MessageBox.alert("Batch update error!") ;
            } ,
            false      // synchronous
        );

        var aFields = this.oJSON.getProperty("/d/results");
        
        var firstFieldName = aFields[0].field;
        var oModel = new Object();
        var oInstance = new Object();
        
        oModel[aFields[0].model] = [];
        
        for (i = 0; i < aFields.length; i++) {
            
            if (firstFieldName == aFields[i].field && i > 0) {  // starts new instance
                
                oModel[aFields[0].model].push(oInstance);
                
                var oInstance = new Object();
                
            };
            
            oInstance[aFields[i].field] = aFields[i].value;
            
        };
        
        oModel[aFields[0].model].push(oInstance);  // last field
        
        var oJSON = new sap.ui.model.json.JSONModel();
        oJSON.setData(oModel);
        
        return oJSON;
        
    };

    aarModel.prototype.create = function(fieldsValues) {
        console.log("create");
        
        var batchChanges = []; 
        var addBatchChanges = []; 
        var oEntry = {};
        
        this.oData.clearBatch();
        
        oEntry.model = this.aarModel;
        oEntry.method = "create";
        batchChanges.push( this.oData.createBatchOperation( "requestSet", "POST", oEntry));
        
        var field;
        
        var whereConditions = [];
        
        for (field in fieldsValues) {
            //whereConditions.push(field + " = '" + fieldsValues[field] + "'");
            
            oEntry = {};
            
            oEntry.parameters = field + " = '" + fieldsValues[field] + "'";	
            
            batchChanges.push( this.oData.createBatchOperation( "requestSet('')", "PUT", oEntry));
            
        };
        
        oEntry = {};
        oEntry.model = this.aarModel;
        batchChanges.push(this.oData.createBatchOperation( "resultSet", "POST", oEntry));
        
        //addBatchChanges.push(this.oData.createBatchOperation( "resultSet?$format=json", "POST", oEntry));
        //addBatchChanges.push(oData.createBatchOperation( "resultSet", "GET"));
        
        this.oData.addBatchChangeOperations(batchChanges);
        
        //this.oData.addBatchReadOperations(addBatchChanges);

        this.oData.setUseBatch(true);
        //oData.setHeaders({"Content-Type" : "multipart/mixed;boundary=batch"});
        this.oData.setHeaders({"Content-Type" : "application/http"});
                
        this.oData.submitBatch(
            function(oDataResponse,oResponse,aErrorResponses){  // Success
                //sap.ui.getCore().getModel("aarJSON").setJSON(oDataResponse.__batchResponses[1].body); 		
                console.log("json");
            },
            
            function(oError){           // Error
                
                sap.ui.commons.MessageBox.alert("Batch update error!") ;
            } ,
            false      // synchronous
        );
        
        
    };

    aarModel.prototype.getSingleValue = function(fieldSingleValue, fieldsValues) {
        console.log("getValue: " + fieldSingleValue);
        
        var batchChanges = []; 
        var batchRead = []; 
        var oEntry = {};
        
        this.oData.clearBatch();
        
        oEntry.model = this.aarModel;
        oEntry.method = "find";
        batchChanges.push( this.oData.createBatchOperation( "requestSet", "POST", oEntry));
        
        
        oEntry = {};
        oEntry.parameters = fieldSingleValue;	
        batchChanges.push( this.oData.createBatchOperation( "requestSet('')", "PUT", oEntry));
        
        var field;
        
        var whereConditions = [];
        
        for (field in fieldsValues) {
            //whereConditions.push(field + " = '" + fieldsValues[field] + "'");
            
            oEntry = {};
            
            oEntry.parameters = field + " = '" + fieldsValues[field] + "'";	
            
            batchChanges.push( this.oData.createBatchOperation( "requestSet('')", "PUT", oEntry));
            
        };
        
        oEntry = {};
        oEntry.model = this.aarModel;
        batchRead.push(this.oData.createBatchOperation( "resultSet('')", "GET", oEntry));
        
        //addBatchChanges.push(this.oData.createBatchOperation( "resultSet?$format=json", "POST", oEntry));
        //addBatchChanges.push(oData.createBatchOperation( "resultSet", "GET"));
        
        this.oData.addBatchChangeOperations(batchChanges);
        
        this.oData.addBatchReadOperations(batchRead);

        this.oData.setUseBatch(true);
        //oData.setHeaders({"Content-Type" : "multipart/mixed;boundary=batch"});
        this.oData.setHeaders({"Content-Type" : "application/http"});
        
        var value;
                
        this.oData.submitBatch(
            function(oDataResponse,oResponse,aErrorResponses){  // Success
                console.log("json");
                value = oDataResponse.__batchResponses[1].data.value;
            },
            
            function(oError){           // Error
                
                sap.ui.commons.MessageBox.alert("Batch update error!") ;
            } ,
            false      // synchronous
        );
        
        return value;
        
    };

    aarModel.prototype.update = function(fieldsValues) {
        console.log("update");
        
        var batchChanges = []; 
        var addBatchChanges = []; 
        var oEntry = {};
        
        this.oData.clearBatch();
        
        oEntry.model = this.aarModel;
        oEntry.method = "update";
        batchChanges.push( this.oData.createBatchOperation( "requestSet", "POST", oEntry));
        
        var field;
        
        var whereConditions = [];
        
        for (field in fieldsValues) {
            //whereConditions.push(field + " = '" + fieldsValues[field] + "'");
            
            oEntry = {};
            
            oEntry.parameters = field + " = '" + fieldsValues[field] + "'";	
            
            batchChanges.push( this.oData.createBatchOperation( "requestSet('')", "PUT", oEntry));
            
        };
        
        oEntry = {};
        oEntry.model = this.aarModel;
        batchChanges.push(this.oData.createBatchOperation( "resultSet('')", "PUT", oEntry));
        
        //addBatchChanges.push(this.oData.createBatchOperation( "resultSet?$format=json", "POST", oEntry));
        //addBatchChanges.push(oData.createBatchOperation( "resultSet", "GET"));
        
        this.oData.addBatchChangeOperations(batchChanges);
        
        //this.oData.addBatchReadOperations(addBatchChanges);

        this.oData.setUseBatch(true);
        //oData.setHeaders({"Content-Type" : "multipart/mixed;boundary=batch"});
        this.oData.setHeaders({"Content-Type" : "application/http"});
                
        this.oData.submitBatch(
            function(oDataResponse,oResponse,aErrorResponses){  // Success
                //sap.ui.getCore().getModel("aarJSON").setJSON(oDataResponse.__batchResponses[1].body); 		
                console.log("json");
            },
            
            function(oError){           // Error
                
                sap.ui.commons.MessageBox.alert("Batch update error!") ;
            } ,
            false      // synchronous
        );
        
        
    };


    aarModel.prototype.destroy = function(fieldsValues) {
        console.log("destroy");
        
        var batchChanges = []; 
        var addBatchChanges = []; 
        var oEntry = {};
        
        this.oData.clearBatch();
        
        oEntry.model = this.aarModel;
        oEntry.method = "destroy";
        batchChanges.push( this.oData.createBatchOperation( "requestSet", "POST", oEntry));
        
        var field;
        
        var whereConditions = [];
        
        for (field in fieldsValues) {
            //whereConditions.push(field + " = '" + fieldsValues[field] + "'");
            
            oEntry = {};
            
            oEntry.parameters = field + " = '" + fieldsValues[field] + "'";	
            
            batchChanges.push( this.oData.createBatchOperation( "requestSet('')", "PUT", oEntry));
            
        };
        
        oEntry = {};
        oEntry.model = this.aarModel;
        batchChanges.push(this.oData.createBatchOperation( "resultSet('')", "DELETE", oEntry));
        
        //addBatchChanges.push(this.oData.createBatchOperation( "resultSet?$format=json", "POST", oEntry));
        //addBatchChanges.push(oData.createBatchOperation( "resultSet", "GET"));
        
        this.oData.addBatchChangeOperations(batchChanges);
        
        //this.oData.addBatchReadOperations(addBatchChanges);

        this.oData.setUseBatch(true);
        //oData.setHeaders({"Content-Type" : "multipart/mixed;boundary=batch"});
        this.oData.setHeaders({"Content-Type" : "application/http"});
                
        this.oData.submitBatch(
            function(oDataResponse,oResponse,aErrorResponses){  // Success
                //sap.ui.getCore().getModel("aarJSON").setJSON(oDataResponse.__batchResponses[1].body); 		
                console.log("json");
            },
            
            function(oError){           // Error
                
                sap.ui.commons.MessageBox.alert("Batch update error!") ;
            } ,
            false      // synchronous
        );
        
        
    };

    return aarModel;

}; 




