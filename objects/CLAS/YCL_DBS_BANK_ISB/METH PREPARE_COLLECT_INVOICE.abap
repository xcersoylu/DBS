  METHOD prepare_collect_invoice.
    DATA : lv_bdate TYPE c LENGTH 10.
    DATA : lv_edate TYPE c LENGTH 10.

    CONCATENATE ms_invoice_data-invoiceduedate(4) '-'
                ms_invoice_data-invoiceduedate+4(2) '-'
                ms_invoice_data-invoiceduedate+6(2)
    INTO lv_bdate.
    CONCATENATE ms_invoice_data-invoiceduedate(4) '-'
                ms_invoice_data-invoiceduedate+4(2) '-'
                ms_invoice_data-invoiceduedate+6(2)
    INTO lv_edate.


    CONCATENATE
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://isbank.com/OpSvcs/PaymentMgmtProcessing/DDS/DDSGeneric/Service/V1" xmlns:v11="http://isbank.com/OpSvcs/PaymentMgmtProcessing/DDS/Core/Schema/V1">'
   '<soapenv:Header/>'
   '<soapenv:Body>'
      '<v1:retrieveInvoiceList>'
         '<v1:corporateCode>' ms_service_info-additional_field1 '</v1:corporateCode>'
         '<v1:subscriberCodeList>' ms_subscribe-subscriber_number '</v1:subscriberCodeList>'
         '<v1:dateType>P</v1:dateType>'
         '<v1:startDate>' lv_bdate '</v1:startDate>'
         '<v1:endDate>' lv_edate '</v1:endDate>'
         '<v1:invoiceNumber>' ms_invoice_data-invoicenumber '</v1:invoiceNumber>'
         '<v1:InvoiceType>O</v1:InvoiceType>'
      '</v1:retrieveInvoiceList>'
   '</soapenv:Body>'
'</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.