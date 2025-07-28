  METHOD prepare_collect_invoice.
    DATA lv_startdate TYPE c LENGTH 10.
    DATA lv_enddate TYPE c LENGTH 10.
    CONCATENATE ms_invoice_data-invoiceduedate+6(2) '/'
                ms_invoice_data-invoiceduedate+4(2) '/'
                ms_invoice_data-invoiceduedate(4)
    INTO lv_startdate.
    lv_enddate = lv_startdate.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ykb="http://YKB.OnlineDbs.Webservice/">'
      '<soapenv:Header/>'
      '<soapenv:Body>'
        '<ykb:Fatura_Bilgisi>'
          '<ykb:Urun>' ms_service_info-additional_field1 '</ykb:Urun>'
          '<ykb:Kurum>' ms_service_info-additional_field2  '</ykb:Kurum>'
          '<ykb:DosyaTip>' ms_service_info-additional_field3  '</ykb:DosyaTip>'
          '<ykb:BasTrh>' lv_startdate '</ykb:BasTrh>'
          '<ykb:BitTrh>' lv_enddate '</ykb:BitTrh>'
        '</ykb:Fatura_Bilgisi>'
      '</soapenv:Body>'
    '</soap:Envelope>' INTO rv_request.
  ENDMETHOD.