  METHOD prepare_update_limit.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://boa.net/BOA.Integration.DirectFundUtilization/Service">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<ser:GetLimitInfo>'
             '<!--Optional:-->'
             '<ser:userName>' ms_service_info-username '</ser:userName>'
             '<!--Optional:-->'
             '<ser:password>' ms_service_info-password '</ser:password>'
             '<!--Optional:-->'
             '<ser:subscriberNumber>' ms_subscribe-subscriber_number '</ser:subscriberNumber>'
          '</ser:GetLimitInfo>'
       '</soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.