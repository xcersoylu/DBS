  METHOD prepare_send_invoice.
    DATA : lv_amount   TYPE string.
    DATA : lv_date  TYPE c LENGTH 10.
    DATA : lv_bldat TYPE c LENGTH 10.
    lv_amount = ms_invoice_data-invoiceamount.CONDENSE lv_amount.
    CONCATENATE ms_invoice_data-invoiceduedate(4) '-'
                ms_invoice_data-invoiceduedate+4(2) '-'
                ms_invoice_data-invoiceduedate+6(2)
    INTO lv_date.
    CONCATENATE ms_invoice_data-documentdate(4) '-'
                ms_invoice_data-documentdate+4(2) '-'
                ms_invoice_data-documentdate+6(2)
    INTO lv_bldat.

    CONCATENATE
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://isbank.com/OpSvcs/PaymentMgmtProcessing/DDS/DDSGeneric/Service/V1" xmlns:v11="http://isbank.com/OpSvcs/PaymentMgmtProcessing/DDS/Core/Schema/V1">'
   '<soapenv:Header/>'
   '<soapenv:Body>'
      '<v1:createInvoice>'
         '<v1:invoiceList>'
            '<v11:corporateCode>' ms_service_info-additional_field1 '</v11:corporateCode>'
            '<v11:subscriberCode>' ms_subscribe-subscriber_number '</v11:subscriberCode>'
            '<v11:invoiceNumber>' ms_invoice_data-invoicenumber '</v11:invoiceNumber>'
            '<v11:lastPaymentDate>' lv_date '</v11:lastPaymentDate>'
            '<v11:invoiceAmount>'
               '<v11:amount>' lv_amount '</v11:amount>'
               '<v11:currencyCode>' ms_invoice_data-transactioncurrency '</v11:currencyCode>'
            '</v11:invoiceAmount>'
            '<v11:collectionType>V</v11:collectionType>'
            '<!--Optional:-->'
            '<v11:invoiceDate>' lv_bldat '</v11:invoiceDate>'
            '<!--Optional:-->'
            '<v11:invoiceType>O</v11:invoiceType>'
         '</v1:invoiceList>'
      '</v1:createInvoice>'
   '</soapenv:Body>'
'</soapenv:Envelope>'
INTO rv_request.
  ENDMETHOD.