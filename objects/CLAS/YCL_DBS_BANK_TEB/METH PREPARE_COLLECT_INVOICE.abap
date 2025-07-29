  METHOD prepare_collect_invoice.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:com="http://com.teb.tebdbs/">'
    '<soapenv:Header/>'
    '<soapenv:Body>'
    '<com:TEBDBSFaturaAkibetSorguV2>'
    '<com:kullaniciAdi>' ms_service_info-username '</com:kullaniciAdi>'
    '<com:sifre>' ms_service_info-password '</com:sifre>'
    '<com:anaFirma>' ms_service_info-additional_field1 '</com:anaFirma>'
    '<com:firmaMusteriNo>' ms_subscribe-subscriber_number '</com:firmaMusteriNo>'
    '<com:faturaNo>' ms_invoice_data-invoicenumber '</com:faturaNo>'
    '<com:tutar></com:tutar>'
    '<com:paraKod></com:paraKod>'
    '<com:faturaVade></com:faturaVade>'
    '<com:satisTmslBilgi></com:satisTmslBilgi>'
    '</com:TEBDBSFaturaAkibetSorguV2>'
    '</soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.

  ENDMETHOD.