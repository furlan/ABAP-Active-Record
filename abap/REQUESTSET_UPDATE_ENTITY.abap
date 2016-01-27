  METHOD requestset_update_entity.
    DATA: ls_request_input_data  TYPE zcl_zabap_active_recor_mpc=>ts_request.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_request_input_data ).
    er_entity = ls_request_input_data.

    FIELD-SYMBOLS: <fs_parameters> LIKE LINE OF me->parameters.

    " add field or parameter in to internal table to use in Open SQL operation.
    APPEND INITIAL LINE TO me->parameters ASSIGNING <fs_parameters>.
    <fs_parameters>-parameter_line = ls_request_input_data-parameter.


  ENDMETHOD.