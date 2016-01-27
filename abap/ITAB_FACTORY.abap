  METHOD itab_factory.

* --- get fields to be retrieved.
    DATA it_fields TYPE ty_t_parse_parameter.
    it_fields = me->get_fields_list( ).

* --- Get the structure of the table.
    DATA : ref_table_des TYPE REF TO cl_abap_structdescr.
    ref_table_des ?= cl_abap_typedescr=>describe_by_name( me->ddic_table ).

    DATA idetails TYPE abap_compdescr_tab.
    idetails[] = ref_table_des->components[].

    DATA xdetails TYPE abap_compdescr.
    FIELD-SYMBOLS: <fs_fcat> TYPE lvc_s_fcat.
    DATA it_fcat TYPE lvc_t_fcat.

    LOOP AT idetails INTO xdetails.
      " add only necessary fields
      READ TABLE it_fields WITH KEY field = xdetails-name TRANSPORTING NO FIELDS.
      CHECK sy-subrc EQ 0.
      APPEND INITIAL LINE TO it_fcat ASSIGNING <fs_fcat>.
      <fs_fcat>-fieldname = xdetails-name .
      <fs_fcat>-datatype = xdetails-type_kind.
      <fs_fcat>-inttype = xdetails-type_kind.
      <fs_fcat>-intlen = xdetails-length.
      <fs_fcat>-decimals = xdetails-decimals.
    ENDLOOP.


    DATA: dy_table TYPE REF TO data.
    " Create dynamic internal table and assign to FS
    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = it_fcat
      IMPORTING
        ep_table        = re_ref_table.

  ENDMETHOD.