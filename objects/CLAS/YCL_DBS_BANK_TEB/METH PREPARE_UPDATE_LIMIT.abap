  METHOD prepare_update_limit.
    CONCATENATE
  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:com="http://com.teb.tebdbs/">'
  '<soapenv:Header/>'
  '<soapenv:Body>'
  '<com:TEBDBSLimitSorgula>'
  '<com:kullaniciAdi>' ms_service_info-username '</com:kullaniciAdi>'
  '<com:sifre>' ms_service_info-password '</com:sifre>'
  '<com:anaFirma>' ms_service_info-additional_field1 '</com:anaFirma>'
  '<com:firmaMusteriNo>' ms_subscribe-subscriber_number '</com:firmaMusteriNo>'
  '<com:satisTmslBilgi></com:satisTmslBilgi>'
  '</com:TEBDBSLimitSorgula>'
  '</soapenv:Body>'
  '</soapenv:Envelope>' INTO rv_request.


  ENDMETHOD.