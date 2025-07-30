  METHOD prepare_delete_invoice.
    DATA: lv_payment_no TYPE string.

    SELECT SINGLE payment_no
      FROM ydbs_t_teb_pymno
      WHERE invoice_number EQ @ms_invoice_data-invoicenumber
      INTO @lv_payment_no.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:com="http://com.teb.tebdbs/">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<com:TEBDBSFaturaIptal>'
            '<com:kullaniciAdi>' ms_service_info-username '</com:kullaniciAdi>'
            '<com:sifre>' ms_service_info-password '</com:sifre>'
            '<com:anaFirma>' ms_service_info-additional_field1 '</com:anaFirma>'
            '<com:firmaMusteriNo>' ms_subscribe-subscriber_number '</com:firmaMusteriNo>'
            '<com:bankaOdemeNo>' lv_payment_no '</com:bankaOdemeNo>'
            '<com:mesajNo></com:mesajNo>'
            '<com:satisTmslBilgi></com:satisTmslBilgi>'
            '<com:aciklama></com:aciklama>'
          '</com:TEBDBSFaturaIptal>'
      ' </soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.