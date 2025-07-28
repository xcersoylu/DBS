  METHOD prepare_update_invoice.
    CONSTANTS lv_proctype TYPE c VALUE 'U'.
    DATA: lv_amount TYPE string.
    DATA: lv_bldat TYPE c LENGTH 10.
    DATA: lv_duedat TYPE c LENGTH 10.
    lv_amount = ms_invoice_data-invoiceamount.CONDENSE lv_amount.
    CONCATENATE ms_invoice_data-documentdate(4) '-'
                ms_invoice_data-documentdate+4(2) '-'
                ms_invoice_data-documentdate+6(2)
       INTO lv_bldat.
    CONCATENATE ms_invoice_data-invoiceduedate(4) '-'
                ms_invoice_data-invoiceduedate+4(2) '-'
                ms_invoice_data-invoiceduedate+6(2)
           INTO lv_duedat.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'
    '<soapenv:Header/>'
    '<soapenv:Body>'
      '<tem:InvoiceOperations>'
        '<!--Optional:-->'
        '<tem:ServiceUserName>' ms_service_info-username '</tem:ServiceUserName>'
        '<!--Optional:-->'
        '<tem:ServiceUserPassword>' ms_service_info-password '</tem:ServiceUserPassword>'
        '<!--Optional:-->'
        '<tem:ProcessType>' lv_proctype '</tem:ProcessType>'
        '<!--Optional:-->'
        '<tem:InvoiceNumber>' ms_invoice_data-invoicenumber '</tem:InvoiceNumber>'
        '<!--Optional:-->'
        '<tem:InvoiceAmount>'  lv_amount '</tem:InvoiceAmount>'
        '<!--Optional:-->'
        '<tem:SubscriberNumber>' ms_subscribe-subscriber_number '</tem:SubscriberNumber>'
        '<!--Optional:-->'
        '<tem:InvoiceDate>' lv_bldat '</tem:InvoiceDate>'
        '<!--Optional:-->'
        '<tem:LastPaymentDate>' lv_duedat '</tem:LastPaymentDate>'
      '</tem:InvoiceOperations>'
    '</soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.