  METHOD prepare_update_invoice.

    DATA: lv_payment_no TYPE string,
          lv_waers      TYPE waers,
          lv_new_vade   TYPE c LENGTH 10,
          lv_old_vade   TYPE c LENGTH 10,
          lv_bldat      TYPE c LENGTH 10,
          lv_old_amount TYPE c LENGTH 100,
          lv_new_amount TYPE c LENGTH 100.

    SELECT SINGLE payment_no
      FROM ydbs_t_teb_pymno
      WHERE invoice_number EQ @ms_invoice_data-invoicenumber
      INTO @lv_payment_no.

    DATA(ls_log) = get_log(  ).
    lv_old_amount = ls_log-invoiceamount.
    lv_new_amount = ms_invoice_data-invoiceamount.
    CONDENSE: lv_old_amount, lv_new_amount.

    IF ms_invoice_data-transactioncurrency EQ 'TRY'.
      lv_waers = 'TL'.
    ELSE.
      lv_waers = ms_invoice_data-transactioncurrency.
    ENDIF.

    CONCATENATE ms_invoice_data-invoiceduedate+6(2) '/'
                ms_invoice_data-invoiceduedate+4(2) '/'
                ms_invoice_data-invoiceduedate+4
           INTO lv_new_vade.

    CONCATENATE ls_log-invoiceduedate+6(2) '/'
                ls_log-invoiceduedate+4(2) '/'
                ls_log-invoiceduedate+4
           INTO lv_old_vade.

    CONCATENATE ms_invoice_data-documentdate+6(2) '/'
                ms_invoice_data-documentdate+4(2) '/'
                ms_invoice_data-documentdate+4
           INTO lv_bldat.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:com="http://com.teb.tebdbs/">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<com:TEBDBSFaturaDuzeltme>'
            '<com:kullaniciAdi>' ms_service_info-username '</com:kullaniciAdi>'
            '<com:sifre>' ms_service_info-password '</com:sifre>'
            '<com:anaFirma>' ms_service_info-additional_field1 '</com:anaFirma>'
            '<com:firmaMusteriNo>' ms_subscribe-subscriber_number '</com:firmaMusteriNo>'
            '<com:bankaOdemeNoOrj>' lv_payment_no '</com:bankaOdemeNoOrj>'
            '<com:faturaNo>' ms_invoice_data-invoicenumber '</com:faturaNo>'
            '<com:eskiTutar>' lv_old_amount '</com:eskiTutar>'
            '<com:yeniTutar>' lv_new_amount '</com:yeniTutar>'
            '<com:paraKod>' lv_waers '</com:paraKod>'
            '<com:eskiFaturaVade>' lv_old_vade '</com:eskiFaturaVade>'
            '<com:yeniFaturaVade>' lv_new_vade '</com:yeniFaturaVade>'
            '<com:faturaTarih>' lv_bldat '</com:faturaTarih>'
            '<com:mesajNo></com:mesajNo>'
            '<com:aciklama></com:aciklama>'
          '</com:TEBDBSFaturaDuzeltme>'
       '</soapenv:Body>'
    '</soapenv:Envelope>'  INTO rv_request.


  ENDMETHOD.