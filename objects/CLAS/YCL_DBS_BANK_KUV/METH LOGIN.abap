  METHOD login.
    TYPES : BEGIN OF ty_result,
              errorcode    TYPE string,
              errormessage TYPE string,
              isfriendly   TYPE string,
            END OF ty_result,
            tt_results TYPE TABLE OF ty_result WITH DEFAULT KEY,
            BEGIN OF ty_json,
              results            TYPE tt_results,
              success            TYPE string,
              iscaptcharequired  TYPE string,
              iscustomerprivate  TYPE string,
              isyourbankcustomer TYPE string,
              sessionid          TYPE string,
              sessionkey         TYPE string,
              timeoutduration    TYPE string,
            END OF ty_json.
    DATA ls_request TYPE string.
    DATA ls_response TYPE ty_json.
    DATA lv_url TYPE c LENGTH 255.
    CONCATENATE
    '{'
      '"ExtUName": "' ms_service_info-username '",'
      '"ExtUPassword": "' ms_service_info-password '"'
    '}' INTO ls_request.

    TRY.
        lv_url = |{ ms_service_info-additional_field2 }{ ms_service_info-additional_field3 }|.
        DATA(lo_http_destination) = cl_http_destination_provider=>create_by_url( CONV #( lv_url ) ).
        DATA(lo_web_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_http_destination ) .
        DATA(lo_web_http_request) = lo_web_http_client->get_http_request( ).
        lo_web_http_request->set_authorization_basic(
          EXPORTING
            i_username = CONV #( ms_service_info-cpi_username )
            i_password = CONV #( ms_service_info-cpi_password )
        ).
        lo_web_http_request->set_header_fields( VALUE #( (  name = 'Accept' value = 'application/json' )
                                                         (  name = 'Content-Type' value = 'application/json' ) ) ).

        lo_web_http_request->set_text(
          EXPORTING
            i_text   = ls_request
        ).

        DATA(lo_web_http_response) = lo_web_http_client->execute( if_web_http_client=>post ).
        DATA(lv_response) = lo_web_http_response->get_text( ).
        lo_web_http_response->get_status(
          RECEIVING
            r_value = DATA(ls_status)
        ).
        IF ls_status-code = mc_success_code. "success
          /ui2/cl_json=>deserialize(
            EXPORTING json = lv_response
            CHANGING data = ls_response ).
          rv_sessionkey = ls_response-sessionkey.
        ENDIF.
      CATCH cx_http_dest_provider_error cx_web_http_client_error cx_web_message_error.
    ENDTRY.
  ENDMETHOD.