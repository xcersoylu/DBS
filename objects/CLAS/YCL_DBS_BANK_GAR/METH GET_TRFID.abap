  METHOD get_trfid.
*    TRY.
*        cl_numberrange_runtime=>number_get(
*          EXPORTING
*            nr_range_nr       = '01'
*            object            = 'YDBS_TRFID'
*          IMPORTING
*            number            = DATA(lv_trfid)
*            returncode        = DATA(lv_returncode)
*            returned_quantity = DATA(lv_returned_quantity)
*        ).
*        rv_trf_id = lv_trfid.
*      CATCH cx_nr_object_not_found.
*      CATCH cx_number_ranges.
*    ENDTRY.
    DATA(lv_date) = cl_abap_context_info=>get_system_date(  ).
    SELECT SINGLE id_number FROM ydbs_t_gar_ids WHERE id_type = 'T'
                                                  AND id_date = @lv_date
    INTO @DATA(lv_id_number).
    IF sy-subrc = 0.
      lv_id_number += 1.
      UPDATE ydbs_t_gar_ids
         SET id_number = @lv_id_number
       WHERE id_type = 'T'
         AND id_date = @lv_date.
    ELSE.
      lv_id_number += 1.
      INSERT ydbs_t_gar_ids FROM @( VALUE #( id_type = 'T' id_date = lv_date id_number = lv_id_number ) ).
    ENDIF.
    rv_trf_id = lv_date && lv_id_number.
  ENDMETHOD.