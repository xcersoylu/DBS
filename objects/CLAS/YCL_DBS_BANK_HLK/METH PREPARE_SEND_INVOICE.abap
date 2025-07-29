  METHOD prepare_send_invoice.
    DATA : lv_amount   TYPE string.
    DATA : lv_bldat TYPE c LENGTH 10.
    DATA : lv_date  TYPE c LENGTH 10.
    lv_amount = ms_invoice_data-invoiceamount. CONDENSE lv_amount.
    CONCATENATE ms_invoice_data-documentdate(4) '-'
                ms_invoice_data-documentdate+4(2) '-'
                ms_invoice_data-documentdate+6(2)
    'T00:00:00' INTO lv_bldat.
    CONCATENATE ms_invoice_data-invoiceduedate(4) '-'
                ms_invoice_data-invoiceduedate+4(2) '-'
                ms_invoice_data-invoiceduedate+6(2)
    'T00:00:00' INTO lv_date.

    CONCATENATE
  '{'
  '"faturaYukleRequest": {'
  '"Musteri_DBS_No": "' ms_subscribe-subscriber_number '",'
  '"Fatura_No": "' ms_invoice_data-invoicenumber '",'
  '"Fatura_Tarihi": "' lv_bldat '",'
  '"Fatura_Tutari":' lv_amount ','
  '"Para_Birimi": "' ms_invoice_data-transactioncurrency '",'
  '"Aciklama": "' ms_subscribe-customer '",'
  '"Vade_Tarihi": "' lv_date '"'
  '}'
  '}' INTO rv_request.
  ENDMETHOD.