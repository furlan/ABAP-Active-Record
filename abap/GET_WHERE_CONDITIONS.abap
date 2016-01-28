  METHOD get_where_conditions.

* --- parse parameters
    FIELD-SYMBOLS: <fs_parameter> LIKE LINE OF me->parameters.
    FIELD-SYMBOLS: <fs_where> TYPE ty_parse_parameter.
    DATA: wa_parsed TYPE ty_parse_parameter.

    DATA it_parms_to_parse TYPE TABLE OF string.
    FIELD-SYMBOLS <fs_parm_to_parse> TYPE string.

* --- all parameters for WHERE clause.
    LOOP AT  me->parameters ASSIGNING <fs_parameter>  WHERE parameter_type = me->c_where_param_id.

      SPLIT <fs_parameter>-parameter_line AT me->c_parameter_separator INTO TABLE it_parms_to_parse.

      LOOP AT it_parms_to_parse ASSIGNING <fs_parm_to_parse>.
        SPLIT <fs_parm_to_parse> AT space INTO wa_parsed-field wa_parsed-operator wa_parsed-value wa_parsed-logic.

        WRITE wa_parsed-operator TO wa_parsed-operator CENTERED.
        WRITE wa_parsed-logic TO wa_parsed-logic CENTERED.

        IF wa_parsed-logic IS INITIAL.
          WRITE 'AND' TO wa_parsed-logic CENTERED.
        ENDIF.
        APPEND wa_parsed TO re_where_list.

      ENDLOOP.

    ENDLOOP.

* --- last WHERE clause do not need AND operator
    DATA lv_lines TYPE i.
    lv_lines = lines( re_where_list ).

    READ TABLE re_where_list ASSIGNING <fs_where> INDEX lv_lines.
    IF sy-subrc EQ 0.
      CLEAR <fs_where>-logic.
    ENDIF.

  ENDMETHOD.