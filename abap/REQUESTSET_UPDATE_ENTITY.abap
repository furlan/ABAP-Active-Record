  METHOD requestset_update_entity.
    DATA: ls_request_input_data  TYPE zcl_zabap_active_recor_mpc=>ts_request.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_request_input_data ).

    er_entity = ls_request_input_data.

    FIELD-SYMBOLS: <fs_filter> LIKE LINE OF me->filter.

    APPEND INITIAL LINE TO me->filter ASSIGNING <fs_filter>.
    <fs_filter>-filter_line = ls_request_input_data-parameter.


  ENDMETHOD.