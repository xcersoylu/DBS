  METHOD if_http_service_extension~handle_request.
    DATA lt_je TYPE TABLE FOR ACTION IMPORT i_journalentrytp~change.
    DATA lv_message TYPE c LENGTH 200.

    DATA(lv_request_body) = request->get_text( ).
    DATA(lv_get_method) = request->get_method( ).
    DATA lt_send_documents TYPE ydbs_tt_invoice_cockpit_data.
    /ui2/cl_json=>deserialize( EXPORTING json = lv_request_body CHANGING data = ms_request ).

    APPEND INITIAL LINE TO lt_je ASSIGNING FIELD-SYMBOL(<je>).
    <je>-accountingdocument = ms_request-accountingdocument .
    <je>-fiscalyear         = ms_request-fiscalyear.
    <je>-companycode        = ms_request-companycode.
    <je>-%param = VALUE #( _aparitems = VALUE #(  (  glaccountlineitem = ms_request-accountingdocumentitem
                                                     duecalculationbasedate = ms_request-duecalculationbasedate
                                                     %control-glaccountlineitem = if_abap_behv=>mk-on
                                                     %control-duecalculationbasedate = if_abap_behv=>mk-on ) ) ).

    MODIFY ENTITIES OF i_journalentrytp
     ENTITY journalentry
     EXECUTE change FROM lt_je
     FAILED DATA(ls_failed)
     REPORTED DATA(ls_reported)
     MAPPED DATA(ls_mapped).

    IF ls_failed IS NOT INITIAL.
      ROLLBACK ENTITIES.
      LOOP AT ls_reported-journalentry INTO DATA(ls_message).
        lv_message = CONV #( ls_message-%msg->if_message~get_text( ) ).
        APPEND VALUE #( id = 'YDBS_MC'
                        type = 'E'
                        number = 000
                        message_v1 = lv_message(50)
                        message_v2 = lv_message+50(50)
                        message_v3 = lv_message+100(50)
                        message_v4 = lv_message+150(50) ) TO ms_response-messages.
      ENDLOOP.
    ELSE.
      COMMIT ENTITIES BEGIN
      RESPONSE OF i_journalentrytp
      FAILED DATA(ls_commit_failed)
      REPORTED DATA(ls_commit_reported).
      COMMIT ENTITIES END.
      IF ls_commit_failed IS INITIAL.
        APPEND VALUE #( id = 'YDBS_MC' type = 'S' number = 011 ) TO ms_response-messages.
      ELSE.
        LOOP AT ls_commit_reported-journalentry INTO DATA(ls_reported_message).
          lv_message = CONV #( ls_reported_message-%msg->if_message~get_text( ) ).
          APPEND VALUE #( id = 'YDBS_MC'
              type = 'E'
              number = 000
              message_v1 = lv_message(50)
              message_v2 = lv_message+50(50)
              message_v3 = lv_message+100(50)
              message_v4 = lv_message+150(50) ) TO ms_response-messages.
        ENDLOOP.
      ENDIF.
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