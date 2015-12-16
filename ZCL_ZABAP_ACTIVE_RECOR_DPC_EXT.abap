class ZCL_ZABAP_ACTIVE_RECOR_DPC_EXT definition
  public
  inheriting from ZCL_ZABAP_ACTIVE_RECOR_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_BEGIN
    redefinition .
  methods /IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_END
    redefinition .
protected section.

  types:
    BEGIN OF TY_FILTER,
          filter_line type c LENGTH 100,
         end of ty_filter .
  types:
    ty_t_filter TYPE TABLE OF ty_filter .

  data MODEL type TABNAME .
  data FILTER type TY_T_FILTER .
  data METHOD type CHAR30 .

  methods REQUESTSET_CREATE_ENTITY
    redefinition .
  methods REQUESTSET_UPDATE_ENTITY
    redefinition .
  methods RESULTSET_CREATE_ENTITY
    redefinition .
  methods RESULTSET_GET_ENTITYSET
    redefinition .
  methods RESULTSET_UPDATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZABAP_ACTIVE_RECOR_DPC_EXT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ZABAP_ACTIVE_RECOR_DPC_EXT->/IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_BEGIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_OPERATION_INFO              TYPE        /IWBEP/T_MGW_OPERATION_INFO
* | [<-->] CV_DEFER_MODE                  TYPE        XSDBOOLEAN(optional)
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method /IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_BEGIN.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ZABAP_ACTIVE_RECOR_DPC_EXT->/IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_END
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method /IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_END.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZABAP_ACTIVE_RECOR_DPC_EXT->REQUESTSET_CREATE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY_C(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_DATA_PROVIDER               TYPE REF TO /IWBEP/IF_MGW_ENTRY_PROVIDER(optional)
* | [<---] ER_ENTITY                      TYPE        ZCL_ZABAP_ACTIVE_RECOR_MPC=>TS_REQUEST
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD requestset_create_entity.

    DATA: ls_request_input_data  TYPE zcl_zabap_active_recor_mpc=>ts_request.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_request_input_data ).

    er_entity = ls_request_input_data.

    me->model = ls_request_input_data-model.
    me->method = ls_request_input_data-method.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZABAP_ACTIVE_RECOR_DPC_EXT->REQUESTSET_UPDATE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY_U(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_DATA_PROVIDER               TYPE REF TO /IWBEP/IF_MGW_ENTRY_PROVIDER(optional)
* | [<---] ER_ENTITY                      TYPE        ZCL_ZABAP_ACTIVE_RECOR_MPC=>TS_REQUEST
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD requestset_update_entity.
    DATA: ls_request_input_data  TYPE zcl_zabap_active_recor_mpc=>ts_request.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_request_input_data ).

    er_entity = ls_request_input_data.

    FIELD-SYMBOLS: <fs_filter> LIKE LINE OF me->filter.

    APPEND INITIAL LINE TO me->filter ASSIGNING <fs_filter>.
    <fs_filter>-filter_line = ls_request_input_data-parameters.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZABAP_ACTIVE_RECOR_DPC_EXT->RESULTSET_CREATE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY_C(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_DATA_PROVIDER               TYPE REF TO /IWBEP/IF_MGW_ENTRY_PROVIDER(optional)
* | [<---] ER_ENTITY                      TYPE        ZCL_ZABAP_ACTIVE_RECOR_MPC=>TS_RESULT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD resultset_create_entity.

    FIELD-SYMBOLS: <fs_filter> LIKE LINE OF me->filter.

    DATA o_rowtype TYPE REF TO cl_abap_structdescr.
    o_rowtype ?= cl_abap_typedescr=>describe_by_name( me->model ).

    DATA ref_wa TYPE REF TO data.
    CREATE DATA ref_wa TYPE HANDLE o_rowtype.

    FIELD-SYMBOLS <fsym_warea> TYPE any.
    ASSIGN ref_wa->* TO <fsym_warea>.

    DATA: it_ddfields TYPE ddfields.
    FIELD-SYMBOLS: <fs_ddfield> LIKE LINE OF it_ddfields.
    it_ddfields = o_rowtype->get_ddic_field_list( ).

    TYPES: BEGIN OF lty_parameter,
             field    TYPE c LENGTH 30,
             operator TYPE c LENGTH 4,
             value    TYPE c LENGTH 100,
             logic    TYPE c LENGTH 4,
           END OF lty_parameter.

*    FIELD-SYMBOLS: <fs_parameter> TYPE lty_parameter.
    DATA: wa_parameter TYPE lty_parameter.
    FIELD-SYMBOLS <fsym_field> TYPE any.



* --- parse parameters to WHERE and SET fields
    LOOP AT  me->filter ASSIGNING <fs_filter>.
      SPLIT <fs_filter> AT space INTO wa_parameter-field wa_parameter-operator wa_parameter-value wa_parameter-logic.
      TRANSLATE wa_parameter-field TO UPPER CASE.
      WRITE wa_parameter-operator TO wa_parameter-operator CENTERED.
      WRITE wa_parameter-logic TO wa_parameter-logic CENTERED.


      READ TABLE it_ddfields ASSIGNING <fs_ddfield> WITH KEY fieldname = wa_parameter-field.
      IF sy-subrc EQ 0.
        ASSIGN COMPONENT sy-index OF STRUCTURE <fsym_warea> TO <fsym_field>.
        IF sy-subrc = 0.
          <fsym_field> = wa_parameter-value.
        ELSE.
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
        ENDIF.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
      ENDIF.
    ENDLOOP.

* --- all dynamic retrieve
    TRY.

*        INSERT INTO (me->model) VALUES <fsym_warea>.

*        UPDATE (me->model)
*        SET (it_fields)
*        WHERE (it_where).

      CATCH cx_root.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZABAP_ACTIVE_RECOR_DPC_EXT->RESULTSET_GET_ENTITYSET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_FILTER_SELECT_OPTIONS       TYPE        /IWBEP/T_MGW_SELECT_OPTION
* | [--->] IS_PAGING                      TYPE        /IWBEP/S_MGW_PAGING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IT_ORDER                       TYPE        /IWBEP/T_MGW_SORTING_ORDER
* | [--->] IV_FILTER_STRING               TYPE        STRING
* | [--->] IV_SEARCH_STRING               TYPE        STRING
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET(optional)
* | [<---] ET_ENTITYSET                   TYPE        ZCL_ZABAP_ACTIVE_RECOR_MPC=>TT_RESULT
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD resultset_get_entityset.

    FIELD-SYMBOLS: <fs_entity> LIKE LINE OF et_entityset.
    FIELD-SYMBOLS: <fs_filter> LIKE LINE OF me->filter.

    TYPES: BEGIN OF lty_parameter,
             field    TYPE c LENGTH 30,
             operator TYPE c LENGTH 4,
             value    TYPE c LENGTH 100,
             logic    TYPE c LENGTH 4,
           END OF lty_parameter.

    DATA: it_fields TYPE TABLE OF lty_parameter, "edpline.
          it_where  TYPE TABLE OF lty_parameter. "edpline.
    FIELD-SYMBOLS: <fs_parameter> TYPE lty_parameter. "edpline.
    DATA: wa_parameter TYPE lty_parameter.

    TYPE-POOLS : abap.
    FIELD-SYMBOLS: <dyn_table> TYPE STANDARD TABLE,
                   <dyn_wa>    TYPE any,
                   <dyn_field> TYPE any.
    DATA: dy_table TYPE REF TO data,
          dy_line  TYPE REF TO data,
          xfc      TYPE lvc_s_fcat,
          ifc      TYPE lvc_t_fcat.

    DATA : idetails TYPE abap_compdescr_tab,
           xdetails TYPE abap_compdescr.
    DATA : ref_table_des TYPE REF TO cl_abap_structdescr.

* --- parse parameters
    LOOP AT  me->filter ASSIGNING <fs_filter>.
      SPLIT <fs_filter> AT space INTO wa_parameter-field wa_parameter-operator wa_parameter-value wa_parameter-logic.

      IF wa_parameter-operator IS NOT INITIAL. " WHERE condition
        WRITE wa_parameter-operator TO wa_parameter-operator CENTERED.
        WRITE wa_parameter-logic TO wa_parameter-logic CENTERED.
        APPEND wa_parameter TO it_where.
      ELSE. " FIELDS
        APPEND wa_parameter TO it_fields.
      ENDIF.
    ENDLOOP.

    " Get the structure of the table.
    ref_table_des ?= cl_abap_typedescr=>describe_by_name( me->model ).
    idetails[] = ref_table_des->components[].

    LOOP AT idetails INTO xdetails.
      " only necessary fields
      READ TABLE it_fields WITH KEY field = xdetails-name TRANSPORTING NO FIELDS.
      CHECK sy-subrc EQ 0.
      CLEAR xfc.
      xfc-fieldname = xdetails-name .
      xfc-datatype = xdetails-type_kind.
      xfc-inttype = xdetails-type_kind.
      xfc-intlen = xdetails-length.
      xfc-decimals = xdetails-decimals.
      APPEND xfc TO ifc.
    ENDLOOP.

    " Create dynamic internal table and assign to FS
    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = ifc
      IMPORTING
        ep_table        = dy_table.
    ASSIGN dy_table->* TO <dyn_table>.

    " Create dynamic work area and assign to FS
    CREATE DATA dy_line LIKE LINE OF <dyn_table>.
    ASSIGN dy_line->* TO <dyn_wa>.

* --- check logic conditions for WHERE clause
    LOOP AT it_where ASSIGNING <fs_parameter>.
      IF <fs_parameter>-logic IS INITIAL.
        WRITE 'AND' TO <fs_parameter>-logic CENTERED.
      ENDIF.
      AT LAST.
        CLEAR <fs_parameter>-logic.
      ENDAT.
    ENDLOOP.

* --- all dynamic retrieve
    TRY.
        SELECT (it_fields)
        INTO TABLE <dyn_table>
        FROM (me->model)
        WHERE (it_where).
      CATCH cx_root.

    ENDTRY.

* --- write oDATA output
    DATA: lv_index TYPE i.
    LOOP AT <dyn_table> INTO <dyn_wa>.
      DO.
        lv_index = sy-index.
        ASSIGN COMPONENT  sy-index
           OF STRUCTURE <dyn_wa> TO <dyn_field>.
        IF sy-subrc <> 0.
          EXIT.
        ELSE.
          APPEND INITIAL LINE TO et_entityset ASSIGNING <fs_entity>.
          <fs_entity>-model = me->model.

          READ TABLE it_fields ASSIGNING <fs_parameter> INDEX lv_index.
          CHECK sy-subrc EQ 0.

          <fs_entity>-field = <fs_parameter>.
          WRITE <dyn_field> TO <fs_entity>-value LEFT-JUSTIFIED.
        ENDIF.
      ENDDO.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZABAP_ACTIVE_RECOR_DPC_EXT->RESULTSET_UPDATE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY_U(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_DATA_PROVIDER               TYPE REF TO /IWBEP/IF_MGW_ENTRY_PROVIDER(optional)
* | [<---] ER_ENTITY                      TYPE        ZCL_ZABAP_ACTIVE_RECOR_MPC=>TS_RESULT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method RESULTSET_UPDATE_ENTITY.

*    FIELD-SYMBOLS: <fs_filter> LIKE LINE OF me->filter.
*
*    TYPES: BEGIN OF lty_parameter,
*             field    TYPE c LENGTH 30,
*             operator TYPE c LENGTH 4,
*             value    TYPE c LENGTH 100,
*             logic    TYPE c LENGTH 4,
*           END OF lty_parameter.
*
*    DATA: it_fields TYPE TABLE OF lty_parameter, "edpline.
*          it_where  TYPE TABLE OF lty_parameter. "edpline.
*    FIELD-SYMBOLS: <fs_parameter> TYPE lty_parameter. "edpline.
*    DATA: wa_parameter TYPE lty_parameter.
*
*
*    DATA : ref_wa TYPE REF TO cl_abap_structdescr.
*    ref_wa ?= cl_abap_typedescr=>describe_by_name( me->model ).
*    DATA: it_ddfields TYPE ddfields.
*    FIELD-SYMBOLS: <fs_ddfield> LIKE LINE OF it_ddfields.
*    it_ddfields = ref_wa->get_ddic_field_list( ).
*
*
*    FIELD-SYMBOLS:
*      <fs_wa>    TYPE any,
*      <fs_field> TYPE any.
*
*    CREATE DATA ref_wa TYPE HANDLE ref_rowtype.
*    ASSIGN ref_wa->* TO <fs_wa>.
*
*
** --- parse parameters to WHERE and SET fields
*    LOOP AT  me->filter ASSIGNING <fs_filter>.
*      SPLIT <fs_filter> AT space INTO wa_parameter-field wa_parameter-operator wa_parameter-value wa_parameter-logic.
*      TRANSLATE wa_parameter-field TO UPPER CASE.
*      WRITE wa_parameter-operator TO wa_parameter-operator CENTERED.
*      WRITE wa_parameter-logic TO wa_parameter-logic CENTERED.
*
*      READ TABLE it_ddfields ASSIGNING <fs_ddfield> WITH KEY fieldname = wa_parameter-field.
*      IF sy-subrc EQ 0.
*        ASSIGN COMPONENT sy-index OF STRUCTURE <fs_wa> TO <fs_field>.
*        IF sy-subrc = 0.
*          <fs_field> = wa_parameter-value.
*         ENDIF.
*        IF <fs_ddfield>-keyflag EQ 'X' AND <fs_ddfield>-fieldname NE 'MANDT'.
*          APPEND wa_parameter TO it_where.
*        ELSE.
*          APPEND wa_parameter TO it_fields.
*        ENDIF.
*        ELSE.
*          RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.

* --- check if WHERE condition have full key
*    LOOP AT it_ddfields ASSIGNING <fs_ddfield>.
*      CHECK <fs_ddfield>-keyflag IS NOT INITIAL AND <fs_ddfield>-fieldname NE 'MANDT'.
*      READ TABLE it_where ASSIGNING <fs_parameter> WITH KEY field = <fs_ddfield>-fieldname.
*      IF sy-subrc NE 0.
*        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
*      ENDIF.
*    ENDLOOP.

* --- add logic into the WHERE condition
*    LOOP AT it_where ASSIGNING <fs_parameter>.
*      AT LAST.
*        CLEAR <fs_parameter>-logic.
*        EXIT.
*      ENDAT.
*      IF <fs_parameter>-logic IS INITIAL.
*        <fs_parameter>-logic = ' AND'.
*      ENDIF.
*    ENDLOOP.




*    DATA : idetails TYPE abap_compdescr_tab.
*    FIELD-SYMBOLS: <fs_detail> TYPE abap_compdescr.
*
*    idetails[] = ref_rowtype->components[].





* --- all dynamic retrieve
*    TRY.
*
*        INSERT INTO (me->model) VALUES <fs_wa>.
*
**        UPDATE (me->model)
**        SET (it_fields)
**        WHERE (it_where).
*
*      CATCH cx_root.
*        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
*    ENDTRY.
  endmethod.
ENDCLASS.