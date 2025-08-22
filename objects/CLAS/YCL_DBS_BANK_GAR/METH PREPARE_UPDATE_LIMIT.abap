  METHOD prepare_update_limit.
    CONCATENATE
  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pay="PaymentService">'
     '<soapenv:Header/>'
     '<soapenv:Body>'
        '<pay:ContractStatusRequest>'
           '<pay:SPName>' ms_service_info-additional_field1 '</pay:SPName>'
           '<!--Optional:-->'
           '<pay:CreateTimestamp></pay:CreateTimestamp>'
           '<!--Optional:-->'
           '<pay:SecureToken></pay:SecureToken>'
           '<pay:RequestType>2</pay:RequestType>'
           '<pay:GLCN>' ms_service_info-additional_field2 '</pay:GLCN>'
           '<pay:RegionCode></pay:RegionCode>'
           '<pay:ContractID>' ms_subscribe-subscriber_number '</pay:ContractID>'
        '</pay:ContractStatusRequest>'
     '</soapenv:Body>'
  '</soapenv:Envelope>' INTO rv_request.

  ENDMETHOD.