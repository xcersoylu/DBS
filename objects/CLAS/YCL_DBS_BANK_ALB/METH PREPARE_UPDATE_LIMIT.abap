  METHOD prepare_update_limit.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'
    '<soapenv:Header/>'
    '<soapenv:Body>'
      '<tem:GetSubscriberInfo>'
        '<!--Optional:-->'
        '<tem:ServiceUserName>' ms_service_info-username '</tem:ServiceUserName>'
        '<!--Optional:-->'
        '<tem:ServiceUserPassword>' ms_service_info-password '</tem:ServiceUserPassword>'
        '<!--Optional:-->'
        '<tem:SubscriberNumber>' ms_subscribe-subscriber_number '</tem:SubscriberNumber>'
      '</tem:GetSubscriberInfo>'
    '</soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.