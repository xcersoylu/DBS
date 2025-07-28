  METHOD prepare_update_invoice.
    DATA : lv_amount      TYPE string,
           lv_date        TYPE c LENGTH 10,
           lv_sendingdate TYPE c LENGTH 10,
           lv_waers       TYPE c LENGTH 3.
    lv_amount = ms_invoice_data-invoiceamount.CONDENSE lv_amount.
    IF ms_invoice_data-transactioncurrency EQ 'TRY'.
      lv_waers = 'TL'.
    ELSE.
      lv_waers = ms_invoice_data-transactioncurrency.
    ENDIF.

    CONCATENATE ms_invoice_data-invoiceduedate+6(2) '.'
                ms_invoice_data-invoiceduedate+4(2) '.'
                ms_invoice_data-invoiceduedate(4)
       INTO lv_date.
    DATA(lv_datum) = cl_abap_context_info=>get_system_date(  ).
    CONCATENATE lv_datum+6(2) '.' lv_datum+4(2) '.' lv_datum(4)
    INTO lv_sendingdate.
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
    '<BaseKurumOperasyon>YukleFatura</BaseKurumOperasyon>'
    '<BaseBinlikAyrac></BaseBinlikAyrac>'
    '<BaseOndalikAyrac>.</BaseOndalikAyrac>'
    '<BaseInputData>'
      '<DTOFatura>'
                           '<AnaFirmaKurumUrunTanimId>' ms_service_info-additional_field2 '</AnaFirmaKurumUrunTanimId>'
                           '<AnaFirmadakiBayiKodu>' ms_subscribe-subscriber_number '</AnaFirmadakiBayiKodu>'
        '<OperasyonTuru>' '200' '</OperasyonTuru>'
        '<FaturaNo>' ms_invoice_data-invoicenumber'</FaturaNo>'
        '<FaturaTutari>' lv_amount '</FaturaTutari>'
        '<DovizCinsi>' lv_waers '</DovizCinsi>'
        '<AdSoyad></AdSoyad>'
        '<SonOdemeTarihi>' lv_date '</SonOdemeTarihi>'
        '<PesinVadeliDurumu>1</PesinVadeliDurumu>'
        '<Aciklama></Aciklama>'
        '<FaturaCikisTarihi>' lv_sendingdate '</FaturaCikisTarihi>'
        '<ReferansAlan6></ReferansAlan6>'
        '<ReferansAlan7></ReferansAlan7>'
        '<ReferansAlan8></ReferansAlan8>'
        '<ReferansAlan9></ReferansAlan9>'
        '<ReferansAlan10></ReferansAlan10>'
      '</DTOFatura>'
    '</BaseInputData>'
  '</BaseInput>'
   ']]>'
            '</tem:baseInputData>'
            '</tem:Kurum_OnlineKEK>'
         '</soapenv:Body>' INTO rv_request.
  ENDMETHOD.