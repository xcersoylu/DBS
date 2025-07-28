  METHOD response_mapping_update_inv.
    DATA(lv_response) = iv_response.
    REPLACE ALL OCCURRENCES OF '&lt;' IN lv_response WITH '<'.
    REPLACE ALL OCCURRENCES OF '&gt;' IN lv_response WITH '>'.
    DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = lv_response ).
    READ TABLE lt_xml INTO DATA(ls_error_code) WITH KEY node_type = mc_value_node name = 'BaseIslemKodu'.
    READ TABLE lt_xml INTO DATA(ls_error_text) WITH KEY node_type = mc_value_node name = 'BaseUrunMesaj'.
    IF ls_error_code-value = '01'. "başarılı
*      READ TABLE lt_xml INTO DATA(ls_error_amount) WITH KEY node_type = mc_value_node name = 'OdenenTutar'.
*      READ TABLE lt_xml INTO DATA(ls_error_date) WITH KEY node_type = mc_value_node name = 'OdemeTarihi'.
    ELSE.
      APPEND VALUE #( id = mc_id type = mc_error number = 004 ) TO rt_messages.
      APPEND VALUE #( id = mc_id type = mc_error number = 000 message_v1 = ls_error_text-value(50)
                                                             message_v2 = ls_error_text-value+50(50)
                                                             message_v3 = ls_error_text-value+100(50)
                                                             message_v4 = ls_error_text-value+150(50) ) TO rt_messages.
    ENDIF.
  ENDMETHOD.