  METHOD prepare_delete_invoice.
    DATA: lv_bldat    TYPE c LENGTH 10.
    DATA: lv_duedate  TYPE c LENGTH 10.
    DATA: lv_amount      TYPE string.
    DATA: lv_proctype TYPE c.
    DATA: lv_ccode    TYPE c LENGTH 2.

    CONCATENATE ms_invoice_data-documentdate+6(2) '.'
                ms_invoice_data-documentdate+4(2) '.'
                ms_invoice_data-documentdate(4)
           INTO lv_bldat.
    CONCATENATE ms_invoice_data-invoiceduedate+6(2) '.'
                ms_invoice_data-invoiceduedate+4(2) '.'
                ms_invoice_data-invoiceduedate(4)
           INTO lv_duedate.
    lv_amount = ms_invoice_data-invoiceamount. CONDENSE lv_amount.

    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'
       '<soapenv:Header/>'
       '<soapenv:Body>'
          '<tem:FaturaYukle>'
            '<tem:fatura>'
                 '<tem:kullaniciAdi>' ms_service_info-username '</tem:kullaniciAdi>'
                '<tem:sifre>' ms_service_info-password '</tem:sifre>'
                '<tem:dbsNo>' ms_subscribe-subscriber_number '</tem:dbsNo>'
                '<tem:faturaNo>' ms_invoice_data-invoicenumber '</tem:faturaNo>'
                '<tem:faturaTipi>1</tem:faturaTipi>'
                '<tem:faturaTarihi>' lv_bldat '</tem:faturaTarihi>'
                '<tem:vadeTarihi>' lv_duedate '</tem:vadeTarihi>'
                '<tem:pesinTutar>' lv_amount '</tem:pesinTutar>'
                '<tem:pesinParaBirimi>' ms_service_info-currency '</tem:pesinParaBirimi>'
                '<tem:vadeliTutar>' lv_amount '</tem:vadeliTutar>'
                '<tem:vadeliParaBirimi>' ms_service_info-currency '</tem:vadeliParaBirimi>'
                '<tem:islemTipi>' 'D' '</tem:islemTipi>'
           '</tem:fatura>'
       '</tem:FaturaYukle>'
     '</soapenv:Body>'
   '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.