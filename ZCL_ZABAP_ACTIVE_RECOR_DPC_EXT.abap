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

  data MODEL type TABNAME .
  data FILTER type ZAAR_T_FILTER .

  methods REQUESTSET_CREATE_ENTITY
    redefinition .
  methods REQUESTSET_UPDATE_ENTITY
    redefinition .
  methods RESULTSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZABAP_ACTIVE_RECOR_DPC_EXT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ZABAP_ACTIVE_RECOR_DPC_EXT->/IWBEP/IF_MGW_CORE_SRV_RUNTIME~CHANGESET_BEGIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_OPERATION_INFO              TYPE        /IWBEP/T_MGW_OPERATION_INFO
* | [--->] IT_CHANGESET_INPUT             TYPE        /IWBEP/IF_MGW_CORE_SRV_RUNTIME=>TY_T_BATCH_REQUEST(optional)
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

    DATA: it_fields TYPE TABLE OF edpline,
          it_where  TYPE TABLE OF edpline.
    FIELD-SYMBOLS: <fs_parameter> TYPE edpline.

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
      FIND 'EQ' IN <fs_filter>.
      IF sy-subrc EQ 0. " WHERE condition
        APPEND INITIAL LINE TO it_where ASSIGNING <fs_parameter>.
      ELSE. " FIELDS
        APPEND INITIAL LINE TO it_fields ASSIGNING <fs_parameter>.
      ENDIF.
      IF <fs_parameter> IS ASSIGNED.
        <fs_parameter> = <fs_filter>.
      ENDIF.
    ENDLOOP.

    " Get the structure of the table.
    ref_table_des ?= cl_abap_typedescr=>describe_by_name( me->model ).
    idetails[] = ref_table_des->components[].
    LOOP AT idetails INTO xdetails.
      " only necessary fields
      READ TABLE it_fields WITH KEY table_line = xdetails-name TRANSPORTING NO FIELDS.
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
ENDCLASS.