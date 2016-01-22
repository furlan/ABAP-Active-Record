CLASS zcl_zabap_active_recor_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zabap_active_recor_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_core_srv_runtime~changeset_begin
         REDEFINITION .
    METHODS /iwbep/if_mgw_core_srv_runtime~changeset_end
         REDEFINITION .
  PROTECTED SECTION.

    TYPES:
      BEGIN OF ty_filter,
        filter_line TYPE c LENGTH 100,
      END OF ty_filter .
    TYPES:
      ty_t_filter TYPE TABLE OF ty_filter .

    DATA ddic_table TYPE tabname .
    DATA filter TYPE ty_t_filter .
    DATA method TYPE char30 .

    METHODS requestset_create_entity
         REDEFINITION .
    METHODS requestset_update_entity
         REDEFINITION .
    METHODS resultset_create_entity
         REDEFINITION .
    METHODS resultset_delete_entity
         REDEFINITION .
    METHODS resultset_get_entity
         REDEFINITION .
    METHODS resultset_get_entityset
         REDEFINITION .
    METHODS resultset_update_entity
         REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZABAP_ACTIVE_RECOR_DPC_EXT IMPLEMENTATION.

* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ZABAP_ACTIVE_RE_01_DPC_EXT->/IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_BEGIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_OPERATION_INFO              TYPE        /IWBEP/T_MGW_OPERATION_INFO
* | [--->] IT_CHANGESET_INPUT             TYPE        /IWBEP/IF_MGW_CORE_SRV_RUNTIME=>TY_T_BATCH_REQUEST(optional)
* | [<-->] CV_DEFER_MODE                  TYPE        XSDBOOLEAN(optional)
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD /iwbep/if_mgw_core_srv_runtime~changeset_begin.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ZABAP_ACTIVE_RE_01_DPC_EXT->/IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_END
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD /iwbep/if_mgw_core_srv_runtime~changeset_end.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZABAP_ACTIVE_RE_01_DPC_EXT->REQUESTSET_CREATE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY_C(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_DATA_PROVIDER               TYPE REF TO /IWBEP/IF_MGW_ENTRY_PROVIDER(optional)
* | [<---] ER_ENTITY                      TYPE        ZCL_ZABAP_ACTIVE_RE_01_MPC=>TS_REQUEST
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD requestset_create_entity.

    DATA: ls_request_input_data  TYPE zcl_zabap_active_recor_mpc=>ts_request.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_request_input_data ).

    er_entity = ls_request_input_data.

    me->ddic_table = ls_request_input_data-ddic_table.
    me->method = ls_request_input_data-method.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZABAP_ACTIVE_RE_01_DPC_EXT->REQUESTSET_UPDATE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY_U(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_DATA_PROVIDER               TYPE REF TO /IWBEP/IF_MGW_ENTRY_PROVIDER(optional)
* | [<---] ER_ENTITY                      TYPE        ZCL_ZABAP_ACTIVE_RE_01_MPC=>TS_REQUEST
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD requestset_update_entity.
    DATA: ls_request_input_data  TYPE zcl_zabap_active_recor_mpc=>ts_request.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_request_input_data ).

    er_entity = ls_request_input_data.

    FIELD-SYMBOLS: <fs_filter> LIKE LINE OF me->filter.

    APPEND INITIAL LINE TO me->filter ASSIGNING <fs_filter>.
    <fs_filter>-filter_line = ls_request_input_data-parameter.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZABAP_ACTIVE_RE_01_DPC_EXT->RESULTSET_CREATE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY_C(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_DATA_PROVIDER               TYPE REF TO /IWBEP/IF_MGW_ENTRY_PROVIDER(optional)
* | [<---] ER_ENTITY                      TYPE        ZCL_ZABAP_ACTIVE_RE_01_MPC=>TS_RESULT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD resultset_create_entity.

    FIELD-SYMBOLS: <fs_filter> LIKE LINE OF me->filter.

    DATA o_rowtype TYPE REF TO cl_abap_structdescr.
    o_rowtype ?= cl_abap_typedescr=>describe_by_name( me->ddic_table ).

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

    DATA: wa_parameter TYPE lty_parameter.
    FIELD-SYMBOLS <fsym_field> TYPE any.

* --- parse parameters to WHERE and SET fields
    DATA:  lv_regex TYPE string VALUE '''|\"'. "'''|\"'.
    LOOP AT  me->filter ASSIGNING <fs_filter>.
      SPLIT <fs_filter> AT space INTO wa_parameter-field wa_parameter-operator wa_parameter-value wa_parameter-logic.
      TRANSLATE wa_parameter-field TO UPPER CASE.
      WRITE wa_parameter-operator TO wa_parameter-operator CENTERED.
      WRITE wa_parameter-logic TO wa_parameter-logic CENTERED.
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN wa_parameter-value WITH ''.

      READ TABLE it_ddfields ASSIGNING <fs_ddfield> WITH KEY fieldname = wa_parameter-field.
      IF sy-subrc EQ 0.
        ASSIGN COMPONENT sy-tabix OF STRUCTURE <fsym_warea> TO <fsym_field>.
        IF sy-subrc = 0.
          <fsym_field> = wa_parameter-value.
        ELSE.
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
        ENDIF.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
      ENDIF.
    ENDLOOP.

* --- fill MANDT field
    READ TABLE it_ddfields ASSIGNING <fs_ddfield> WITH KEY fieldname = 'MANDT'.
    IF sy-subrc EQ 0.
      ASSIGN COMPONENT sy-tabix OF STRUCTURE <fsym_warea> TO <fsym_field>.
      IF sy-subrc = 0.
        <fsym_field> = sy-mandt.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
      ENDIF.
    ENDIF.

* --- all dynamic insert
    TRY.

        INSERT INTO (me->ddic_table) VALUES <fsym_warea>.

      CATCH cx_root.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZABAP_ACTIVE_RE_01_DPC_EXT->RESULTSET_DELETE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY_D(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD resultset_delete_entity.
    FIELD-SYMBOLS: <fs_filter> LIKE LINE OF me->filter.

    DATA o_rowtype TYPE REF TO cl_abap_structdescr.
    o_rowtype ?= cl_abap_typedescr=>describe_by_name( me->ddic_table ).

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

    DATA: wa_parameter TYPE lty_parameter.
    FIELD-SYMBOLS <fsym_field> TYPE any.

* --- parse parameters to WHERE and SET fields
    DATA:  lv_regex TYPE string VALUE '''|\"'. "'''|\"'.
    LOOP AT  me->filter ASSIGNING <fs_filter>.
      SPLIT <fs_filter> AT space INTO wa_parameter-field wa_parameter-operator wa_parameter-value wa_parameter-logic.
      TRANSLATE wa_parameter-field TO UPPER CASE.
      WRITE wa_parameter-operator TO wa_parameter-operator CENTERED.
      WRITE wa_parameter-logic TO wa_parameter-logic CENTERED.
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN wa_parameter-value WITH ''.

      READ TABLE it_ddfields ASSIGNING <fs_ddfield> WITH KEY fieldname = wa_parameter-field.
      IF sy-subrc EQ 0.
        ASSIGN COMPONENT sy-tabix OF STRUCTURE <fsym_warea> TO <fsym_field>.
        IF sy-subrc = 0.
          <fsym_field> = wa_parameter-value.
        ELSE.
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
        ENDIF.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
      ENDIF.
    ENDLOOP.

* --- fill MANDT field
    READ TABLE it_ddfields ASSIGNING <fs_ddfield> WITH KEY fieldname = 'MANDT'.
    IF sy-subrc EQ 0.
      ASSIGN COMPONENT sy-tabix OF STRUCTURE <fsym_warea> TO <fsym_field>.
      IF sy-subrc = 0.
        <fsym_field> = sy-mandt.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
      ENDIF.
    ENDIF.

* --- all dynamic delete
    TRY.

        DELETE (me->ddic_table) FROM <fsym_warea>.

      CATCH cx_root.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZABAP_ACTIVE_RE_01_DPC_EXT->RESULTSET_GET_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_REQUEST_OBJECT              TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY(optional)
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [<---] ER_ENTITY                      TYPE        ZCL_ZABAP_ACTIVE_RE_01_MPC=>TS_RESULT
* | [<---] ES_RESPONSE_CONTEXT            TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD resultset_get_entity.
    FIELD-SYMBOLS: <fs_filter> LIKE LINE OF me->filter.

    DATA o_rowtype TYPE REF TO cl_abap_structdescr.
    o_rowtype ?= cl_abap_typedescr=>describe_by_name( me->ddic_table ).

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

    DATA: wa_parameter TYPE lty_parameter.
    FIELD-SYMBOLS <fsym_field> TYPE any.

    DATA: it_where  TYPE TABLE OF edpline.
    FIELD-SYMBOLS: <fs_where> TYPE edpline.

* --- parse parameters to WHERE and SET fields
    LOOP AT  me->filter ASSIGNING <fs_filter> FROM 2.

      APPEND INITIAL LINE TO it_where ASSIGNING <fs_where>.
      <fs_where> = <fs_filter>.

      AT LAST.
        EXIT.
      ENDAT.

      CONCATENATE <fs_where> 'AND' INTO <fs_where> SEPARATED BY space.

    ENDLOOP.

* --- all dynamic retrieve
    TRY.

        SELECT SINGLE * FROM (me->ddic_table) INTO <fsym_warea> WHERE (it_where).
        IF sy-subrc NE 0.
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception.
        ENDIF.

      CATCH cx_root.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDTRY.

* --- write oDATA output
    READ TABLE me->filter ASSIGNING <fs_filter> INDEX 1.
    READ TABLE it_ddfields ASSIGNING <fs_ddfield> WITH KEY fieldname = <fs_filter>.
    ASSIGN COMPONENT  sy-tabix OF STRUCTURE <fsym_warea> TO <fsym_field>.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ELSE.
      er_entity-ddic_table = me->ddic_table.
      er_entity-field = <fs_ddfield>-fieldname.
      er_entity-value = <fsym_field>.
      SHIFT er_entity-value LEFT DELETING LEADING space.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZABAP_ACTIVE_RE_01_DPC_EXT->RESULTSET_GET_ENTITYSET
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
* | [<---] ET_ENTITYSET                   TYPE        ZCL_ZABAP_ACTIVE_RE_01_MPC=>TT_RESULT
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

    DATA: it_fields TYPE TABLE OF lty_parameter,
          it_where  TYPE TABLE OF lty_parameter.
    FIELD-SYMBOLS: <fs_parameter> TYPE lty_parameter.
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
    ref_table_des ?= cl_abap_typedescr=>describe_by_name( me->ddic_table ).
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
        FROM (me->ddic_table)
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
          <fs_entity>-ddic_table = me->ddic_table.

          READ TABLE it_fields ASSIGNING <fs_parameter> INDEX lv_index.
          CHECK sy-subrc EQ 0.

          <fs_entity>-field = <fs_parameter>.
          WRITE <dyn_field> TO <fs_entity>-value LEFT-JUSTIFIED.
        ENDIF.
      ENDDO.
    ENDLOOP.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_ZABAP_ACTIVE_RE_01_DPC_EXT->RESULTSET_UPDATE_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ENTITY_NAME                 TYPE        STRING
* | [--->] IV_ENTITY_SET_NAME             TYPE        STRING
* | [--->] IV_SOURCE_NAME                 TYPE        STRING
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITY_U(optional)
* | [--->] IT_NAVIGATION_PATH             TYPE        /IWBEP/T_MGW_NAVIGATION_PATH
* | [--->] IO_DATA_PROVIDER               TYPE REF TO /IWBEP/IF_MGW_ENTRY_PROVIDER(optional)
* | [<---] ER_ENTITY                      TYPE        ZCL_ZABAP_ACTIVE_RE_01_MPC=>TS_RESULT
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD resultset_update_entity.

    FIELD-SYMBOLS: <fs_filter> LIKE LINE OF me->filter.

    DATA o_rowtype TYPE REF TO cl_abap_structdescr.
    o_rowtype ?= cl_abap_typedescr=>describe_by_name( me->ddic_table ).

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

    DATA: wa_parameter TYPE lty_parameter.
    FIELD-SYMBOLS <fsym_field> TYPE any.

* --- parse parameters to WHERE and SET fields
    DATA:  lv_regex TYPE string VALUE '''|\"'. "'''|\"'.
    LOOP AT  me->filter ASSIGNING <fs_filter>.
      SPLIT <fs_filter> AT space INTO wa_parameter-field wa_parameter-operator wa_parameter-value wa_parameter-logic.
      TRANSLATE wa_parameter-field TO UPPER CASE.
      WRITE wa_parameter-operator TO wa_parameter-operator CENTERED.
      WRITE wa_parameter-logic TO wa_parameter-logic CENTERED.
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN wa_parameter-value WITH ''.

      READ TABLE it_ddfields ASSIGNING <fs_ddfield> WITH KEY fieldname = wa_parameter-field.
      IF sy-subrc EQ 0.
        ASSIGN COMPONENT sy-tabix OF STRUCTURE <fsym_warea> TO <fsym_field>.
        IF sy-subrc = 0.
          <fsym_field> = wa_parameter-value.
        ELSE.
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
        ENDIF.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
      ENDIF.
    ENDLOOP.

* --- fill MANDT field
    READ TABLE it_ddfields ASSIGNING <fs_ddfield> WITH KEY fieldname = 'MANDT'.
    IF sy-subrc EQ 0.
      ASSIGN COMPONENT sy-tabix OF STRUCTURE <fsym_warea> TO <fsym_field>.
      IF sy-subrc = 0.
        <fsym_field> = sy-mandt.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
      ENDIF.
    ENDIF.

* --- all dynamic update
    TRY.

        UPDATE (me->ddic_table) FROM <fsym_warea>.

      CATCH cx_root.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.