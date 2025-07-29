  METHOD prepare_update_invoice.
    DATA lv_date TYPE c LENGTH 10.
    DATA lv_old_date TYPE c LENGTH 10.
    DATA lv_waers TYPE c LENGTH 3.
    DATA lv_amount TYPE string.
    IF ms_invoice_data-transactioncurrency = 'TRY'.
      lv_waers = 'TL'.
    ELSE.
      lv_waers = ms_invoice_data-transactioncurrency.
    ENDIF.
    lv_amount = ms_invoice_data-invoiceamount.CONDENSE lv_amount.
    CONCATENATE ms_invoice_data-invoiceduedate+6(2) '/'
                ms_invoice_data-invoiceduedate+4(2) '/'
                ms_invoice_data-invoiceduedate(4)
    INTO lv_date.
    DATA(ls_log) = get_log(  ).
    CONCATENATE ls_log-invoiceduedate+6(2) '/'
                ls_log-invoiceduedate+4(2) '/'
                ls_log-invoiceduedate(4)
    INTO lv_old_date.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ykb="http://YKB.OnlineDbs.Webservice/">'
      '<soapenv:Header/>'
      '<soapenv:Body>'
        '<ykb:Fatura_Guncelleme>'
          '<ykb:Urun>' ms_service_info-additional_field1 '</ykb:Urun>'
          '<ykb:Kurum>' ms_service_info-additional_field2 '</ykb:Kurum>'
          '<ykb:Aboneno>' ms_subscribe-subscriber_number '</ykb:Aboneno>'
          '<ykb:SonOdm>' lv_old_date '</ykb:SonOdm>'
          '<ykb:FaturaNo>' ms_invoice_data-invoicenumber '</ykb:FaturaNo>'
          '<ykb:NewVade>' lv_date '</ykb:NewVade>'
          '<ykb:NewFatNo>' ms_invoice_data-invoicenumber '</ykb:NewFatNo>'
          '<ykb:NewDoviz>' lv_waers '</ykb:NewDoviz>'
          '<ykb:NewTutar>' lv_amount '</ykb:NewTutar>'
          '<ykb:NewDonem></ykb:NewDonem>'
          '<ykb:NewUnvan></ykb:NewUnvan>'
          '<ykb:NewBilgi1></ykb:NewBilgi1>'
          '<ykb:NewBilgi2></ykb:NewBilgi2>'
          '<ykb:NewBilgi3></ykb:NewBilgi3>'
          '<ykb:NewBilgi4></ykb:NewBilgi4>'
          '<ykb:NewBilgi5></ykb:NewBilgi5>'
        '</ykb:Fatura_Guncelleme>'
      '</soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.