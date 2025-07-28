  METHOD prepare_update_limit.
    CONCATENATE
'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:akb="http://akbank.onlineBTS.org">'
   '<soapenv:Header/>'
   '<soapenv:Body>'
      '<akb:LimitSorgu>'
         '<akb:limitParams>'
            '<!--Optional:-->'
            '<akb:FirmaKodu>' ms_service_info-firm_code '</akb:FirmaKodu>'
            '<!--Optional:-->'
            '<akb:AboneNo>' ms_subscribe-subscriber_number '</akb:AboneNo>'
         '</akb:limitParams>'
      '</akb:LimitSorgu>'
   '</soapenv:Body>'
'</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.