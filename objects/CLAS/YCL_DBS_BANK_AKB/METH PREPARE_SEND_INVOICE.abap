  METHOD prepare_send_invoice.
    DATA : lv_amount TYPE string,
           lv_send   TYPE c VALUE 'A',
           lv_bldat  TYPE c LENGTH 10.
    lv_amount = ms_invoice_data-invoiceamount.CONDENSE lv_amount.

    CONCATENATE ms_invoice_data-invoiceduedate+6(2) '.'
                ms_invoice_data-invoiceduedate+4(2) '.'
                ms_invoice_data-invoiceduedate(4)
       INTO lv_bldat.
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
        '<akb:IslemTipi>' lv_send '</akb:IslemTipi>'
        '<akb:VadeTarihi>' lv_bldat '</akb:VadeTarihi>'
        '<akb:ParaBirimi>' ms_invoice_data-transactioncurrency '</akb:ParaBirimi>'
        '</akb:invoiceParams>'
        '</akb:VadeliFaturaYukle>'
        '</soapenv:Body>'
        '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.