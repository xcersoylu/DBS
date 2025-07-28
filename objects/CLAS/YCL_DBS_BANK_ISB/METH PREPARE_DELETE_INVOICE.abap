  METHOD prepare_delete_invoice.
    DATA : lv_date TYPE c LENGTH 10.
    CONCATENATE ms_invoice_data-invoiceduedate(4) '-'
                ms_invoice_data-invoiceduedate+4(2) '-'
                ms_invoice_data-invoiceduedate+6(2)
    INTO lv_date.
    CONCATENATE
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://isbank.com/OpSvcs/PaymentMgmtProcessing/DDS/DDSGeneric/Service/V1" xmlns:v11="http://isbank.com/OpSvcs/PaymentMgmtProcessing/DDS/Core/Schema/V1">'
   '<soapenv:Header/>'
   '<soapenv:Body>'
      '<v1:deleteInvoice>'
         '<v1:invoiceKeyList>'
            '<v11:corporateCode>' ms_service_info-additional_field1 '</v11:corporateCode>'
            '<v11:subscriberCode>' ms_subscribe-subscriber_number '</v11:subscriberCode>'
            '<v11:invoiceNumber>' ms_invoice_data-invoicenumber '</v11:invoiceNumber>'
            '<v11:lastPaymentDate>' lv_date '</v11:lastPaymentDate>'
         '</v1:invoiceKeyList>'
      '</v1:deleteInvoice>'
   '</soapenv:Body>'
'</soapenv:Envelope>'
INTO rv_request.
  ENDMETHOD.