  METHOD get_where_conditions.

* --- parse parameters
    FIELD-SYMBOLS: <fs_parameter> LIKE LINE OF me->parameters.
    FIELD-SYMBOLS: <fs_where> TYPE ty_parse_parameter.
    DATA: wa_parsed TYPE ty_parse_parameter.

    LOOP AT  me->parameters ASSIGNING <fs_parameter>.
      SPLIT <fs_parameter> AT space INTO wa_parsed-field wa_parsed-operator wa_parsed-value wa_parsed-logic.

* ----- It identifies a WHERE condition.
      IF wa_parsed-operator IS NOT INITIAL.
        WRITE wa_parsed-operator TO wa_parsed-operator CENTERED.
        WRITE wa_parsed-logic TO wa_parsed-logic CENTERED.

        IF wa_parsed-logic IS INITIAL.
          WRITE 'AND' TO wa_parsed-logic CENTERED.
        ENDIF.
        APPEND wa_parsed TO re_where_list.
      ENDIF.

    ENDLOOP.

    DATA lv_lines TYPE i.
    lv_lines = lines( re_where_list ).

    READ TABLE re_where_list ASSIGNING <fs_where> INDEX lv_lines.
    IF sy-subrc EQ 0.
      CLEAR <fs_where>-logic.
    ENDIF.

  ENDMETHOD.