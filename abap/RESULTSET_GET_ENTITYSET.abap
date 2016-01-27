  METHOD resultset_get_entityset.

    TYPE-POOLS : abap.

* --- get fields to be retrieved.
    DATA it_fields TYPE ty_t_parse_parameter.
    it_fields = me->get_fields_list( ).

* --- get WHERE conditions.
    DATA it_where TYPE ty_t_parse_parameter.
    it_where = get_where_conditions( ).

* --- Get the structure of the table.
    FIELD-SYMBOLS: <dyn_table> TYPE STANDARD TABLE.
    DATA dy_table TYPE REF TO data.

    dy_table = me->itab_factory( ).
    ASSIGN dy_table->* TO <dyn_table>.

*--- Create dynamic work area and assign to FS
    DATA dy_line  TYPE REF TO data.
    CREATE DATA dy_line LIKE LINE OF <dyn_table>.

    FIELD-SYMBOLS <dyn_wa>  TYPE any.
    ASSIGN dy_line->* TO <dyn_wa>.

* --- all dynamic retrieve
    TRY.
        SELECT (it_fields)
        INTO TABLE <dyn_table>
        FROM (me->ddic_table)
        WHERE (it_where).
      CATCH cx_root.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDTRY.

* --- write oDATA output
    DATA: lv_index TYPE i.
    FIELD-SYMBOLS <fs_entity> LIKE LINE OF et_entityset.
    FIELD-SYMBOLS <dyn_field> TYPE any.
    FIELD-SYMBOLS <fs_field> LIKE LINE OF it_fields.
    LOOP AT <dyn_table> INTO <dyn_wa>.
      DO.
        lv_index = sy-index.
        ASSIGN COMPONENT  sy-index
           OF STRUCTURE <dyn_wa> TO <dyn_field>.
        IF sy-subrc <> 0.
          EXIT.
        ELSE.
          APPEND INITIAL LINE TO et_entityset ASSIGNING <fs_entity>.
          <fs_entity>-ddic_table = me->ddic_table.

          READ TABLE it_fields ASSIGNING <fs_field> INDEX lv_index.
          CHECK sy-subrc EQ 0.

          <fs_entity>-field = <fs_field>-field.
          WRITE <dyn_field> TO <fs_entity>-value LEFT-JUSTIFIED.
        ENDIF.
      ENDDO.
    ENDLOOP.

  ENDMETHOD.