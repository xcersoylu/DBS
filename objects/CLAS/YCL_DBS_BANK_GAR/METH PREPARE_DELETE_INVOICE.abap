  METHOD prepare_delete_invoice.
    IF get_batch_header(  ) = 'X'.
      rv_request = get_dts_detail( iv_trftype = 'D' ).
    ELSE.
    ENDIF.
  ENDMETHOD.