  METHOD prepare_collect_invoice.
    DATA lv_bdate TYPE c LENGTH 10.
    DATA lv_edate TYPE c LENGTH 10.
    mv_methodname = 'GetInvoiceResults'.
    IF mv_sessionkey IS INITIAL.
      mv_sessionkey = login(  ).
    ENDIF.
    IF mv_sessionkey IS NOT INITIAL.
      CONCATENATE ms_invoice_data-documentdate+6(2)
                  ms_invoice_data-documentdate+4(2)
                  ms_invoice_data-documentdate(4)
             INTO lv_bdate.
      CONCATENATE ms_invoice_data-invoiceduedate+6(2)
                  ms_invoice_data-invoiceduedate+4(2)
                  ms_invoice_data-invoiceduedate(4)
             INTO lv_edate.

      CONCATENATE
      '{'
         '"PurchaserCode": "' ms_subscribe-subscriber_number '",'
         '"SupplierCode": "' ms_service_info-additional_field1 '",'
         '"BaslangicTarihi": "' lv_bdate '",'
         '"BitisTarihi": "' lv_edate '",'
         '"ExtUSessionKey": "' mv_sessionkey '"'
      '}'
   INTO rv_request.
    ENDIF.
  ENDMETHOD.