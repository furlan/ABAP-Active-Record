  METHOD resultset_create_entity.

    FIELD-SYMBOLS: <fs_filter> LIKE LINE OF me->filter.

    DATA o_rowtype TYPE REF TO cl_abap_structdescr.
    o_rowtype ?= cl_abap_typedescr=>describe_by_name( me->ddic_table ).

    DATA ref_wa TYPE REF TO data.
    CREATE DATA ref_wa TYPE HANDLE o_rowtype.

    FIELD-SYMBOLS <fsym_warea> TYPE any.
    ASSIGN ref_wa->* TO <fsym_warea>.

    DATA: it_ddfields TYPE ddfields.
    FIELD-SYMBOLS: <fs_ddfield> LIKE LINE OF it_ddfields.
    it_ddfields = o_rowtype->get_ddic_field_list( ).

    TYPES: BEGIN OF lty_parameter,
             field    TYPE c LENGTH 30,
             operator TYPE c LENGTH 4,
             value    TYPE c LENGTH 100,
             logic    TYPE c LENGTH 4,
           END OF lty_parameter.

    DATA: wa_parameter TYPE lty_parameter.
    FIELD-SYMBOLS <fsym_field> TYPE any.

* --- parse parameters to WHERE and SET fields
    DATA:  lv_regex TYPE string VALUE '''|\"'. "'''|\"'.
    LOOP AT  me->filter ASSIGNING <fs_filter>.
      SPLIT <fs_filter> AT space INTO wa_parameter-field wa_parameter-operator wa_parameter-value wa_parameter-logic.
      TRANSLATE wa_parameter-field TO UPPER CASE.
      WRITE wa_parameter-operator TO wa_parameter-operator CENTERED.
      WRITE wa_parameter-logic TO wa_parameter-logic CENTERED.
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN wa_parameter-value WITH ''.

      READ TABLE it_ddfields ASSIGNING <fs_ddfield> WITH KEY fieldname = wa_parameter-field.
      IF sy-subrc EQ 0.
        ASSIGN COMPONENT sy-tabix OF STRUCTURE <fsym_warea> TO <fsym_field>.
        IF sy-subrc = 0.
          <fsym_field> = wa_parameter-value.
        ELSE.
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
        ENDIF.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
      ENDIF.
    ENDLOOP.

* --- fill MANDT field
    READ TABLE it_ddfields ASSIGNING <fs_ddfield> WITH KEY fieldname = 'MANDT'.
    IF sy-subrc EQ 0.
      ASSIGN COMPONENT sy-tabix OF STRUCTURE <fsym_warea> TO <fsym_field>.
      IF sy-subrc = 0.
        <fsym_field> = sy-mandt.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
      ENDIF.
    ENDIF.

* --- all dynamic insert
    TRY.

        INSERT INTO (me->ddic_table) VALUES <fsym_warea>.

      CATCH cx_root.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDTRY.
  ENDMETHOD.