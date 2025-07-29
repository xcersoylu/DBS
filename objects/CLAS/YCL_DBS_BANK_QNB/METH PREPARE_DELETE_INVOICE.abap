  METHOD prepare_delete_invoice.
    CONCATENATE
  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nan="http://nanopetdbs.driver.maestro.ibtech.com">'
     '<soapenv:Header/>'
     '<soapenv:Body>'
        '<nan:faturaIptal>'
           '<!--Optional:-->'
           '<vadeliBorcIptalRequest>'
              '<!--Optional:-->'
              '<bayiReferans>' ms_subscribe-subscriber_number '</bayiReferans>'
              '<!--Optional:-->'
              '<dovizKodu>' ms_invoice_data-transactioncurrency '</dovizKodu>'
              '<!--Optional:-->'
              '<faturaNo>' ms_invoice_data-invoicenumber '</faturaNo>'
              '<!--Optional:-->'
              '<password>' ms_service_info-password '</password>'
              '<!--Optional:-->'
              '<userName>' ms_service_info-username '</userName>'
           '</vadeliBorcIptalRequest>'
        '</nan:faturaIptal>'
     '</soapenv:Body>'
  '</soapenv:Envelope>' INTO rv_request.

  ENDMETHOD.