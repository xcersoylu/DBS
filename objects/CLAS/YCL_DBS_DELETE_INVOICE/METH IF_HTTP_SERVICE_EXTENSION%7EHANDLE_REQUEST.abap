  METHOD if_http_service_extension~handle_request.
    DATA lt_messages TYPE ydbs_tt_bapiret2.
    DATA(lv_request_body) = request->get_text( ).
    DATA(lv_get_method) = request->get_method( ).
    /ui2/cl_json=>deserialize( EXPORTING json = lv_request_body CHANGING data = ms_request ).

    LOOP AT ms_request-invoicedata INTO DATA(ls_invoice_data) WHERE invoicestatus = mc_ready
                                                                OR invoicestatus = mc_collected.
      EXIT.
    ENDLOOP.
    IF sy-subrc = 0.
      APPEND VALUE #( id = 'YDBS_MC' type = mc_error number = 009 ) TO ms_response-messages.
    ELSE.
      LOOP AT ms_request-invoicedata INTO DATA(ls_request).
        CLEAR lt_messages.
        DATA(lo_bank) = ycl_dbs_bank=>factory( iv_bankinternalid = ls_request-bankinternalid
                                                iv_companycode    = ls_request-companycode
                                                iv_customer       = ls_request-customer
                                                iv_invoice_data   = ls_request ).
        lo_bank->call_api( EXPORTING iv_api_type = mc_delete IMPORTING et_messages = lt_messages ).
        IF lt_messages IS NOT INITIAL.
          APPEND LINES OF lt_messages TO ms_response-messages.
        ENDIF.
        "#TODO delete durumda FI belgeleri ne olacak ?
        IF NOT line_exists( lt_messages[ type = 'E' ] ).
          DELETE FROM ydbs_t_log
           WHERE companycode             = @ls_request-companycode
             AND accountingdocument      = @ls_request-accountingdocument
             AND fiscalyear              = @ls_request-fiscalyear
             AND accountingdocumentitem  = @ls_request-accountingdocumentitem.
        ENDIF.
        FREE lo_bank. CLEAR lo_bank.
      ENDLOOP.
    ENDIF.
    IF ms_response-messages IS NOT INITIAL.
      LOOP AT ms_response-messages ASSIGNING FIELD-SYMBOL(<ls_message>).
        MESSAGE ID <ls_message>-id
                TYPE <ls_message>-type
                NUMBER <ls_message>-number
                WITH <ls_message>-message_v1
                     <ls_message>-message_v2
                     <ls_message>-message_v3
                     <ls_message>-message_v4
               INTO <ls_message>-message.
      ENDLOOP.
    ENDIF.
    DATA(lv_response_body) = /ui2/cl_json=>serialize( EXPORTING data = ms_response ).
    response->set_text( lv_response_body ).
    response->set_header_field( i_name = mc_header_content i_value = mc_content_type ).
  ENDMETHOD.