  METHOD prepare_update_invoice.
    DATA : lv_amount TYPE string.
    DATA : lv_date TYPE c LENGTH 10.

    lv_amount = ms_invoice_data-invoiceamount.CONDENSE lv_amount.
    CONCATENATE ms_invoice_data-invoiceduedate(4) '-'
                ms_invoice_data-invoiceduedate+4(2) '-'
                ms_invoice_data-invoiceduedate+6(2)
    'T00:00:00' INTO lv_date.

    CONCATENATE
  '{'
  '"faturaDuzenleRequest":'
  '{'
  '"Musteri_DBS_No": "' ms_subscribe-subscriber_number '",'
  '"Fatura_No": "' ms_invoice_data-invoicenumber '",'
  '"Fatura_Tutari": ' lv_amount ','
  '"Aciklama": "' ms_subscribe-customer '",'
  '"Vade_Tarihi": "' lv_date '"'
  '}'
  '}' INTO rv_request.
  ENDMETHOD.