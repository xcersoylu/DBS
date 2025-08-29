  METHOD get_messageno.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = 'YDBS_MSGNO'
          IMPORTING
            number            = DATA(lv_msgno)
            returncode        = DATA(lv_returncode)
            returned_quantity = DATA(lv_returned_quantity)
        ).
        rv_messageno = lv_msgno.
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges.
    ENDTRY.
  ENDMETHOD.