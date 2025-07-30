  METHOD response_mapping_collect_inv.
    DATA ls_teb_payment_no TYPE ydbs_t_teb_pymno.
    DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = iv_response ).
    READ TABLE lt_xml INTO DATA(ls_error_code) WITH KEY node_type = mc_value_node name = 'cevapKod'.
    READ TABLE lt_xml INTO DATA(ls_error_text) WITH KEY node_type = mc_value_node name = 'cevapAciklama'.
    READ TABLE lt_xml INTO DATA(ls_fatura_durum) WITH KEY node_type = mc_value_node name = 'faturaDurum'.
    IF ls_error_code-value = '000'. "başarılı
      APPEND VALUE #( id = mc_id type = mc_success number = 003 ) TO rt_messages.
      IF ls_fatura_durum-value = 'O'."O-Odendi, G-Geçerli, I-İptal, K-Kismi Ödendi
        es_collect_detail-payment_amount = ms_invoice_data-invoiceamount.
        es_collect_detail-payment_currency = ms_invoice_data-transactioncurrency.
        es_collect_detail-payment_date = ms_invoice_data-invoiceduedate.
      ENDIF.
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