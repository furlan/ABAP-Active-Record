# ABAP-Active-Record
It's inspired in the Ruby on Rails Active Record.

## Motivation
It's to avoid SAP Gateway service just to retrieve some information from ABAP Stack from SAPUI5.

## Actual Version
The actual version is just a proof of concept and gather feedback.

## How it works
There is a project at SAP Gateway with two Entity Types, "request" and "result". Using batch processing, first call CREATE_ENTITY for request to start the processing.

For each field or where clause, calls UPDATE_ENTITY to store in a internal table class attribute.

At the end, execute the query using GET_ENTITYSET of result.

On the SAPUI5 side, translate the format returned from "result" to JSON format.

