  METHOD get_batch_trailer.
    DATA lv_request TYPE string.
    CONCATENATE
  '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pay="PaymentService">'
     '<soapenv:Header/>'
     '<soapenv:Body>'
        '<pay:BatchTrailerRequest>'
           '<pay:SPName>' ms_service_info-additional_field1 '</pay:SPName>'
           '<pay:GLCN>' ms_service_info-additional_field2 '</pay:GLCN>'
           '<!--Optional:-->'
           '<pay:CreateTimestamp></pay:CreateTimestamp>'
           '<!--Optional:-->'
           '<pay:SecureToken></pay:SecureToken>'
           '<pay:BatchID>' mv_batch_id '</pay:BatchID>'
           '<pay:BatchItemCount>1</pay:BatchItemCount>'
           '<pay:PackageCount>1</pay:PackageCount>'
        '</pay:BatchTrailerRequest>'
     '</soapenv:Body>'
  '</soapenv:Envelope>' INTO lv_request.

    TRY.
        DATA(lo_http_destination) = cl_http_destination_provider=>create_by_url( CONV #( ms_service_info-cpi_url ) ).
        DATA(lo_web_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ) .
        DATA(lo_web_http_request) = lo_web_http_client->get_http_request( ).
        lo_web_http_request->set_authorization_basic(
          EXPORTING
            i_username = CONV #( ms_service_info-cpi_username )
            i_password = CONV #( ms_service_info-cpi_password )
        ).
        lo_web_http_request->set_header_fields( VALUE #( (  name = 'Accept' value = 'application/xml' )
                                                         (  name = 'Content-Type' value = 'application/xml' )
                                                         (  name = 'CompanyCode' value = |DBS{ ms_service_info-class_suffix  }{ ms_service_info-companycode }| ) ) ).
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
        IF ls_status-code = mc_success_code. "success #TODO hata mesajlarını doldur
          DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = lv_response ).
          READ TABLE lt_xml INTO DATA(ls_bankstatus) WITH KEY node_type = mc_value_node name = 'StatusCode'.
          IF ls_bankstatus-value = '0000'.
            rv_ok = abap_true.
          ELSE.
          ENDIF.
        ELSE.
        ENDIF.
      CATCH cx_http_dest_provider_error cx_web_http_client_error cx_web_message_error.
    ENDTRY.

  ENDMETHOD.