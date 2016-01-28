# ABAP-Active-Record

Inspired by the Ruby on Rails Active Record, I started to work on an idea to replicate the concept of Active Record in SAPUI5.

## Motivation

Imagine that you need to retreive some records for a given sales order type from VBAK. Later in the program you need to retrieve a set of materials from MARA table. Then some company code details from T001 table. Then deliveries from LIKP table. If you are using SAP Gateway, you need to create a service for each one of those requests.

In order to avoid to create a new SAP Gateway service for simple retrieval records from SAP tables, the ABAP Active Record give direct access into the SAP tables in a very simple way.

It's not the objective of this project replace all programing at back-end, but avoid create new service for the "incidental" table access.

## How It Works

As example, suppose you need to retrieve all records from SFLIGHT table for Lufthansa (LH) and connection 2402:

First, in SAPUI5 code create ABAP Active Record object:

`var oARModel = new abapActiveRecord.ARModel();`

Then, retrieve a data set (JSON) from ABAP Stack, choosing table, fields and filter

`var oFlightsTable = oARModel.aarGetEntitySet('SFLIGHT', ["CARRID", "CONNID", "FLDATE", "PRICE"], {carrid: "LH", connid: "2402"});`

Repeat the same procedure for any other SAP table (SPFLI, MAKT, BKPF, T001W etc.). No auto-generate code is necessary. Just call proper methods with proper parameters.

## CRUD Methods

It's also allowed to execute all CRUD methods, even in the standard tables.

    Note: It's easy to block update commands in the SAP Gateway class implementation.

### Create

Create a record at table SFLIGHT:

`oARModel.aarCreate('SFLIGHT', {carrid: "LH", connid: "2402", fldate: "20160119", price: "500.00"});`

### Read (set of records)

Retrieve a set of records:

`var oFlightsTable = oARModel.aarGetEntitySet('SFLIGHT', ["CARRID", "CONNID", "FLDATE", "PRICE"], {carrid: "LH", connid: "2402"});`

The JSON model will be like bellow:

`oFlightsTable.getProperty('/')`

`"{"SFLIGHT":[{"CARRID":"LH","CONNID":"00002402","FLDATE":"08/21/1997","PRICE":"555,00"}, ... ]}"`

#### Read Simple Value

Read a single value from a specific record at table SFLIGHT (select single):

	var value = oARModel.aarGetSingleValue("SFLIGHT", "PRICE", {
									carrid: sap.ui.getCore().byId("carrid").getValue(), 
									connid: sap.ui.getCore().byId("connid").getValue(), 
									fldate: sap.ui.getCore().byId("fldate").getValue()
								});

Value of _PRICE_: "500.00".

### Update

Update a record in table SFLIGHT:

`oARModel.aarUpdate("SFLIGHT", {carrid: "LH", connid: "2402", fldate: "20160119", price: "350.00"});`

New value of _PRICE_: "350.00".

### Delete

Delete a record in table SFLIGHT:

`oARModel.aarDelete('SFLIGHT', {carrid: "LH", connid: "2402", fldate: "20160119"});`

## Under the Hood

### SAP Gateway
It's only necessary to create one generic service at SAP Gateway that will respond all requests for any table!

There are two entity types: **request** and **result**, with their entity sets. 

- **request** is responsible to receive all information about database operation, like table name, fields to be selected and filter conditions.
- **result** is responsible to process all information entered using **resquest** calls and execute desired operation.

The whole transation is executed using batch processing. 

`var oFlightsTable = oARModel.aarGetEntitySet('SFLIGHT', ["CARRID", "CONNID", "FLDATE", "PRICE"], {carrid: "LH", connid: "2402"});`

For example, for the _aarGetEntitySet_ method call above, it's necessary follow requests:
- first **request** (POST method) call to pass operation and SAP Table name;
- 4 **request** (PUT method) calls to pass all 4 fields to be retrieved;
- 2 **request** (PUT method) calls to pass 2 filter conditions and 
- last **result** (GET method) call to retrieve all information from database selection.

