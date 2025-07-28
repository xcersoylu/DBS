  METHOD response_mapping_collect_inv.
    DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = iv_response ).
    READ TABLE lt_xml INTO DATA(ls_error_code) WITH KEY node_type = mc_value_node name = 'status'.
    READ TABLE lt_xml INTO DATA(ls_error_text) WITH KEY node_type = mc_value_node name = 'statusMessage'.
    IF ls_error_code-value = 'O'. "ödendi
      READ TABLE lt_xml INTO DATA(ls_amount) WITH KEY node_type = mc_value_node name = 'amount'.
      READ TABLE lt_xml INTO DATA(ls_date) WITH KEY node_type = mc_value_node name = 'paymentDate'.
      es_collect_detail = VALUE #( payment_amount = ls_amount-value
                                   payment_date = ls_date-value
                                   payment_currency = ms_invoice_data-transactioncurrency ).
    ELSE.
      APPEND VALUE #( id = mc_id type = mc_error number = 004 ) TO rt_messages.
      APPEND VALUE #( id = mc_id type = 'E' number = 000 message_v1 = ls_error_text-value(50)
                                                             message_v2 = ls_error_text-value+50(50)
                                                             message_v3 = ls_error_text-value+100(50)
                                                             message_v4 = ls_error_text-value+150(50) ) TO rt_messages.
    ENDIF.
  ENDMETHOD.