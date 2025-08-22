  METHOD prepare_send_invoice.
    IF get_batch_header(  ) = 'X'.
      rv_request = get_dts_detail( iv_trftype = 'A' ).
    ELSE.
    ENDIF.
  ENDMETHOD.