  METHOD prepare_update_limit.
    CONCATENATE
    '{ "limitSorgulaRequest": {  "Musteri_DBS_No": "' ms_subscribe-subscriber_number  '" } }' INTO rv_request.
  ENDMETHOD.