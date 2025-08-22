  METHOD response_mapping_send_invoice.
    DATA ls_teb_payment_no TYPE ydbs_t_teb_pymno.
    DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = iv_response ).
    READ TABLE lt_xml INTO DATA(ls_error_code) WITH KEY node_type = mc_value_node name = 'cevapKod'.
    READ TABLE lt_xml INTO DATA(ls_error_text) WITH KEY node_type = mc_value_node name = 'cevapAck'.
    READ TABLE lt_xml INTO DATA(ls_payment_no) WITH KEY node_type = mc_value_node name = 'bankaOdemeNo'.
    IF ls_error_code-value = '000'. "başarılı
      APPEND VALUE #( id = mc_id type = mc_success number = 003 ) TO rt_messages.
    ELSE.
      APPEND VALUE #( id = mc_id type = mc_error number = 004 ) TO rt_messages.
      adding_error_message(
        EXPORTING
          iv_message  = ls_error_text-value
        CHANGING
          ct_messages = rt_messages
      ).
    ENDIF.
    ls_teb_payment_no = VALUE #( invoice_number = ms_invoice_data-invoicenumber
                                 payment_no = ls_payment_no-value
                                 cevap_kod = ls_error_code-value
                                 cevap_aciklama = ls_error_text-value  ).
    MODIFY ydbs_t_teb_pymno FROM @ls_teb_payment_no.

  ENDMETHOD.