It's necessary 8 requests in total for this example called in the same transaction (batch).

Here is the return of **result** entity set method:

	<model>SFLIGHT</model>
	<field>CARRID</field>
	<value>LH</value>
	<model>SFLIGHT</model>
	<field>CONNID</field>
	<value>2402</value>
	<model>SFLIGHT</model>
	<field>FLDATE</field>
	<value>08/21/1997</value>
	...

### SAPUI5

In the SAPUI5 side, class `sap.ui.model.odata.ODataModel` was extended to implemented methods for basic CRUD operations and return data in JSON format.

Here is the JSON Model returned by _aarGetEntitySet_ method call above:

	{"SFLIGHT":[
	{"CARRID":"LH","CONNID":"00002402","FLDATE":"08/21/1997","PRICE":"555,00"},
	{"CARRID":"LH","CONNID":"00002402","FLDATE":"08/22/1997","PRICE":"590,00"},
	{"CARRID":"LH","CONNID":"00002402","FLDATE":"08/25/1997","PRICE":"490,00"},
	{"CARRID":"LH","CONNID":"00002402","FLDATE":"08/30/1997","PRICE":"485,00"}
	]}

### ABAP

Here is the list of methods implemented in ABAP in order to process database retrieval:

- REQUESTSET_CREATE_ENTITY

Called in the begginig of all transactions. It's responsible to define the table name and operation.  

- REQUESTSET_UPDATE_ENTITY

Receive all parameters to build dynamic database operation. 

- RESULTSET_CREATE_ENTITY

Used in _aarCreate_ method (PUT) and execute INSERT SQL command.

- RESULTSET_DELETE_ENTITY

Used in _aarDelete_ method (DELETE) and execute DELETE SQL command.

- RESULTSET_GET_ENTITY

Used in _aarGetSingleValue_ method (GET) and execute SELECT SINGLE SQL command.

- RESULTSET_GET_ENTITYSET

Used in _aarGetEntitySet_ method (GET) and execute SELECT SQL command.

- RESULTSET_UPDATE_ENTITY

Used in _aarUpdate_ method (PUT) and execute UPDATE SQL command.

### Sequence Calls

Just as an example, here is the sequence of calls necessary to retrieve a set of records for SFLIGHT table:

`var oFlightsTable = oARModel.aarGetEntitySet('SFLIGHT', ["CARRID", "CONNID", "FLDATE", "PRICE"], {carrid: "LH", connid: "2402"});`

1. Call REQUESTSET_CREATE_ENTITY to start the proceesing and define some parameters.
2. For each field in the list (i.e. `["CARRID", "CONNID", "FLDATE", "PRICE"]`) call REQUESTSET_UPDATE_ENTITY and store all store it in a internal table.
3. For each property in the object (i.e. `{carrid: "LH", connid: "2402"}`) call REQUESTSET_UPDATE_ENTITY and store all filters to be used in WHERE clause in a internal table.
4. At the end of processing, call RESULTSET_GET_ENTITYSET to execute a dynamic SELECT command and return the entityset with a list of all fields.
5. On the SAPUI5 side, `ARModel` class provide all services, include to translate the format returned from **result** entity type to JSON format.

## Installation

You can find installation instructions in [this guide](https://github.com/furlan/ABAP-Active-Record/wiki/Installation-Guide).

## Feedback

It's not ready to be used in production, but just to give an idea and receive feedback from the community.

For questions/comments/bugs/feature requests/wishes please create an [issue](https://github.com/furlan/ABAP-Active-Record/issues).

## Next Steps

Depending on community feedback, here is a list of new features to be implemented:

- Redesign batch calls to decrease size of payloads.
- Improve error handling.
- Users guide.
- Unit Tests
- Allow ranges.
- Allow joins.
- Allow selects in different servers (via RFC).
- Return in OData format.
- Allow more complex WHERE conditions.


