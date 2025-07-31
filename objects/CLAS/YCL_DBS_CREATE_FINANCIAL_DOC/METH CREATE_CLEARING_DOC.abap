  METHOD create_clearing_doc.
    DATA lt_aparitems TYPE ycl_dbs_journal_entry_cle_tab3.
    SELECT * FROM ydbs_t_parameter WHERE parameter_name = 'CLEARING' INTO TABLE @DATA(lt_parameters).
    TRY.
        DATA(destination) = cl_soap_destination_provider=>create_by_comm_arrangement(
          comm_scenario  = VALUE #( lt_parameters[ parameter_key = 'COMM_SCENARIO' ]-parameter_value OPTIONAL )
        ).
        DATA(lo_proxy) = NEW ycl_dbs_co_journal_entry_bulk( destination = destination ).
        DATA(ls_request) = VALUE ycl_dbs_journal_entry_bulk_cle( ).
        GET TIME STAMP FIELD DATA(lv_date_time).
        APPEND VALUE #( company_code = ms_invoice_data-companycode
                        account_type = 'D'
                        aparaccount  = ms_invoice_data-customer
                        fiscal_year  = ms_invoice_data-documentdate(4)
                        accounting_document = ms_invoice_data-accountingdocument
                        accounting_document_item = ms_invoice_data-accountingdocumentitem
                       ) TO lt_aparitems.
        APPEND VALUE #( company_code = ms_invoice_data-companycode
                        account_type = 'D'
                        aparaccount  = ms_invoice_data-customer
                        fiscal_year  = mv_temporary_fi_doc_year
                        accounting_document = mv_temporary_fi_doc
                        accounting_document_item = '2' "müşteri kalemi 2. kalem olduğu için
                       ) TO lt_aparitems.
        APPEND VALUE #( message_header = VALUE #( id = VALUE #( content = 'DBS_CLEARING' )
                                                                            creation_date_time = lv_date_time )
                        journal_entry = VALUE #( company_code              = ms_invoice_data-companycode
                                                 accounting_document_type  = 'DZ'
                                                 document_date             = ms_collect_detail-payment_date
                                                 posting_date              = ms_collect_detail-payment_date
                                                 currency_code             = ms_collect_detail-payment_currency
                                                 document_header_text      = |{ ms_invoice_data-accountingdocument }/{ mv_temporary_fi_doc }|
                                                 created_by_user           = cl_abap_context_info=>get_user_technical_name(  )
*                                                glitems                   =
                                                aparitems                 = lt_aparitems ) ) TO
        ls_request-journal_entry_bulk_clearing_re-journal_entry_clearing_request.

        ls_request-journal_entry_bulk_clearing_re-message_header = VALUE #( id = VALUE #( content = 'DBS_CLEARING' )
                                                                            creation_date_time = lv_date_time ).
        lo_proxy->journal_entry_bulk_clearing_re(
          EXPORTING
            input = ls_request
        ).
        COMMIT WORK.
        DATA(lv_user) = cl_abap_context_info=>get_user_technical_name(  ).
        DO 5 TIMES.
          SELECT SINGLE clearingjournalentry FROM i_journalentryitem WITH PRIVILEGED ACCESS
                      WHERE clearingjournalentry IS NOT INITIAL
                        AND accountingdocument = @mv_temporary_fi_doc
                        AND companycode        = @ms_invoice_data-companycode
                        AND fiscalyear         = @mv_temporary_fi_doc_year
                        AND sourceledger       = '0L'
                        AND ledger             = '0L'
                        INTO @DATA(lv_clearing_document).
          IF sy-subrc = 0.
            ev_accountingdocument = lv_clearing_document.
            ev_fiscalyear = mv_temporary_fi_doc_year.
            APPEND VALUE #( id = 'YDBS_MC'
                            type = 'S'
                            number = 005
                            message_v1 = ev_accountingdocument ) TO et_messages.
            EXIT.
          ELSE.
            WAIT UP TO 1 SECONDS.
          ENDIF.
        ENDDO.

      CATCH cx_soap_destination_error.
      CATCH cx_ai_system_fault.
    ENDTRY.
  ENDMETHOD.