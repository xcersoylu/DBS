  METHOD prepare_send_invoice.
    DATA lv_amount TYPE c LENGTH 30.
    lv_amount = ms_invoice_data-invoiceamount.
    CONDENSE lv_amount.
    CONCATENATE
  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nan="http://nanopetdbs.driver.maestro.ibtech.com">'
     '<soapenv:Header/>'
     '<soapenv:Body>'
        '<nan:faturaYukle>'
           '<!--Optional:-->'
           '<faturaYukleHYTKRequest>'
              '<!--Optional:-->'
              '<bayiReferans>' ms_subscribe-subscriber_number '</bayiReferans>'
              '<!--Optional:-->'
              '<dovizKodu>' ms_invoice_data-transactioncurrency '</dovizKodu>'
              '<!--Optional:-->'
              '<faturaNo>' ms_invoice_data-invoicenumber '</faturaNo>'
              '<!--Optional:-->'
              '<faturaTutari>' lv_amount '</faturaTutari>'
              '<!--Optional:-->'
              '<password>' ms_service_info-password '</password>'
              '<!--Optional:-->'
              '<tahakkukTarihi>' ms_invoice_data-documentdate '</tahakkukTarihi>'
              '<!--Optional:-->'
              '<userName>' ms_service_info-username '</userName>'
              '<!--Optional:-->'
              '<vadeTarihi>' ms_invoice_data-invoiceduedate '</vadeTarihi>'
           '</faturaYukleHYTKRequest>'
        '</nan:faturaYukle>'
     '</soapenv:Body>'
  '</soapenv:Envelope>' INTO rv_request.

  ENDMETHOD.