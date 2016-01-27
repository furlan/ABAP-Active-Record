  METHOD get_fields_list.

* --- parse parameters
    FIELD-SYMBOLS: <fs_parameter> LIKE LINE OF me->parameters.
    DATA: wa_parsed TYPE ty_parse_parameter.

    LOOP AT  me->parameters ASSIGNING <fs_parameter>.
      SPLIT <fs_parameter> AT space INTO wa_parsed-field wa_parsed-operator wa_parsed-value wa_parsed-logic.

* ----- It identifies a FIELD
      IF wa_parsed-operator IS INITIAL.
        APPEND wa_parsed TO re_fields_list.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.