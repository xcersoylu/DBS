  METHOD create_temporary_fi_doc.
    TYPES : BEGIN OF ty_currencyamount,
              currencyrole           TYPE string,
              journalentryitemamount TYPE yeho_e_wrbtr,
              currency               TYPE waers,
            END OF ty_currencyamount.
    TYPES tt_currencyamount TYPE TABLE OF ty_currencyamount WITH EMPTY KEY.
    TYPES : BEGIN OF ty_glitem,
              glaccountlineitem             TYPE string,
              glaccount                     TYPE saknr,
              assignmentreference           TYPE dzuonr,
              reference1idbybusinesspartner TYPE xref1,
              reference2idbybusinesspartner TYPE xref2,
              reference3idbybusinesspartner TYPE xref3,
              costcenter                    TYPE kostl,
              orderid                       TYPE aufnr,
              documentitemtext              TYPE sgtxt,
              specialglcode                 TYPE yeho_e_umskz,
              _currencyamount               TYPE tt_currencyamount,
            END OF ty_glitem,
            BEGIN OF ty_aritems, "kunnr
              glaccountlineitem             TYPE string,
              customer                      TYPE kunnr,
              glaccount                     TYPE hkont,
              paymentmethod                 TYPE dzlsch,
              paymentterms                  TYPE dzterm,
              assignmentreference           TYPE dzuonr,
              profitcenter                  TYPE prctr,
              creditcontrolarea             TYPE kkber,
              reference1idbybusinesspartner TYPE xref1,
              reference2idbybusinesspartner TYPE xref2,
              reference3idbybusinesspartner TYPE xref3,
              documentitemtext              TYPE sgtxt,
              specialglcode                 TYPE yeho_e_umskz,
              _currencyamount               TYPE tt_currencyamount,
            END OF ty_aritems.
    DATA lt_je             TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.
    DATA lt_glitem         TYPE TABLE OF ty_glitem.
    DATA lt_aritem         TYPE TABLE OF ty_aritems.
    DATA lv_message TYPE c LENGTH 200.
    DATA(ls_local_time_info) = ycl_dbs_common=>get_local_time( ).
    APPEND INITIAL LINE TO lt_je ASSIGNING FIELD-SYMBOL(<fs_je>).
    TRY.
        <fs_je>-%cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
        APPEND VALUE #( glaccountlineitem             = |001|
                        glaccount                     = ms_bank_doctype-clearing_account
                        assignmentreference           = ms_invoice_data-assignmentreference
                        reference1idbybusinesspartner = ms_invoice_data-reference1idbybusinesspartner
                        reference2idbybusinesspartner = ms_invoice_data-reference2idbybusinesspartner
                        reference3idbybusinesspartner = ms_invoice_data-reference3idbybusinesspartner
*                          costcenter                    = is_invoice_data-costcenter
                        documentitemtext              = ms_invoice_data-documentitemtext
                        _currencyamount = VALUE #( ( currencyrole = '00'
                                                    journalentryitemamount = ms_invoice_data-invoiceamount
                                                    currency = ms_invoice_data-transactioncurrency  ) )          ) TO lt_glitem.

        APPEND VALUE #( glaccountlineitem             = |002|
                        customer                      = ms_invoice_data-customer
                        paymentmethod                 = ms_invoice_data-paymentmethod
                        assignmentreference           = ms_invoice_data-assignmentreference
                        reference1idbybusinesspartner = ms_invoice_data-reference1idbybusinesspartner
                        reference2idbybusinesspartner = ms_invoice_data-reference2idbybusinesspartner
                        reference3idbybusinesspartner = ms_invoice_data-reference3idbybusinesspartner
                        documentitemtext              = ms_invoice_data-documentitemtext
                        _currencyamount = VALUE #( ( currencyrole = '00'
                                                    journalentryitemamount = -1 * ms_invoice_data-invoiceamount
                                                    currency = ms_invoice_data-transactioncurrency  ) ) ) TO lt_aritem.

        <fs_je>-%param = VALUE #( companycode                  = ms_invoice_data-companycode
                                  documentreferenceid          = ms_invoice_data-customer
                                  createdbyuser                = sy-uname
                                  businesstransactiontype      = 'RFBU'
                                  accountingdocumenttype       = ms_bank_doctype-difference_document_type
                                  documentdate                 = ls_local_time_info-date
                                  postingdate                  = ls_local_time_info-date
                                  accountingdocumentheadertext = ms_invoice_data-invoicenumber
                                  _aritems                     = VALUE #( FOR wa_aritem  IN lt_aritem  ( CORRESPONDING #( wa_aritem  MAPPING _currencyamount = _currencyamount ) ) )
                                  _glitems                     = VALUE #( FOR wa_glitem  IN lt_glitem  ( CORRESPONDING #( wa_glitem  MAPPING _currencyamount = _currencyamount ) ) )
                                ).

        MODIFY ENTITIES OF i_journalentrytp
         ENTITY journalentry
         EXECUTE post FROM lt_je
         FAILED DATA(ls_failed)
         REPORTED DATA(ls_reported)
         MAPPED DATA(ls_mapped).
        IF ls_failed IS NOT INITIAL.
          LOOP AT ls_reported-journalentry INTO DATA(ls_message).
            lv_message = CONV #( ls_message-%msg->if_message~get_text( ) ).
            APPEND VALUE #( id = 'YDBS_MC'
                            type = 'E'
                            number = 000
                            message_v1 = lv_message(50)
                            message_v2 = lv_message+50(50)
                            message_v3 = lv_message+100(50)
                            message_v4 = lv_message+150(50) ) TO et_messages.
          ENDLOOP.
        ELSE.
          COMMIT ENTITIES BEGIN
           RESPONSE OF i_journalentrytp
           FAILED DATA(ls_commit_failed)
           REPORTED DATA(ls_commit_reported).
          COMMIT ENTITIES END.
          IF ls_commit_failed IS INITIAL.
            mv_temporary_fi_doc = ev_accountingdocument = VALUE #( ls_commit_reported-journalentry[ 1 ]-accountingdocument OPTIONAL ).
            mv_temporary_fi_doc_year = ev_fiscalyear = VALUE #( ls_commit_reported-journalentry[ 1 ]-fiscalyear OPTIONAL ).
            APPEND VALUE #( id = 'YDBS_MC'
                            type = 'S'
                            number = 005
                            message_v1 = ev_accountingdocument ) TO et_messages.
          ELSE.
            LOOP AT ls_commit_reported-journalentry INTO DATA(ls_reported_message).
              lv_message = CONV #( ls_reported_message-%msg->if_message~get_text( ) ).
              APPEND VALUE #( id = 'YDBS_MC'
                  type = 'E'
                  number = 000
                  message_v1 = lv_message(50)
                  message_v2 = lv_message+50(50)
                  message_v3 = lv_message+100(50)
                  message_v4 = lv_message+150(50) ) TO et_messages.
            ENDLOOP.

          ENDIF.
        ENDIF.

      CATCH cx_uuid_error INTO DATA(lx_error).
        lv_message = CONV #( lx_error->get_longtext(  ) ).
        APPEND VALUE #( id = 'YDBS_MC'
            type = 'E'
            number = 000
            message_v1 = lv_message(50)
            message_v2 = lv_message+50(50)
            message_v3 = lv_message+100(50)
            message_v4 = lv_message+150(50) ) TO et_messages.
    ENDTRY.
  ENDMETHOD.