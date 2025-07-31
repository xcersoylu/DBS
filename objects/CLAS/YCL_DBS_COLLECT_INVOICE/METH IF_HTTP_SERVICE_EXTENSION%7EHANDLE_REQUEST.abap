  METHOD if_http_service_extension~handle_request.
    DATA lt_messages TYPE ydbs_tt_bapiret2.
    DATA lo_fi_doc TYPE REF TO ycl_dbs_create_financial_doc.
    DATA(lv_request_body) = request->get_text( ).
    DATA(lv_get_method) = request->get_method( ).
    /ui2/cl_json=>deserialize( EXPORTING json = lv_request_body CHANGING data = ms_request ).
    SELECT * FROM ydbs_t_bnk_dtype INTO TABLE @DATA(lt_bank_doctype).
    LOOP AT ms_request-invoicedata INTO DATA(ls_request).
      DATA(lo_bank) = ycl_dbs_bank=>factory( iv_bankinternalid = ls_request-bankinternalid
                                              iv_companycode    = ls_request-companycode
                                              iv_customer       = ls_request-customer
                                              iv_invoice_data   = ls_request  ).
      lo_bank->call_api( EXPORTING iv_api_type = mc_collect IMPORTING et_messages = lt_messages ).
      IF lt_messages IS NOT INITIAL.
        APPEND LINES OF lt_messages TO ms_response-messages.
      ENDIF.
      IF NOT line_exists( lt_messages[ type = mc_error ] ). "hata yoksa FI belgesi yarat.
        lo_fi_doc = NEW #( is_invoice_data = ls_request
                           is_collect_detail = lo_bank->ms_collect_detail
                           is_bank_doctype = VALUE #( lt_bank_doctype[ companycode = ls_request-companycode bankinternalid = ls_request-bankinternalid ] OPTIONAL ) ).
        lo_fi_doc->create_collect_fi_doc(
          IMPORTING
            ev_accountingdocument = DATA(lv_collect_doc)
            ev_fiscalyear         = DATA(lv_collect_year)
            et_messages           = DATA(lt_collect_messages)
        ).
        IF lt_collect_messages IS NOT INITIAL.
          APPEND LINES OF lt_collect_messages TO ms_response-messages.
        ENDIF.
      ENDIF.

        UPDATE ydbs_t_log
           set invoicenumber           = @ls_request-invoicenumber,
               invoiceduedate          = @ls_request-invoiceduedate,
               invoiceamount           = @ls_request-invoiceamount,
               transactioncurrency     = @ls_request-transactioncurrency,
               invoicestatus           = 'C',
               collect_document        = @lv_collect_doc,
               collect_document_year   = @lv_collect_year
         where companycode             = @ls_Request-companycode
           and accountingdocument      = @ls_Request-accountingdocument
           and fiscalyear              = @ls_Request-fiscalyear
           and accountingdocumentitem  = @ls_Request-accountingdocumentitem.

*clear
      FREE: lo_bank , lo_fi_doc.
      CLEAR: lo_bank , lo_fi_doc , lv_collect_doc , lv_collect_year , lt_collect_messages , lt_messages .

    ENDLOOP.
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