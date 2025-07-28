  METHOD prepare_delete_invoice.
    CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ykb="http://YKB.OnlineDbs.Webservice/">'
        '<soapenv:Header/>'
        '<soapenv:Body>'
          '<ykb:Taksit_Iptal>'
            '<ykb:Urun>' ms_service_info-additional_field1  '</ykb:Urun>'
            '<ykb:Kurum>' ms_service_info-additional_field2  '</ykb:Kurum>'
            '<ykb:Aboneno>' ms_subscribe-subscriber_number '</ykb:Aboneno>'
            '<ykb:TksVade></ykb:TksVade>'
            '<ykb:TksFatNo>' ms_invoice_data-invoicenumber '</ykb:TksFatNo>'
          '</ykb:Taksit_Iptal>'
        '</soapenv:Body>'
      '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.