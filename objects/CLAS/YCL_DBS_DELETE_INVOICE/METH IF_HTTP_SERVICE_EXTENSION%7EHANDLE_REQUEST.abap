  METHOD if_http_service_extension~handle_request.
    DATA lt_messages TYPE ydbs_tt_bapiret2.
    DATA(lv_request_body) = request->get_text( ).
    DATA(lv_get_method) = request->get_method( ).
    /ui2/cl_json=>deserialize( EXPORTING json = lv_request_body CHANGING data = ms_request ).
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
    DATA(lv_response_body) = /ui2/cl_json=>serialize( EXPORTING data = ms_response ).
    response->set_text( lv_response_body ).
    response->set_header_field( i_name = mc_header_content i_value = mc_content_type ).
  ENDMETHOD.