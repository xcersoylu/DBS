  METHOD get_batchid.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = 'YDBS_BATCH'
          IMPORTING
            number            = DATA(lv_batch)
            returncode        = DATA(lv_returncode)
            returned_quantity = DATA(lv_returned_quantity)
        ).
        rv_batch_id = lv_batch.
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges.
    ENDTRY.

  ENDMETHOD.