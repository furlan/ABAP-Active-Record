  METHOD resultset_update_entity.

* --- get work area filled according to parameters list.
    DATA ref_wa TYPE REF TO data.
    ref_wa = me->get_filled_workarea( ).
    FIELD-SYMBOLS <fs_warea> TYPE any.
    ASSIGN ref_wa->* TO <fs_warea>.

* --- all dynamic update
    TRY.

        UPDATE (me->ddic_table) FROM <fs_warea>.

      CATCH cx_root.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDTRY.

  ENDMETHOD.