  METHOD get_fields_list.

* --- parse parameters
    FIELD-SYMBOLS <fs_parameter> LIKE LINE OF me->parameters.
    DATA wa_parsed TYPE ty_parse_parameter.

    DATA it_parms_to_parse TYPE TABLE OF string.
    FIELD-SYMBOLS <fs_parm_to_parse> TYPE string.

* --- all parameters for field selection.
    LOOP AT  me->parameters ASSIGNING <fs_parameter> WHERE parameter_type = me->c_field_param_id.

      SPLIT <fs_parameter>-parameter_line AT me->c_parameter_separator INTO TABLE it_parms_to_parse.

      LOOP AT it_parms_to_parse ASSIGNING <fs_parm_to_parse>.
        SPLIT <fs_parm_to_parse> AT space INTO wa_parsed-field wa_parsed-operator wa_parsed-value wa_parsed-logic.
        APPEND wa_parsed TO re_fields_list.
      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.