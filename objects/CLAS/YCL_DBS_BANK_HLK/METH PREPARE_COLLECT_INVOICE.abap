  METHOD prepare_collect_invoice.
    CONCATENATE
  '{'
  '"faturaIptalRequest": null,'
  '"faturaSorgulaRequest": {'
  '"Musteri_DBS_No": "' ms_subscribe-subscriber_number '",'
  '"Fatura_No": "' ms_invoice_data-invoicenumber '",'
  '"Fatura_Baslangic_Tarihi": null,'
  '"Fatura_Bitis_Tarihi": null,'
  "24.01.2024 - fatura no gönderildiği için vade tarihine gerek yok, kaldırıldı
*** '"Vade_Baslangic_Tarihi": "' lv_bdate '",'
*** '"Vade_Bitis_Tarihi": "' lv_edate '"'
  '"Vade_Baslangic_Tarihi": null,'
  '"Vade_Bitis_Tarihi": null'
  "24.01.2024
  '},'
  '"faturaYukleRequest": null,'
  '"limitSorgulaRequest": null'
  '}' INTO rv_request.
  ENDMETHOD.