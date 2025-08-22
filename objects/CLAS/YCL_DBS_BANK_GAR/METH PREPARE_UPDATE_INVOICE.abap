  METHOD prepare_update_invoice.
    IF get_batch_header(  ) = 'X'.
      rv_request = get_dts_detail( iv_trftype = 'M' ).
    ELSE.
    ENDIF.
  ENDMETHOD.