  METHOD requestset_create_entity.

    DATA: ls_request_input_data  TYPE zcl_zabap_active_recor_mpc=>ts_request.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_request_input_data ).

    er_entity = ls_request_input_data.

    me->ddic_table = ls_request_input_data-ddic_table.
    me->method = ls_request_input_data-method.

  ENDMETHOD.