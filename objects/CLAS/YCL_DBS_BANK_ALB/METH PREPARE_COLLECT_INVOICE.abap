  METHOD prepare_collect_invoice.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'
    '<soapenv:Header/>'
    '<soapenv:Body>'
      '<tem:GetInvoiceInfo>'
        '<!--Optional:-->'
        '<tem:ServiceUserName>' ms_service_info-username '</tem:ServiceUserName>'
        '<!--Optional:-->'
        '<tem:ServiceUserPassword>' ms_service_info-password '</tem:ServiceUserPassword>'
        '<!--Optional:-->'
        '<tem:SubscriberNumber>' ms_subscribe-subscriber_number '</tem:SubscriberNumber>'
        '<!--Optional:-->'
 '<tem:InvoiceNumber>' ms_invoice_data-invoicenumber '</tem:InvoiceNumber>'
      '</tem:GetInvoiceInfo>'
    '</soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.