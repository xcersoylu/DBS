  METHOD prepare_update_invoice.
    DATA lv_amount TYPE c LENGTH 30.
    lv_amount = ms_invoice_data-invoiceamount.
    CONDENSE lv_amount.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nan="http://nanopetdbs.driver.maestro.ibtech.com">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<nan:faturaGuncelleme>'
             '<!--Optional:-->'
             '<faturaGuncellemeSTI2Request>'
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
                '<sonOdemeTarihi>' ms_invoice_data-invoiceduedate '</sonOdemeTarihi>'
                '<!--Optional:-->'
                '<userName>' ms_service_info-username '</userName>'
             '</faturaGuncellemeSTI2Request>'
          '</nan:faturaGuncelleme>'
       '</soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.