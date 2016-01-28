  METHOD requestset_update_entity.
    DATA: ls_request_input_data  TYPE zcl_zabap_active_recor_mpc=>ts_request.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_request_input_data ).
    er_entity = ls_request_input_data.

    DATA lv_parameter TYPE string.
    lv_parameter = ls_request_input_data-parameter.

    " add field or parameter in to internal table to use in Open SQL operation.
    FIELD-SYMBOLS: <fs_parameters> LIKE LINE OF me->parameters.
    APPEND INITIAL LINE TO me->parameters ASSIGNING <fs_parameters>.
    <fs_parameters>-parameter_type = lv_parameter(1).
    SHIFT lv_parameter LEFT BY 1 PLACES.
    <fs_parameters>-parameter_line = lv_parameter.

  ENDMETHOD.