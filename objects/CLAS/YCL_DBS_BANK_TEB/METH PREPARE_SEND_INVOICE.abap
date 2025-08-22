  METHOD prepare_send_invoice.
    DATA : lv_amount TYPE string,
           lv_waers  TYPE waers,
           lv_vade   TYPE c LENGTH 10,
           lv_bldat  TYPE c LENGTH 10,
           lv_odeme_turu type c LENGTH 1. "P->Peşin V->Vadeli.

    lv_amount = ms_invoice_data-invoiceamount.
    CONDENSE lv_amount.

    IF ms_invoice_data-transactioncurrency EQ 'TRY'.
      lv_waers = 'TL'.
    ELSE.
      lv_waers = ms_invoice_data-transactioncurrency.
    ENDIF.

    CONCATENATE ms_invoice_data-invoiceduedate+6(2) '/'
                ms_invoice_data-invoiceduedate+4(2) '/'
                ms_invoice_data-invoiceduedate(4)
           INTO lv_vade.

    CONCATENATE ms_invoice_data-documentdate+6(2) '/'
                ms_invoice_data-documentdate+4(2) '/'
                ms_invoice_data-documentdate(4)
           INTO lv_bldat.
    if ms_invoice_data-documentdate = ms_invoice_data-invoiceduedate.
     lv_odeme_turu = 'P'.
    else.
    lv_odeme_turu = 'V'.
    endif.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:com="http://com.teb.tebdbs/">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<com:TEBDBSFaturaYukle>'
            '<com:kullaniciAdi>' ms_service_info-username '</com:kullaniciAdi>'
            '<com:sifre>' ms_service_info-password '</com:sifre>'
            '<com:anaFirma>' ms_service_info-additional_field1 '</com:anaFirma>'
            '<com:firmaMusteriNo>' ms_subscribe-subscriber_number '</com:firmaMusteriNo>'
            '<com:odemeTur>' lv_odeme_turu '</com:odemeTur>'
            '<com:faturaNo>' ms_invoice_data-invoicenumber '</com:faturaNo>'
            '<com:tutar>' lv_amount '</com:tutar>'
            '<com:paraKod>' lv_waers '</com:paraKod>'
            '<com:faturaVade>' lv_vade '</com:faturaVade>'
            '<com:faturaTarih>' lv_bldat '</com:faturaTarih>'
            '<com:taksitAdet> </com:taksitAdet>'
            '<com:mesajNo></com:mesajNo>'
            '<com:satisTmslBilgi></com:satisTmslBilgi>'
            '<com:aciklama></com:aciklama>'
          '</com:TEBDBSFaturaYukle>'
       '</soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.