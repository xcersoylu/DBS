  METHOD prepare_update_limit.
    CONCATENATE
  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nan="http://nanopetdbs.driver.maestro.ibtech.com">'
      '<soapenv:Header/>'
      '<soapenv:Body>'
          '<nan:limitSorgula>'
              '<!--Optional:-->'
              '<limitSorgulaRequest>'
                 '<!--Optional:-->'
                  '<bayiReferans>' ms_subscribe-subscriber_number '</bayiReferans>'
                  '<!--Optional:-->'
                  '<password>' ms_service_info-password '</password>'
                  '<!--Optional:-->'
                  '<userName>' ms_service_info-username '</userName>'
              '</limitSorgulaRequest>'
          '</nan:limitSorgula>'
      '</soapenv:Body>'
  '</soapenv:Envelope>' INTO rv_request.

  ENDMETHOD.