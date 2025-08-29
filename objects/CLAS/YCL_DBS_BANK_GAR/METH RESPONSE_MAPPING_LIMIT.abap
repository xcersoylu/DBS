  METHOD response_mapping_limit.
    DATA ls_limit TYPE ydbs_t_limit.
    DATA(ls_time_info) = ycl_dbs_common=>get_local_time(  ).
    DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = iv_response ).
    READ TABLE lt_xml INTO DATA(ls_bankstatus) WITH KEY node_type = mc_value_node name = 'StatusCode'.
    if ls_bankstatus-value = '0000'.
    ls_limit = VALUE #( companycode    = ms_service_info-companycode
                        bankinternalid = ms_service_info-bankinternalid
                        customer       = ms_subscribe-customer
                        currency       = ms_service_info-currency
                        limit_timestamp = ls_time_info-timestamp
                        limit_date      = ls_time_info-date
                        limit_time      = ls_time_info-time
                        total_limit     = VALUE #( lt_xml[ node_type = mc_value_node name = 'CreditLimit' ]-value OPTIONAL )
                        available_limit = VALUE #( lt_xml[ node_type = mc_value_node name = 'AvailableCreditLimit' ]-value OPTIONAL ) ).
    MODIFY ydbs_t_limit FROM @ls_limit.
    ELSE.
      adding_error_message(
        EXPORTING
          iv_message  = CONV #( get_error_text( CONV #( ls_bankstatus-value ) ) )
        CHANGING
          ct_messages = rt_messages
      ).
    ENDIF.
  ENDMETHOD.