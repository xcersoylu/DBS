  METHOD prepare_update_limit.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ykb="http://YKB.OnlineDbs.Webservice/">'
        '<soapenv:Header/>'
        '<soapenv:Body>'
            '<ykb:Limit_Sorgu>'
                '<!--Optional:-->'
                '<ykb:Urun>' ms_service_info-additional_field1 '</ykb:Urun>'
                '<!--Optional:-->'
                '<ykb:Kurum>' ms_service_info-additional_field2 '</ykb:Kurum>'
                '<!--Optional:-->'
                '<ykb:Aboneno>' ms_subscribe-subscriber_number '</ykb:Aboneno>'
                '<!--Optional:-->'
                '<ykb:Doviz>' ms_service_info-additional_field3 '</ykb:Doviz>'
            '</ykb:Limit_Sorgu>'
        '</soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.

  ENDMETHOD.