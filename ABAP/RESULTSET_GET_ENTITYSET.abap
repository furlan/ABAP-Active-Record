  METHOD resultset_get_entityset.

    FIELD-SYMBOLS: <fs_entity> LIKE LINE OF et_entityset.
    FIELD-SYMBOLS: <fs_filter> LIKE LINE OF me->filter.

    DATA: it_fields TYPE TABLE OF edpline,
          it_where  TYPE TABLE OF edpline.
    FIELD-SYMBOLS: <fs_parameter> TYPE edpline.

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
      FIND 'EQ' IN <fs_filter>.
      IF sy-subrc EQ 0. " WHERE condition
        APPEND INITIAL LINE TO it_where ASSIGNING <fs_parameter>.
      ELSE. " FIELDS
        APPEND INITIAL LINE TO it_fields ASSIGNING <fs_parameter>.
      ENDIF.
      IF <fs_parameter> IS ASSIGNED.
        <fs_parameter> = <fs_filter>.
      ENDIF.
    ENDLOOP.

    " Get the structure of the table.
    ref_table_des ?= cl_abap_typedescr=>describe_by_name( me->model ).
    idetails[] = ref_table_des->components[].
    LOOP AT idetails INTO xdetails.
      " only necessary fields
      READ TABLE it_fields WITH KEY table_line = xdetails-name TRANSPORTING NO FIELDS.
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

* --- all dynamic retrieve
    TRY.
        SELECT (it_fields)
        INTO TABLE <dyn_table>
        FROM (me->model)
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
          <fs_entity>-model = me->model.

          READ TABLE it_fields ASSIGNING <fs_parameter> INDEX lv_index.
          CHECK sy-subrc EQ 0.

          <fs_entity>-field = <fs_parameter>.
          WRITE <dyn_field> TO <fs_entity>-value LEFT-JUSTIFIED.
        ENDIF.
      ENDDO.
    ENDLOOP.

  ENDMETHOD.