  METHOD response_mapping_collect_inv.
    DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = iv_response ).
    READ TABLE lt_xml INTO DATA(ls_error_code) WITH KEY node_type = mc_value_node name = 'RESULT_CODE'.
    READ TABLE lt_xml INTO DATA(ls_error_text) WITH KEY node_type = mc_value_node name = 'RESULT_MESSAGE'.
    IF ls_error_code-value = '000'. "başarılı
      READ TABLE lt_xml INTO DATA(ls_amount) WITH KEY node_type = mc_value_node name = 'INVOICE_PAYMENT_AMOUNT'.
      READ TABLE lt_xml INTO DATA(ls_currency) WITH KEY node_type = mc_value_node name = 'INVOICE_PAYMENT_CURRENCY_CODE'.
      READ TABLE lt_xml INTO DATA(ls_date) WITH KEY node_type = mc_value_node name = 'LAST_PAYMENT_DATE'.
      es_collect_detail = VALUE #( payment_amount = ls_amount-value
                                   payment_date = ls_date-value
                                   payment_currency = ms_invoice_data-transactioncurrency ).
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