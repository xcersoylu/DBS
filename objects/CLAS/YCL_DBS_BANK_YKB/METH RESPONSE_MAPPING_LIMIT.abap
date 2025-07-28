  METHOD response_mapping_limit.
    DATA ls_limit TYPE ydbs_t_limit.
    DATA(ls_time_info) = ycl_dbs_common=>get_local_time(  ).
    DATA(lv_response) = iv_response.
    REPLACE ALL OCCURRENCES OF '&lt;' IN lv_response WITH '<'.
    REPLACE ALL OCCURRENCES OF '&gt;' IN lv_response WITH '>'.
    DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = lv_response ).
    ls_limit = VALUE #( companycode    = ms_service_info-companycode
                        bankinternalid = ms_service_info-bankinternalid
                        customer       = ms_subscribe-customer
                        currency       = ms_service_info-currency
                        limit_timestamp = ls_time_info-timestamp
                        limit_date      = ls_time_info-date
                        limit_time      = ls_time_info-time
                        total_limit     = VALUE #( lt_xml[ node_type = mc_value_node name = 'BcdzLimit' ]-value OPTIONAL )
                        available_limit = VALUE #( lt_xml[ node_type = mc_value_node name = 'RealBoslukTL' ]-value OPTIONAL )
                        risk            = VALUE #( lt_xml[ node_type = mc_value_node name = 'BcdzBakiye' ]-value OPTIONAL )
                        maturity_amount = VALUE #( lt_xml[ node_type = mc_value_node name = 'AllOnayTopTL' ]-value OPTIONAL )
                        maturity_invoice_count = ''
                        over_limit   = VALUE #( lt_xml[ node_type = mc_value_node name = 'TLFatYtszTop' ]-value OPTIONAL ) ).
    MODIFY ydbs_t_limit FROM @ls_limit.
  ENDMETHOD.