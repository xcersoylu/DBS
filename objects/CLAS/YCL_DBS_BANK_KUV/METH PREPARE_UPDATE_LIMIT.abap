  METHOD prepare_update_limit.
    mv_methodname = 'GetLimitInfo'.
    IF mv_sessionkey IS INITIAL.
      mv_sessionkey = login(  ).
    ENDIF.
    IF mv_sessionkey IS NOT INITIAL.
      CONCATENATE
      '{'
         '"PurchaserCode": "' ms_subscribe-subscriber_number '",'
         '"SupplierCode": "' ms_service_info-additional_field1 '",'
         '"ExtUSessionKey": "' mv_sessionkey '"'
      '}'
   INTO rv_request.
    ENDIF.
  ENDMETHOD.