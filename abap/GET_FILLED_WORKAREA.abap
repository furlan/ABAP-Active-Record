  METHOD GET_FILLED_WORKAREA.

    FIELD-SYMBOLS: <fs_parameter> LIKE LINE OF me->parameters.

    DATA o_rowtype TYPE REF TO cl_abap_structdescr.
    o_rowtype ?= cl_abap_typedescr=>describe_by_name( me->ddic_table ).

    DATA ref_wa TYPE REF TO data.
    CREATE DATA ref_wa TYPE HANDLE o_rowtype.

    FIELD-SYMBOLS <fs_warea> TYPE any.
    ASSIGN ref_wa->* TO <fs_warea>.

    DATA: it_ddfields TYPE ddfields.
    FIELD-SYMBOLS: <fs_ddfield> LIKE LINE OF it_ddfields.
    it_ddfields = o_rowtype->get_ddic_field_list( ).

    DATA: wa_parse TYPE ty_parse_parameter.
    FIELD-SYMBOLS <fs_field> TYPE any.

* --- parse parameters to WHERE and SET fields
    DATA:  lv_regex TYPE string VALUE '''|\"'.
    LOOP AT  me->parameters ASSIGNING <fs_parameter>.
      SPLIT <fs_parameter> AT space INTO wa_parse-field wa_parse-operator wa_parse-value wa_parse-logic.
      TRANSLATE wa_parse-field TO UPPER CASE.
      WRITE wa_parse-operator TO wa_parse-operator CENTERED.
      WRITE wa_parse-logic TO wa_parse-logic CENTERED.

      " Remove apostrophe
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN wa_parse-value WITH ''.

      " fill work area
      READ TABLE it_ddfields ASSIGNING <fs_ddfield> WITH KEY fieldname = wa_parse-field.
      IF sy-subrc EQ 0.
        ASSIGN COMPONENT sy-tabix OF STRUCTURE <fs_warea> TO <fs_field>.
        IF sy-subrc = 0.
          <fs_field> = wa_parse-value.
        ELSE.
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
        ENDIF.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
      ENDIF.
    ENDLOOP.

* --- fill MANDT field, if necessary
    READ TABLE it_ddfields ASSIGNING <fs_ddfield> WITH KEY fieldname = 'MANDT'.
    IF sy-subrc EQ 0.
      ASSIGN COMPONENT sy-tabix OF STRUCTURE <fs_warea> TO <fs_field>.
      IF sy-subrc = 0.
        <fs_field> = sy-mandt.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
      ENDIF.
    ENDIF.

    re_wa_filled = ref_wa.

  ENDMETHOD.