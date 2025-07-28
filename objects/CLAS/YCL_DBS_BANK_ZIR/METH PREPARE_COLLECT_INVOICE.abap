  METHOD prepare_collect_invoice.
    CONCATENATE
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">'
     '<soapenv:Header/>'
     '<soapenv:Body>'
        '<tem:FaturaSorgula>'
           '<tem:faturaSorgu>'
              '<tem:kullaniciAdi>' ms_service_info-username  '</tem:kullaniciAdi>'
              '<tem:sifre>' ms_service_info-password '</tem:sifre>'
              '<tem:dbsNo>' ms_subscribe-subscriber_number '</tem:dbsNo>'
              '<tem:faturaNo>' ms_invoice_data-invoicenumber '</tem:faturaNo>'
              '<tem:tarihTip>-1</tem:tarihTip>' "-1 tarih vermeden sorgu, 0 fatura tarihi, -1 vade tarihi
              '<tem:baslangicTarihi/>'
              '<tem:bitisTarihi/>'
           '</tem:faturaSorgu>'
        '</tem:FaturaSorgula>'
     '</soapenv:Body>'
     '</soapenv:Envelope>' INTO rv_request.
  ENDMETHOD.