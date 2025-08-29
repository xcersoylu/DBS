  METHOD prepare_delete_invoice.
    DATA : lv_amount   TYPE string.
    DATA : lv_duedate TYPE c LENGTH 10.
    mv_methodname = 'CreateInvoiceCrud'.
    IF mv_sessionkey IS INITIAL.
      mv_sessionkey = login(  ).
    ENDIF.
    IF mv_sessionkey IS NOT INITIAL.
      lv_amount = ms_invoice_data-invoiceamount.CONDENSE lv_amount.
      CONCATENATE ms_invoice_data-invoiceduedate+6(2) '/'
                  ms_invoice_data-invoiceduedate+4(2) '/'
                  ms_invoice_data-invoiceduedate(4)
             INTO lv_duedate.

      CONCATENATE
      '{'
         '"ProcessType": "' '2' '",'
         '"InternalMemberCode": "' ms_subscribe-subscriber_number '",'
         '"SupplierCode": "' ms_service_info-additional_field1  '",'
         '"FromTitle": "' ms_service_info-additional_field2  '",'
         '"InvoiceNo": "' ms_invoice_data-invoicenumber '",'
         '"InvoiceDueDate": "' lv_duedate '",'
         '"Amount":' lv_amount ','
         '"FEC": "' ms_invoice_data-transactioncurrency '",'
         '"ExtUSessionKey": "' mv_sessionkey '"'
      '}'
   INTO rv_request.
    ENDIF.
  ENDMETHOD.