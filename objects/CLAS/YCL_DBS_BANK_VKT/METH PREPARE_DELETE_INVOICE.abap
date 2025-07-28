  METHOD prepare_delete_invoice.
    CONSTANTS lv_trantype TYPE string VALUE 'Delete'.
    DATA: lv_bldat   TYPE string,
          lv_duedate TYPE string,
          lv_amount  TYPE string.

    CONCATENATE ms_invoice_data-documentdate(4) '-'
                ms_invoice_data-documentdate+4(2) '-'
                ms_invoice_data-documentdate+6(2)
                INTO lv_bldat.
    CONCATENATE ms_invoice_data-invoiceduedate(4) '-'
                ms_invoice_data-invoiceduedate+4(2) '-'
                ms_invoice_data-invoiceduedate+6(2)
                INTO lv_duedate.

    lv_amount = ms_invoice_data-invoiceamount.CONDENSE lv_amount.

    CONCATENATE
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://boa.net/BOA.Integration.DirectFundUtilization/Service" xmlns:boa="http://schemas.datacontract.org/2004/07/BOA.Integration.Model.DirectFundUtilization">'
'<soapenv:Header/>'
'<soapenv:Body>'
'<ser:CreateInvoiceRecord>'
'<ser:userName>' ms_service_info-username '</ser:userName>'
'<ser:password>' ms_service_info-password '</ser:password>'
'<ser:entity>'
'<boa:Explanation></boa:Explanation>'
'<boa:InvoiceAmount>' lv_amount '</boa:InvoiceAmount>'
'<boa:InvoiceCurrencyCode>' ms_service_info-currency '</boa:InvoiceCurrencyCode>'
'<boa:InvoiceDate>' lv_bldat '</boa:InvoiceDate>'
'<boa:InvoiceNumber>' ms_invoice_data-invoicenumber '</boa:InvoiceNumber>'
'<boa:IsInvoiceLock>false</boa:IsInvoiceLock>'
'<boa:LastPaymentDate>' lv_duedate '</boa:LastPaymentDate>'
'<boa:MaturityType>Futures</boa:MaturityType>'
'<boa:OperationType>' lv_trantype '</boa:OperationType>'
'<boa:SubscriberNumber>' ms_subscribe-subscriber_number '</boa:SubscriberNumber>'
'</ser:entity>'
'</ser:CreateInvoiceRecord>'
'</soapenv:Body>'
'</soapenv:Envelope>'
  INTO rv_request.
  ENDMETHOD.