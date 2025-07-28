  METHOD call_api.
    CONSTANTS lc_success_code TYPE i VALUE 200.
    DATA lv_value TYPE string.
    DATA lv_invoice_status TYPE ydbs_e_invoicestatus.
    mv_api_type = iv_api_type.
    CASE mv_api_type.
      WHEN 'L'.
        DATA(lv_request) = prepare_update_limit(  ).
      WHEN 'S'.
        lv_request = prepare_send_invoice(  ).
      WHEN 'U'.
        lv_request = prepare_update_invoice(  ).
      WHEN 'D'.
        lv_request = prepare_delete_invoice(  ).
      WHEN 'C'.
        lv_request = prepare_collect_invoice(  ).
    ENDCASE.
    TRY.
        DATA(lo_http_destination) = cl_http_destination_provider=>create_by_url( CONV #( ms_service_info-cpi_url ) ).
        DATA(lo_web_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ) .
        DATA(lo_web_http_request) = lo_web_http_client->get_http_request( ).
        lo_web_http_request->set_authorization_basic(
          EXPORTING
            i_username = CONV #( ms_service_info-cpi_username )
            i_password = CONV #( ms_service_info-cpi_password )
        ).
        CASE ms_service_info-service_type.
          WHEN 'XML'.
            lv_value = 'application/xml'.
          WHEN 'JSON'.
            lv_value = 'application/json'.
        ENDCASE.
        lo_web_http_request->set_header_fields( VALUE #( (  name = 'Accept' value = lv_value )
                                                         (  name = 'Content-Type' value = lv_value ) ) ).
        lo_web_http_request->set_text(
          EXPORTING
            i_text   = lv_request
        ).

        DATA(lo_web_http_response) = lo_web_http_client->execute( if_web_http_client=>post ).
        DATA(lv_response) = lo_web_http_response->get_text( ).

        lo_web_http_response->get_status(
          RECEIVING
            r_value = DATA(ls_status)
        ).
        IF ls_status-code = lc_success_code. "success
          CASE mv_api_type.
            WHEN 'L'.
              et_messages = response_mapping_limit( lv_response ).
            WHEN 'S'.
              lv_invoice_status = mv_api_type.
              et_messages = response_mapping_send_invoice( lv_response ).
            WHEN 'U'.
              lv_invoice_status = mv_api_type.
              et_messages = response_mapping_update_inv( lv_response ).
            WHEN 'D'.
              lv_invoice_status = mv_api_type.
              et_messages = response_mapping_delete_inv( lv_response ).
            WHEN 'C'.
              lv_invoice_status = mv_api_type.
              et_messages = response_mapping_collect_inv(
                              EXPORTING
                                iv_response       = lv_response
                              IMPORTING
                                es_collect_detail = ms_collect_detail
                            ).
          ENDCASE.
*          IF NOT line_exists( et_messages[ type = mc_error ] ).
*            IF mv_api_type = 'S' OR
*               mv_api_type = 'U' OR
*               mv_api_type = 'D' OR
*               mv_api_type = 'C' .
*              save_log( lv_invoice_status ).
*            ENDIF.
*          ENDIF.
        ELSE.
          APPEND VALUE #( id = mc_id type = mc_error number = 000 message_v1 = |Status Code { ls_status-code }| ) TO et_messages.
          lo_web_http_response->get_text(
            RECEIVING
              r_value = DATA(lv_error)
          ).
          APPEND VALUE #( id = mc_id type = mc_error number = 000 message_v1 = lv_error(50)
                                                                 message_v2 = lv_error+50(50)
                                                                 message_v3 = lv_error+100(50)
                                                                 message_v4 = lv_error+150(50) ) TO et_messages.
        ENDIF.

      CATCH cx_http_dest_provider_error cx_web_http_client_error cx_web_message_error.
    ENDTRY.
  ENDMETHOD.