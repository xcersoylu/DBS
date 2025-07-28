  METHOD prepare_delete_invoice.
    CONCATENATE
  '{'
  '"faturaIptalRequest": {'
  '"Musteri_DBS_No": "' ms_subscribe-subscriber_number '",'
  '"Fatura_No": "' ms_invoice_data-invoicenumber '"'
  '}'
  '}' INTO rv_request.
  ENDMETHOD.