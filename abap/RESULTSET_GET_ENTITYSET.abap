  METHOD resultset_get_entityset.

    FIELD-SYMBOLS: <fs_entity> LIKE LINE OF et_entityset.
    FIELD-SYMBOLS: <fs_filter> LIKE LINE OF me->filter.

    TYPES: BEGIN OF lty_parameter,
             field    TYPE c LENGTH 30,
             operator TYPE c LENGTH 4,
             value    TYPE c LENGTH 100,
             logic    TYPE c LENGTH 4,
           END OF lty_parameter.

    DATA: it_fields TYPE TABLE OF lty_parameter,
          it_where  TYPE TABLE OF lty_parameter.
    FIELD-SYMBOLS: <fs_parameter> TYPE lty_parameter.
    DATA: wa_parameter TYPE lty_parameter.

    TYPE-POOLS : abap.
    FIELD-SYMBOLS: <dyn_table> TYPE STANDARD TABLE,
                   <dyn_wa>    TYPE any,
                   <dyn_field> TYPE any.
    DATA: dy_table TYPE REF TO data,
          dy_line  TYPE REF TO data,
          xfc      TYPE lvc_s_fcat,
          ifc      TYPE lvc_t_fcat.

    DATA : idetails TYPE abap_compdescr_tab,
           xdetails TYPE abap_compdescr.
    DATA : ref_table_des TYPE REF TO cl_abap_structdescr.

* --- parse parameters
    LOOP AT  me->filter ASSIGNING <fs_filter>.
      SPLIT <fs_filter> AT space INTO wa_parameter-field wa_parameter-operator wa_parameter-value wa_parameter-logic.

      IF wa_parameter-operator IS NOT INITIAL. " WHERE condition
        WRITE wa_parameter-operator TO wa_parameter-operator CENTERED.
        WRITE wa_parameter-logic TO wa_parameter-logic CENTERED.
        APPEND wa_parameter TO it_where.
      ELSE. " FIELDS
        APPEND wa_parameter TO it_fields.
      ENDIF.
    ENDLOOP.

    " Get the structure of the table.
    ref_table_des ?= cl_abap_typedescr=>describe_by_name( me->ddic_table ).
    idetails[] = ref_table_des->components[].

    LOOP AT idetails INTO xdetails.
      " only necessary fields
      READ TABLE it_fields WITH KEY field = xdetails-name TRANSPORTING NO FIELDS.
      CHECK sy-subrc EQ 0.
      CLEAR xfc.
      xfc-fieldname = xdetails-name .
      xfc-datatype = xdetails-type_kind.
      xfc-inttype = xdetails-type_kind.
      xfc-intlen = xdetails-length.
      xfc-decimals = xdetails-decimals.
      APPEND xfc TO ifc.
    ENDLOOP.

    " Create dynamic internal table and assign to FS
    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = ifc
      IMPORTING
        ep_table        = dy_table.
    ASSIGN dy_table->* TO <dyn_table>.

    " Create dynamic work area and assign to FS
    CREATE DATA dy_line LIKE LINE OF <dyn_table>.
    ASSIGN dy_line->* TO <dyn_wa>.

* --- check logic conditions for WHERE clause
    LOOP AT it_where ASSIGNING <fs_parameter>.
      IF <fs_parameter>-logic IS INITIAL.
        WRITE 'AND' TO <fs_parameter>-logic CENTERED.
      ENDIF.
      AT LAST.
        CLEAR <fs_parameter>-logic.
      ENDAT.
    ENDLOOP.

* --- all dynamic retrieve
    TRY.
        SELECT (it_fields)
        INTO TABLE <dyn_table>
        FROM (me->ddic_table)
        WHERE (it_where).
      CATCH cx_root.

    ENDTRY.

* --- write oDATA output
    DATA: lv_index TYPE i.
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

          READ TABLE it_fields ASSIGNING <fs_parameter> INDEX lv_index.
          CHECK sy-subrc EQ 0.

          <fs_entity>-field = <fs_parameter>.
          WRITE <dyn_field> TO <fs_entity>-value LEFT-JUSTIFIED.
        ENDIF.
      ENDDO.
    ENDLOOP.

  ENDMETHOD.