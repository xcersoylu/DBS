  METHOD get_batchid.
*    TRY.
*        cl_numberrange_runtime=>number_get(
*          EXPORTING
*            nr_range_nr       = '01'
*            object            = 'YDBS_BATCH'
*          IMPORTING
*            number            = DATA(lv_batch)
*            returncode        = DATA(lv_returncode)
*            returned_quantity = DATA(lv_returned_quantity)
*        ).
*        rv_batch_id = lv_batch.
*      CATCH cx_nr_object_not_found.
*      CATCH cx_number_ranges.
*    ENDTRY.
    DATA(lv_date) = cl_abap_context_info=>get_system_date(  ).
    SELECT SINGLE id_number FROM ydbs_t_gar_ids WHERE id_type = 'B'
                                                  AND id_date = @lv_date
    INTO @DATA(lv_id_number).
    IF sy-subrc = 0.
      lv_id_number += 1.
      UPDATE ydbs_t_gar_ids
         SET id_number = @lv_id_number
       WHERE id_type = 'B'
         AND id_date = @lv_date.
    ELSE.
      lv_id_number += 1.
      INSERT ydbs_t_gar_ids FROM @( VALUE #( id_type = 'B' id_date = lv_date id_number = lv_id_number ) ).
    ENDIF.
    rv_batch_id = lv_date && lv_id_number.
  ENDMETHOD.