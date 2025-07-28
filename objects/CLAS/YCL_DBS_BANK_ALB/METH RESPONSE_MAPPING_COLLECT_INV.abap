  METHOD response_mapping_collect_inv.
    DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = iv_response ).
    READ TABLE lt_xml INTO DATA(ls_error_code) WITH KEY node_type = mc_value_node name = 'ResultCode'.
    READ TABLE lt_xml INTO DATA(ls_error_text) WITH KEY node_type = mc_value_node name = 'ResultMessage'.
    IF ls_error_code-value = '000'. "başarılı
      READ TABLE lt_xml INTO DATA(ls_amount) WITH KEY node_type = mc_value_node name = 'PaymentAmount'.
      READ TABLE lt_xml INTO DATA(ls_currency) WITH KEY node_type = mc_value_node name = 'PaymentCurrencyCode'.
      READ TABLE lt_xml INTO DATA(ls_date) WITH KEY node_type = mc_value_node name = 'PaymentDate'.
      es_collect_detail = VALUE #( payment_amount = ls_amount-value
                                   payment_date = ls_date-value
                                   payment_currency = ls_currency-value ).
    ELSE.
      APPEND VALUE #( id = mc_id type = mc_error number = 004 ) TO rt_messages.
      adding_error_message(
        EXPORTING
          iv_message  = ls_error_text-value
        CHANGING
          ct_messages = rt_messages
      ).
    ENDIF.
  ENDMETHOD.