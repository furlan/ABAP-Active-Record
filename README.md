# ABAP-Active-Record
It's inspired in the Ruby on Rails Active Record.

## Motivation
It's to avoid SAP Gateway service just to retrieve some information from ABAP Stack from SAPUI5.

## Actual Version
The actual version is just a proof of concept and gather feedback.

## How it works

Create ABAP Active Record objetc:

`var oABAP = new aarModel(aarServiceUri, 'SFLIGHT');`

Retrieve data set from ABAP Stack, choosing fields and filter

`oABAP.retrieveSet(["CARRID", "CONNID", "FLDATE", "PRICE"], {carrid: "LH", connid: "2402"});`

Get JSON Model:

`var oJSON = oABAP.getSetJSON();`

Here is the JSON Model returned my method getJSON():

`{"SFLIGHT":[`
`{"CARRID":"LH","CONNID":"00002402","FLDATE":"08/21/1997","PRICE":"555,00"},`
`{"CARRID":"LH","CONNID":"00002402","FLDATE":"08/22/1997","PRICE":"590,00"},`
`{"CARRID":"LH","CONNID":"00002402","FLDATE":"08/25/1997","PRICE":"490,00"},`
`{"CARRID":"LH","CONNID":"00002402","FLDATE":"08/30/1997","PRICE":"485,00"}`
`]}`

## Under the Hood

- only SAP Gateway service
- use batch processing
- Two Entity Types, **request** and **result**

1. Call CREATE_ENTITY of **request** to start the proceesing and define some parameters.
2. For each fiel in the list (i.e. `["CARRID", "CONNID", "FLDATE", "PRICE"]`) call UPDATE_ENTITY of **request** and store all fields to be retrieved.
3. For each property in the object (i.e. `{carrid: "LH", connid: "2402"}`) call UPDATE_ENTITY of **request** and store all filters to be used in WHERE clause.
4. At the end of processing, call GET_ENTITYSET of **result** to execute the dynamic SELECT command and return the entityset with a list of all fields.
5. On the SAPUI5 side, `aarModel` class provide all services, include to translate the format returned from **result** to JSON format.

## Feedback

For questions/comments/bugs/feature requests/wishes please create an [issue](https://github.com/furlan/ABAP-Active-Record/issues).
2
