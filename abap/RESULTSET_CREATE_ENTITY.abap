  METHOD resultset_create_entity.

* --- get work area filled according to parameters list.
    DATA ref_wa TYPE REF TO data.
    ref_wa = me->get_filled_workarea( ).
    FIELD-SYMBOLS <fs_warea> TYPE any.
    ASSIGN ref_wa->* TO <fs_warea>.

* --- all dynamic insert
    TRY.

        INSERT INTO (me->ddic_table) VALUES <fs_warea>.

      CATCH cx_root.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
    ENDTRY.
  ENDMETHOD.