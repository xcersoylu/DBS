  METHOD prepare_send_invoice.
    DATA lv_date TYPE c LENGTH 10.
    DATA lv_waers TYPE c LENGTH 3.
    DATA lv_amount TYPE string.
    CONCATENATE ms_invoice_data-invoiceduedate+6(2) '/'
                ms_invoice_data-invoiceduedate+4(2) '/'
                ms_invoice_data-invoiceduedate(4)
    INTO lv_date.
    IF ms_invoice_data-transactioncurrency = 'TRY'.
      lv_waers = 'TL'.
    ELSE.
      lv_waers = ms_invoice_data-transactioncurrency.
    ENDIF.
    lv_amount = ms_invoice_data-invoiceamount.CONDENSE lv_amount.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ykb="http://YKB.OnlineDbs.Webservice/">'
      '<soapenv:Header/>'
      '<soapenv:Body>'
        '<ykb:Taksit_Yarat>'
          '<ykb:Urun>' ms_service_info-additional_field1 '</ykb:Urun>'
          '<ykb:KurumKodu>' ms_service_info-additional_field2 '</ykb:KurumKodu>'
          '<ykb:Aboneno>' ms_subscribe-subscriber_number '</ykb:Aboneno>'
          '<ykb:BaslangicVade>' lv_date '</ykb:BaslangicVade>'
          '<ykb:BasFaturaNo>' ms_invoice_data-invoicenumber '</ykb:BasFaturaNo>'
          '<ykb:Doviz>' lv_waers '</ykb:Doviz>'
          '<ykb:TaksitAdedi>1</ykb:TaksitAdedi>'
          '<ykb:ToplamTutar>' lv_amount '</ykb:ToplamTutar>'
          '<ykb:TaksitPeriyod>1</ykb:TaksitPeriyod>'
          '<ykb:TaksitPeriyotBirimi>A</ykb:TaksitPeriyotBirimi>'
          '<ykb:Donem></ykb:Donem>'
          '<ykb:Unvan></ykb:Unvan>'
          '<ykb:Bilgi1></ykb:Bilgi1>'
          '<ykb:Bilgi2></ykb:Bilgi2>'
          '<ykb:Bilgi3></ykb:Bilgi3>'
          '<ykb:Bilgi4></ykb:Bilgi4>'
          '<ykb:Bilgi5></ykb:Bilgi5>'
        '</ykb:Taksit_Yarat>'
      '</soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.