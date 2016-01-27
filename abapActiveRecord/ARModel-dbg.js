/*global sap*/
jQuery.sap.declare("abapActiveRecord.ARModel");

/**
 * Extends ODataModel class to implement methods for ABAP Active Record.
 * 
 * Provides a comprehensive set of features to direct access tables in ABAP stack at SAP Netweaver Application Server.
 * 
 * It allows user create, read, update or delete records in SAP tables with only one generic SAP Gateway service. For more information about how the ABAP Active Record SAP Gateway service should be created, check @see http://github.com/furlan/ABAP-Active-Record.
 * 
 * @extends sap.ui.model.odata.ODataModel
 * @version 0.1
 * 
 */ 
sap.ui.model.odata.ODataModel.extend("abapActiveRecord.ARModel", /** @lends abapActiveRecord.ARddicTable */ {   
    /**
     * SAP Dictionary table name.
     */
    sDdicTable: '',
    
    /**
     * JSON ddicTable to store resuts from HTTPs call to SAP Gateway.
     */
    oResultJSON: new sap.ui.model.json.JSONModel(),
    
    /**
     * Array with batch changes type of requisitions.
     */
    aBatchChanges: [],
    
    /**
     * Array with batch read type of requisitions.
     */
    aBatchRead: [],
    
    /**
     * Redefine super constructor in order to use URI based in the configuration file.
     */
    constructor: function(sServiceUrl, bJSON, sUser, sPassword, mHeaders, bTokenHandling, bWithCredentials, bLoadMetadataAsync){
        arguments = [this._getServiceUri()];
        sap.ui.model.odata.ODataModel.apply(this, arguments);
    },
    
    /**
     * Initiate or clear all attributes.
     * 
     * @param {string} ddicTable SAP Table name.
     * 
     * @private
     */
    _init: function(ddicTable){
        this.sDdicTable = ddicTable;
        this.aBatchChanges = [];
        this.aBatchRead = [];
        sap.ui.getCore().setModel(this.oResultJSON, "ARModelResultJSON");
        this.clearBatch();                     // Removes all operations in the current batch.
    },
    
    /**
     * Get service URI from configuration file.
     * 
     */
    _getServiceUri: function() {
        var oConfigJSON = new sap.ui.model.json.JSONModel();
	    oConfigJSON.loadData('./abapActiveRecord/abapar.json', '', false);
	    var actualEnvironment = oConfigJSON.getProperty('/actualEnvironment');
		return oConfigJSON.getProperty('/serviceURIs/0/' + actualEnvironment);
    },
    
    /**
     * Returns data to be passed in the HTTP call, used to entry values in Resquest entity.
     * 
     * @param {string} [methodName] Active Record method name.
     * @param {string} parameter Active Record parameter value.
     * 
     * @private
     */
    _getRequestEntry: function(methodName,parameter) {
        var oEntry = {};
        oEntry.ddicTable = this.sDdicTable;
        oEntry.method = methodName;
        oEntry.parameter = parameter;
        return oEntry;
    },
    
    /**
     * Returns data to be passed in the HTTP call, used to entry values in Result entity. 
     * 
     * @private
     */
    _getResultEntry: function() {
        var oEntry = {};
        oEntry.ddicTable = this.sDdicTable;
        return oEntry;
    },
    
    /**
     * Add batch operation for each field passed in the fieldList.
     * 
     * @param {array} fieldsList List of fields to be selected.
     * 
     * @private
     */
    _addFieldsListBatchChanges: function(fieldsList) {
        for (var i = 0; i < fieldsList.length; i++) {
    		this._addBatchRequestParameter(fieldsList[i]);
    	}
    },

    /**
     * Add batch operation to add new parameter for each condition passed in the filterCondition.
     * 
     * @param {array} filterCondition List if conditions to be included in the Where condition.
     * 
     * @private
     */
    _addWhereConditionsBatchChanges: function(filterCondition) {
        var field;
    	var whereConditions = [];
    	
    	for (field in filterCondition) {
    		whereConditions.push(field + " EQ '" + filterCondition[field] + "'");
    	}
    
    	for (var i = 0; i < whereConditions.length; i++) {
    		this._addBatchRequestParameter(whereConditions[i]);
    	}
    },
    
    /**
     * Add batch operation to mark the start of batch operation. The first batch operation pass the table and method name.
     * 
     * @param {string} methodName Active Record method name.
     * 
     * @private
     */
    _batchRequestStart: function(methodName) {
        this.aBatchChanges.push( this.createBatchOperation("requestSet", "POST",this._getRequestEntry(methodName)));
    },
    
    /**
     * Add batch operation to add new parameter.
     * 
     * @param {string} parameter Active Record parameter value.
     * 
     * @private
     */
    _addBatchRequestParameter: function(parameterValue) {
    	this.aBatchChanges.push( this.createBatchOperation("requestSet('')", "PUT", this._getRequestEntry('',parameterValue)));
    },
    
    /**
     * Add batch operation to get return set of Result entity. It's the result of database selection.
     * 
     * @private
     */
    _addBatchResultSetRead: function() {
        this.aBatchRead.push(this.createBatchOperation("resultSet?$format=json", "GET"));
    },
    
    /**
     *  Add batch operation to get return entity of Result. It's the result of database selection.
     * 
     * @private
     */
    _addBatchResulEntityRead: function() {
        this.aBatchRead.push(this.createBatchOperation("resultSet('')", "GET", 
            this._getResultEntry()));
    },
    
    /**
     *  Add batch operation to create entity of Result.
     * 
     * @private
     */
    _addBatchResultCreate: function() {
        this.aBatchChanges.push(this.createBatchOperation("resultSet", "POST", 
            this._getResultEntry()));
    },
    
    /**
     *  Add batch operation to update entity of Result.
     * 
     * @private
     */
    _addBatchResultUpdate: function() {
        this.aBatchChanges.push(this.createBatchOperation("resultSet('')", "PUT", 
            this._getResultEntry()));
    },
    
    /**
     *  Add batch operation to delete entity of Result.
     * 
     * @private
     */
    _addBatchResultDelete: function() {
        this.aBatchChanges.push(this.createBatchOperation("resultSet('')", "DELETE", 
            this._getResultEntry()));
    },
    
    /**
     * Submit batch operation and store results into global JSON model (ARModelResultJSON).
     * 
     * If method 'aarGetEntity', then return the value. It's temporary and will be changed in the future releases.
     * 
     * @private
     */
    _submitBatch: function() {
        
        this.addBatchChangeOperations(this.aBatchChanges);
    	this.addBatchReadOperations(this.aBatchRead);
    
    	this.setUseBatch(true);
    	this.setHeaders({"Content-Type" : "application/http"});
    	
    	var value;                      // value to be retrieve by method 'aarGetEntity'
    	this.submitBatch(
    		function(oDataResponse,oResponse,aErrorResponses){  // Success
    			
    			// is it a valid response?
    			if (oDataResponse.__batchResponses.length > 1) {
        			value = oDataResponse.__batchResponses[1].data.value;
        			
        			// did return a set of records?
        			if (typeof(value) !== 'string') { 
    			        sap.ui.getCore().getModel("ARModelResultJSON").setJSON(oDataResponse.__batchResponses[1].body);
        			}    
        		}
    		},
    		
    		function(oError){           // Error
    			// TO-DO: define how to handle properly
    			sap.ui.commons.MessageBox.alert("Batch update error!") ;
    		} ,
    		false      // synchronous
    	);
    	
    	return value;   // single value, if exists
        
    },
    
    /**
     * Return JSON Model with the result of table selection. It's responsible to transform the data from Result 
     * entity set to a more readable JSON Model.
     * 
     * Result entity set, return in the follow format:
     * <code>
     *  <field>CARRID</field>
     *  <value>LH</value>
     *  <field>CONNID</field>
     *  <value>2402</value>
     * </code>
     * 
     * @returns {json} JSON Result set formated like: <code>{"CARRID": "AA", "CONNID": "2402"}</code>.
     * 
     * @private
     */
    _getARModelJSON: function() {
        var aFields = this.oResultJSON.getProperty("/d/results");
    	var firstFieldName = aFields[0].field;
    	var oModel = new Object();
    	var oInstance = new Object();
    	
    	oModel[aFields[0].ddicTable] = [];   // main node as the table name
    	
    	for (var i = 0; i < aFields.length; i++) {
    		
    		if (firstFieldName === aFields[i].field && i > 0) {  // starts new instance
    			oModel[aFields[0].ddicTable].push(oInstance);
    			oInstance = new Object();
    		}
    		
    		oInstance[aFields[i].field] = aFields[i].value;
    	
    	}
    	
    	oModel[aFields[0].ddicTable].push(oInstance);  // last field
    	
    	var oJSON = new sap.ui.model.json.JSONModel();
    	oJSON.setData(oModel);
    	
        return oJSON;
    },
    
    /**
     * Return a JSON model with the line retrieved from SAP Table.
     * 
     * @param {string} ddicTable SAP Table name.
     * @param {array} fieldsList List of fields to be retrieved.
     * @param {array} filterCondition Filter condition.
     * 
     * @returns {json} Formated JSON model.
     * 
     * @public
     */
    aarGetEntitySet: function(ddicTable,fieldsList,filterCondition) {
    	
    	// Initiate all variables and objects.
    	this._init(ddicTable);
    	
    	//--->{ Start batch processin, all batch operations and submit:
        this._batchRequestStart('aarGetEntitySet');
        
    	this._addFieldsListBatchChanges(fieldsList);
    	
    	this._addWhereConditionsBatchChanges(filterCondition);
        
    	this._addBatchResultSetRead();
    	
    	this._submitBatch();
    	// }<---
    	
    	// return Formated JSON Model.
    	return this._getARModelJSON();
    },
    
    /**
     * Try to create a record into SAP Table.
     * 
     * @param {string} ddicTable SAP Table name.
     * @param {fieldsValues} fieldsList List with fields and values to proper create the record.
     * 
     * @returns {boolean} True. Will be changed when add error handling.
     * 
     * @public
     */
    aarCreate: function(ddicTable, fieldsValues) {
        
    	// Initiate all variables and objects.
    	this._init(ddicTable);
    	
    	//--->{ Start batch processing, all batch operations and submit:
    	this._batchRequestStart('aarCreate');
    	
    	this._addWhereConditionsBatchChanges(fieldsValues);
    	
    	this._addBatchResultCreate();
    	
    	this._submitBatch();
    	// }<---
    	
    	return true;
    },
    
    /**
     * Return a single value form a record of SAP Table.
     * 
     * @param {string} ddicTable SAP Table name.
     * @param {string} fieldSingleValue Field name to get the value.
     * @param {fieldsValues} fieldsList List with fields and values to proper create the record.
     * 
     * @returns {string} Return the value retrieved from the record of SAP Table.
     * 
     * @public
     */
    aarGetSingleValue: function(ddicTable,fieldSingleValue,fieldsValues) {
        
    	// Initiate all variables and objects.
    	this._init(ddicTable);
    	
    	//--->{ Start batch processing add all batch operations:
        this._batchRequestStart('aarGetEntity');
        
        this._addBatchRequestParameter(fieldSingleValue);
        
        this._addWhereConditionsBatchChanges(fieldsValues);
        
    	this._addBatchResulEntityRead();
    	// }<---

        // submit and return value.
    	return this._submitBatch();
    },
    
    /**
     * Try to update a record into SAP Table.
     * 
     * @param {string} ddicTable SAP Table name.
     * @param {fieldsValues} fieldsList List with fields and values to update the record. The full key must be provided.
     * 
     * @returns {boolean} True. Will be changed when add error handling.
     * 
     * @public
     */
    aarUpdate: function(ddicTable,fieldsValues) {
        
        // Initiate all variables and objects.
        this._init(ddicTable);
        
        //--->{ Start batch processing, all batch operations and submit:
        this._batchRequestStart('aarUpdate');
        
        this._addWhereConditionsBatchChanges(fieldsValues);
        
    	this._addBatchResultUpdate();
    	
    	this._submitBatch();
    	// }<---
    	
    	return true;
    },
    
    /**
     * Try to delete a record into SAP Table.
     * 
     * @param {string} ddicTable SAP Table name.
     * @param {fieldsValues} fieldsList List with fields and values with the key of the record to be deleted.
     * 
     * @returns {boolean} True. Will be changed when add error handling.
     * 
     * @public
     */
    aarDelete: function(ddicTable,fieldsValues) {
        
        // Initiate all variables and objects.
    	this._init(ddicTable);
    	
    	//--->{ Start batch processing, all batch operations and submit:
        this._batchRequestStart('aarDelete');
        this._addWhereConditionsBatchChanges(fieldsValues);
    	this._addBatchResultDelete();
    	this._submitBatch();
    	// }<---
    	
    	return true;
    },
});