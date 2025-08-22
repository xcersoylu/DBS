  METHOD get_trfid.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = 'YDBS_TRFID'
          IMPORTING
            number            = DATA(lv_trfid)
            returncode        = DATA(lv_returncode)
            returned_quantity = DATA(lv_returned_quantity)
        ).
        rv_trf_id = lv_trfid.
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges.
    ENDTRY.
  ENDMETHOD.