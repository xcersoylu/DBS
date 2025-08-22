  METHOD prepare_collect_invoice.
    DATA lv_request TYPE string.
    SELECT SINGLE trf_id
    from ydbs_t_log
    WHERE companycode = @ms_invoice_data-companycode
      and accountingdocument = @ms_invoice_data-accountingdocument
      and accountingdocumentitem = @ms_invoice_data-accountingdocumentitem
    into @data(lv_trf_id).
    CONCATENATE
  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pay="PaymentService">'
     '<soapenv:Header/>'
     '<soapenv:Body>'
        '<pay:SingleTrfRequest>'
           '<pay:SPName>' ms_service_info-additional_field1 '</pay:SPName>'
           '<pay:GLCN>' ms_service_info-additional_field2 '</pay:GLCN>'
           '<!--Optional:-->'
           '<pay:CreateTimestamp></pay:CreateTimestamp>'
           '<!--Optional:-->'
           '<pay:SecureToken></pay:SecureToken>'
           '<pay:TrfUniqueID>' lv_trf_id '</pay:TrfUniqueID>'
        '</pay:SingleTrfRequest>'
     '</soapenv:Body>'
  '</soapenv:Envelope>' INTO lv_request.

  ENDMETHOD.