  METHOD prepare_update_limit.
    CONCATENATE
      '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'
        '<soapenv:Header/>'
        '<soapenv:Body>'
           '<tem:LimitSorgulama>'
             '<tem:limitSorgu>'
                 '<tem:kullaniciAdi>' ms_service_info-username '</tem:kullaniciAdi>'
                 '<tem:sifre>' ms_service_info-password '</tem:sifre>'
                 '<tem:dbsNo>' ms_subscribe-subscriber_number '</tem:dbsNo>'
             '</tem:limitSorgu>'
           '</tem:LimitSorgulama>'
        '</soapenv:Body>'
       '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.