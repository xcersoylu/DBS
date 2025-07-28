  METHOD response_mapping_send_invoice.
    DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = iv_response ).
    READ TABLE lt_xml INTO DATA(ls_error_code) WITH KEY node_type = mc_value_node name = 'RESULT_CODE'.
    READ TABLE lt_xml INTO DATA(ls_error_text) WITH KEY node_type = mc_value_node name = 'RESULT_MESSAGE'.
    IF ls_error_code-value = '000'. "başarılı
      APPEND VALUE #( id = mc_id type = mc_success number = 003 ) TO rt_messages.
    ELSE.
      APPEND VALUE #( id = mc_id type = mc_error number = 004 ) TO rt_messages.
      APPEND VALUE #( id = mc_id type = 'E' number = 000 message_v1 = ls_error_text-value(50)
                                                             message_v2 = ls_error_text-value+50(50)
                                                             message_v3 = ls_error_text-value+100(50)
                                                             message_v4 = ls_error_text-value+150(50) ) TO rt_messages.
    ENDIF.
  ENDMETHOD.