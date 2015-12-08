function aarModel(serviceUri, model) {
	
	this.aarModel = model;
	
	this.oData = new sap.ui.model.odata.ODataModel(serviceUri);
	sap.ui.getCore().setModel(this.oData, "aarOData");
	
    this.oJSON = new sap.ui.model.json.JSONModel();
	sap.ui.getCore().setModel(this.oJSON, "aarJSON");
	
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
	oEntry.method = "get_set";		
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
			
			oEntry.parameters += " AND";
			
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

};

aarModel.prototype.getFields = function() {
	
	return this.oJSON.getProperty("/d/results");
	
};

aarModel.prototype.getSetJSON = function() {
	
	var aFields = this.getFields();
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
	