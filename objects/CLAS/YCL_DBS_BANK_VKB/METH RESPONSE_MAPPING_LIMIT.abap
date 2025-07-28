  METHOD response_mapping_limit.
    DATA ls_limit TYPE ydbs_t_limit.
    DATA(ls_time_info) = ycl_dbs_common=>get_local_time(  ).
    DATA(lv_response) = iv_response.
    REPLACE ALL OCCURRENCES OF '&lt;' IN lv_response WITH '<'.
    REPLACE ALL OCCURRENCES OF '&gt;' IN lv_response WITH '>'.
    DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = lv_response ).
    READ TABLE lt_xml INTO DATA(ls_error_code) WITH KEY node_type = mc_value_node name = 'BaseIslemKodu'.
    READ TABLE lt_xml INTO DATA(ls_error_text) WITH KEY node_type = mc_value_node name = 'BaseUrunMesaj'.
    IF ls_error_code-value = '01'. "başarılı
    ls_limit = VALUE #( companycode    = ms_service_info-companycode
                        bankinternalid = ms_service_info-bankinternalid
                        customer       = ms_subscribe-customer
                        currency       = ms_service_info-currency
                        limit_timestamp = ls_time_info-timestamp
                        limit_date      = ls_time_info-date
                        limit_time      = ls_time_info-time
                        total_limit     = VALUE #( lt_xml[ node_type = mc_value_node name = 'ToplamGarantiliLimit' ]-value OPTIONAL )
                        available_limit = VALUE #( lt_xml[ node_type = mc_value_node name = 'KalanGarantiliLimit' ]-value OPTIONAL )
                        risk            = VALUE #( lt_xml[ node_type = mc_value_node name = 'NakdiRisk' ]-value OPTIONAL )
                        maturity_amount = VALUE #( lt_xml[ node_type = mc_value_node name = 'GarantiliFaturaToplam' ]-value OPTIONAL )
                        over_limit      = VALUE #( lt_xml[ node_type = mc_value_node name = 'GarantisizFaturaToplam' ]-value OPTIONAL ) ).
    MODIFY ydbs_t_limit FROM @ls_limit.
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