  METHOD prepare_collect_invoice.
    CONCATENATE
    '<soapenv:Envelope xmlns:akb="http://akbank.onlineBTS.org" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
   '<soapenv:Header/>'
    '<soapenv:Body>'
    '<akb:FaturaSorgula>'
    '<akb:queryParams>'
    '<akb:FirmaKodu>' ms_service_info-additional_field1 '</akb:FirmaKodu>'
    '<akb:AboneNo>' ms_subscribe-subscriber_number '</akb:AboneNo>'
    '<akb:FaturaNo>' ms_invoice_data-invoicenumber '</akb:FaturaNo>'
    '</akb:queryParams>'
    '</akb:FaturaSorgula>'
    '</soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.