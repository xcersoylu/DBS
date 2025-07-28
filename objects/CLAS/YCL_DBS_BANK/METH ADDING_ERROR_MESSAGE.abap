  METHOD adding_error_message.
    DATA lv_message TYPE c LENGTH 200.
    lv_message = iv_message.
    APPEND VALUE #( id = mc_id type = mc_error number = 000 message_v1 = lv_message(50)
                                                           message_v2 = lv_message+50(50)
                                                           message_v3 = lv_message+100(50)
                                                           message_v4 = lv_message+150(50) ) TO ct_messages.
  ENDMETHOD.