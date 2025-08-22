  METHOD get_dts_detail.
    DATA lv_request TYPE string.
    DATA : lv_amount  TYPE string.
    DATA : lv_waers TYPE c LENGTH 3.
    mv_trf_id = get_trfid(  ).
    IF ms_invoice_data-transactioncurrency EQ 'TRY'.
      lv_waers = 'TL'.
    ELSE.
      lv_waers = ms_invoice_data-transactioncurrency.
    ENDIF.
    lv_amount = ms_invoice_data-invoiceamount. CONDENSE lv_amount.
    CONCATENATE
  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pay="PaymentService">'
     '<soapenv:Header/>'
     '<soapenv:Body>'
        '<pay:DTSDetailRequest>'
           '<!--Optional:-->'
           '<pay:CreateTimestamp></pay:CreateTimestamp>'
           '<!--Optional:-->'
           '<pay:SecureToken></pay:SecureToken>'
           '<pay:PackageHeader>'
              '<pay:SPName>' ms_service_info-additional_field1 '</pay:SPName>'
              '<pay:GLCN>' ms_service_info-additional_field2 '</pay:GLCN>'
              '<pay:BatchID>' mv_batch_id '</pay:BatchID>'
              '<pay:PackageID></pay:PackageID>'
           '</pay:PackageHeader>'
           '<pay:PackageDTSDetail>'
              '<!--1 to 100 repetitions:-->'
              '<pay:InvoiceInfo>'
                 '<pay:Operation>DTS</pay:Operation>'
                 '<!--Optional:-->'
                 '<pay:RegionCode></pay:RegionCode>'
                 '<pay:TrfUniqueID>' mv_trf_id '</pay:TrfUniqueID>'
                 '<pay:TrfType>' iv_trftype '</pay:TrfType>'
                 '<pay:ContractID>' ms_subscribe-subscriber_number '</pay:ContractID>'
                 '<pay:InvoiceType>B</pay:InvoiceType>'
                 '<pay:InvoiceNumber>' ms_invoice_data-invoicenumber '</pay:InvoiceNumber>'
                 '<pay:InvoiceDate>' ms_invoice_data-documentdate '</pay:InvoiceDate>'
                 '<pay:DueDate>' ms_invoice_data-invoiceduedate '</pay:DueDate>'
                 '<pay:Amount>' lv_amount '</pay:Amount>'
                 '<pay:CurrCode>' lv_waers '</pay:CurrCode>'
                 '<!--Optional:-->'
                 '<pay:Name></pay:Name>'
                 '<!--Optional:-->'
                 '<pay:CreditContractID></pay:CreditContractID>'
              '</pay:InvoiceInfo>'
           '</pay:PackageDTSDetail>'
           '<pay:PackageTrailer>'
              '<pay:PackageItemCount>1</pay:PackageItemCount>'
           '</pay:PackageTrailer>'
        '</pay:DTSDetailRequest>'
     '</soapenv:Body>'
  '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.