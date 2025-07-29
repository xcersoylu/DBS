  METHOD prepare_delete_invoice.
    DATA : lv_amount TYPE string.
    lv_amount = ms_invoice_data-invoiceamount.CONDENSE lv_amount.
    CONCATENATE
    '<soapenv:Envelope xmlns:akb="http://akbank.onlineBTS.org" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">'
   '<soapenv:Header/>'
    '<soapenv:Body>'
    '<akb:VadeliFaturaYukle>'
    '<akb:invoiceParams>'
    '<akb:FirmaKodu>' ms_service_info-additional_field1 '</akb:FirmaKodu>'
    '<akb:AboneNo>' ms_subscribe-subscriber_number '</akb:AboneNo>'
    '<akb:FaturaNo>' ms_invoice_data-invoicenumber '</akb:FaturaNo>'
    '<akb:Tutar>' lv_amount '</akb:Tutar>'
    '<akb:IslemTipi>' mc_deleted '</akb:IslemTipi>'
    '<akb:VadeTarihi>' ms_invoice_data-invoiceduedate '</akb:VadeTarihi>'
    '<akb:ParaBirimi>' ms_invoice_data-transactioncurrency '</akb:ParaBirimi>'
    '</akb:invoiceParams>'
    '</akb:VadeliFaturaYukle>'
    '</soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.