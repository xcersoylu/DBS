  METHOD prepare_update_limit.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://isbank.com/OpSvcs/PaymentMgmtProcessing/DDS/DDSGeneric/Service/V1" xmlns:v11="http://isbank.com/OpSvcs/PaymentMgmtProcessing/DDS/Core/Schema/V1">'
        '<soapenv:Header/>'
        '<soapenv:Body>'
            '<v1:retrieveSubscriberList>'
                '<v1:corporateCode>' ms_service_info-additional_field1 '</v1:corporateCode>'
                '<!--Optional:-->'
                '<v1:extensionParameters>'
                    '<v11:parameterName>' ms_service_info-username '</v11:parameterName>'
                    '<v11:parameterValue>' ms_service_info-password '</v11:parameterValue>'
                '</v1:extensionParameters>'
            '</v1:retrieveSubscriberList>'
        '</soapenv:Body>'
    '</soapenv:Envelope>' INTO rv_request.


  ENDMETHOD.