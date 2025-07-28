  METHOD prepare_collect_invoice.
    DATA : lv_amount TYPE string,
           lv_bdate  TYPE c LENGTH 10,
           lv_edate  TYPE c LENGTH 10,
           lv_waers  TYPE c LENGTH 3.
    IF ms_invoice_data-transactioncurrency EQ 'TRY'.
      lv_waers = 'TL'.
    ELSE.
      lv_waers = ms_invoice_data-transactioncurrency.
    ENDIF.

    CONCATENATE ms_invoice_data-invoiceduedate+6(2) '.'
                ms_invoice_data-invoiceduedate+4(2) '.'
                ms_invoice_data-invoiceduedate(4)
       INTO lv_bdate.
    lv_edate = lv_bdate.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<tem:Kurum_OnlineKEK>'
             '<!--Optional:-->'
             '<tem:baseInputData>'
             '<![CDATA['
'<BaseInput>'
                   '<BaseMusteriNo>' ms_service_info-additional_field1 '</BaseMusteriNo>'
                   '<BaseKurumKodu>' ms_service_info-additional_field2 '</BaseKurumKodu>'
                   '<BaseKurumKullanici>' ms_service_info-username '</BaseKurumKullanici>'
                   '<BaseKurumSifre>' ms_service_info-password '</BaseKurumSifre>'
    '<BaseKurumOperasyon>SorgulaOnlineFatura</BaseKurumOperasyon>'
    '<BaseBinlikAyrac></BaseBinlikAyrac>'
    '<BaseOndalikAyrac>.</BaseOndalikAyrac>'
    '<BaseInputData>'
    '<DTOAkibetIstek>'
                           '<AnaFirmaKurumUrunTanimId>' ms_service_info-additional_field2 '</AnaFirmaKurumUrunTanimId>'
                           '<AnaFirmadakiBayiKodu>' ms_subscribe-subscriber_number '</AnaFirmadakiBayiKodu>'
        '<BaslangicTarihi>' lv_bdate '</BaslangicTarihi>'
        '<BitisTarihi>' lv_edate '</BitisTarihi>'
        '<DovizCinsi>' lv_waers '</DovizCinsi>'
        '<SorguTuru>1</SorguTuru>'
    '</DTOAkibetIstek>'
    '</BaseInputData>'
'</BaseInput>'
 ']]>'
          '</tem:baseInputData>'
          '</tem:Kurum_OnlineKEK>'
       '</soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.