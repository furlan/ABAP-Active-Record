  METHOD resultset_get_entity.
    
***************************************************************************
**** This method may be deleted in the future, so it wasn't refactored ****
***************************************************************************
    FIELD-SYMBOLS: <fs_filter> LIKE LINE OF me->parameters.

    DATA o_rowtype TYPE REF TO cl_abap_structdescr.
    o_rowtype ?= cl_abap_typedescr=>describe_by_name( me->ddic_table ).

    DATA ref_wa TYPE REF TO data.
    CREATE DATA ref_wa TYPE HANDLE o_rowtype.

    FIELD-SYMBOLS <fs_warea> TYPE any.
    ASSIGN ref_wa->* TO <fs_warea>.

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
    FIELD-SYMBOLS <fs_field> TYPE any.

    DATA: it_where  TYPE TABLE OF edpline.
    FIELD-SYMBOLS: <fs_where> TYPE edpline.

* --- parse parameters to WHERE and SET fields
    LOOP AT  me->parameters ASSIGNING <fs_filter> FROM 2.

      APPEND INITIAL LINE TO it_where ASSIGNING <fs_where>.
      <fs_where> = <fs_filter>.

      AT LAST.
        EXIT.
      ENDAT.

      CONCATENATE <fs_where> 'AND' INTO <fs_where> SEPARATED BY space.

    ENDLOOP.

* --- all dynamic retrieve
    TRY.

        SELECT SINGLE * FROM (me->ddic_table) INTO <fs_warea> WHERE (it_where).
        IF sy-subrc NE 0.
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception.
        ENDIF.

      CATCH cx_root.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDTRY.

* --- write oDATA output
    READ TABLE me->parameters ASSIGNING <fs_filter> INDEX 1.
    READ TABLE it_ddfields ASSIGNING <fs_ddfield> WITH KEY fieldname = <fs_filter>.
    ASSIGN COMPONENT  sy-tabix OF STRUCTURE <fs_warea> TO <fs_field>.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ELSE.
      er_entity-ddic_table = me->ddic_table.
      er_entity-field = <fs_ddfield>-fieldname.
      er_entity-value = <fs_field>.
      SHIFT er_entity-value LEFT DELETING LEADING space.
    ENDIF.

  ENDMETHOD.