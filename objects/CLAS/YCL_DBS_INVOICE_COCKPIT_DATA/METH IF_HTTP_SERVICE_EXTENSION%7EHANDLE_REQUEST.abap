  METHOD if_http_service_extension~handle_request.
    DATA(lv_request_body) = request->get_text( ).
    DATA(lv_get_method) = request->get_method( ).
    DATA lt_send_documents TYPE ydbs_tt_invoice_cockpit_data.
    /ui2/cl_json=>deserialize( EXPORTING json = lv_request_body CHANGING data = ms_request ).
    SELECT value_low AS value ,
           text AS description
       FROM ddcds_customer_domain_value_t( p_domain_name = 'YDBS_D_INVOICESTATUS' )
       WHERE language = @sy-langu
     ORDER BY value
    INTO TABLE @DATA(lt_invoicestatus).

    SELECT * FROM ydbs_t_subsmap
      WHERE companycode IN @ms_request-companycode
        AND bankinternalid IN @ms_request-bankinternalid
        AND customer IN @ms_request-customer
        INTO TABLE @DATA(lt_subsmap).
    DATA(lt_priority) = lt_subsmap.
    DELETE lt_priority WHERE priority IS INITIAL.
    IF lt_priority IS NOT INITIAL.
      LOOP AT lt_priority INTO DATA(ls_priority).
        DELETE lt_subsmap WHERE companycode = ls_priority-companycode
                            AND bankinternalid <> ls_priority-bankinternalid
                            AND customer = ls_priority-customer.
      ENDLOOP.
    ENDIF.
*gönderilmemişler
    SELECT bsid~companycode,
           bsid~accountingdocument,
           bsid~fiscalyear,
           bsid~accountingdocumentitem,
           bsid~customer,
           customer~organizationbpname1 AS customername,
           customer~organizationbpname2 AS customersurname,
           subscriber~bankinternalid,
           concat( concat( bsid~accountingdocument , bsid~accountingdocumentitem ) , substring( bsid~fiscalyear,3,2 ) ) AS invoicenumber,
           customer~taxnumber1,
           customer~taxnumber2,
           subscriber~subscriber_number AS subscribernumber,
           bsid~accountingdocumenttype,
           bsid~documentdate,
           bsid~postingdate,
           bsid~duecalculationbasedate,
           bsid~cashdiscount1days,
           dats_add_days( bsid~duecalculationbasedate , CAST( CAST( bsid~cashdiscount1days AS CHAR( 5 ) ) AS INT4 ) ) AS invoiceduedate,
           bsid~absoluteamountintransaccrcy,
           bsid~transactioncurrency,
           bsid~absoluteamountintransaccrcy AS invoiceamount,
           bsid~documentreferenceid,
           bsid~paymentmethod,
           bsid~paymentblockingreason,
           bsid~reference1idbybusinesspartner,
           bsid~reference2idbybusinesspartner,
           bsid~reference3idbybusinesspartner,
           bsid~assignmentreference,
           bsid~originalreferencedocument,
           bsid~documentitemtext
      FROM @lt_subsmap AS subscriber INNER JOIN i_customer AS customer ON customer~customer = subscriber~customer
      INNER JOIN ydbs_ddl_i_bsid AS bsid ON bsid~customer = subscriber~customer
                                        AND bsid~companycode = subscriber~companycode
      WHERE bsid~documentdate IN @ms_request-documentdate
        AND bsid~debitcreditcode = 'S'
        AND EXISTS ( SELECT * FROM ydbs_t_doctype WHERE companycode = bsid~companycode AND document_type = bsid~accountingdocumenttype )
      INTO CORRESPONDING FIELDS OF TABLE @ms_response-data.
    IF sy-subrc = 0.
      SORT ms_response-data BY companycode accountingdocument fiscalyear accountingdocumentitem bankinternalid.
      DELETE ADJACENT DUPLICATES FROM ms_response-data COMPARING companycode accountingdocument fiscalyear accountingdocumentitem bankinternalid.
      SELECT limit~* FROM ydbs_t_limit AS limit INNER JOIN @ms_response-data AS itab ON limit~companycode = itab~companycode
                                                                              AND limit~bankinternalid = itab~bankinternalid
                                                                              AND limit~customer = itab~customer
                                                                              AND limit~currency = itab~transactioncurrency
      ORDER BY limit_timestamp DESCENDING
      INTO TABLE @DATA(lt_limit).
      SELECT log~* FROM ydbs_t_log AS log INNER JOIN @ms_response-data AS itab ON log~companycode = itab~companycode
                                                                              AND log~accountingdocument = itab~accountingdocument
                                                                              AND log~fiscalyear = itab~fiscalyear
                                                                              AND log~accountingdocumentitem = itab~accountingdocumentitem
      ORDER BY log~companycode,log~accountingdocument,log~fiscalyear,log~accountingdocumentitem
      INTO TABLE @DATA(lt_log).
      LOOP AT ms_response-data ASSIGNING FIELD-SYMBOL(<fs_data>).
        READ TABLE lt_limit INTO DATA(ls_limit) WITH KEY companycode = <fs_data>-companycode
                                                         bankinternalid = <fs_data>-bankinternalid
                                                         customer = <fs_data>-customer
                                                         currency = <fs_data>-transactioncurrency.
        IF sy-subrc = 0.
          <fs_data>-limit_date = ls_limit-limit_date.
          <fs_data>-limit_time = ls_limit-limit_time.
          <fs_data>-total_limit = ls_limit-total_limit.
          <fs_data>-available_limit = ls_limit-available_limit.
          <fs_data>-risk = ls_limit-risk.
          <fs_data>-maturity_amount = ls_limit-maturity_amount.
          <fs_data>-maturity_invoice_count = ls_limit-maturity_invoice_count.
          <fs_data>-over_limit = ls_limit-over_limit.
        ENDIF.
        READ TABLE lt_log INTO DATA(ls_log) WITH KEY companycode = <fs_data>-companycode
                                                     accountingdocument = <fs_data>-accountingdocument
                                                     fiscalyear = <fs_data>-fiscalyear
                                                     accountingdocumentitem = <fs_data>-accountingdocumentitem BINARY SEARCH.
        IF sy-subrc = 0.
          <fs_data>-invoicenumber = ls_log-invoicenumber.
          <fs_data>-invoiceduedate = ls_log-invoiceduedate.
          <fs_data>-invoiceamount  = ls_log-invoiceamount.
          <fs_data>-transactioncurrency = ls_log-transactioncurrency.
          <fs_data>-invoicestatus = ls_log-invoicestatus.
          <fs_data>-invoicestatustext = VALUE #( lt_invoicestatus[ value = ls_log-invoicestatus ]-description OPTIONAL ).
        ELSE.
          <fs_data>-invoicestatus = 'R'.
          <fs_data>-invoicestatustext = VALUE #( lt_invoicestatus[ value = 'R' ]-description OPTIONAL ).
        ENDIF.
      ENDLOOP.
    ENDIF.
*******gönderilmişler*****
    SELECT * FROM ydbs_t_log
    WHERE temporary_document IS NOT INITIAL
      AND clearing_document IS NOT INITIAL
      INTO TABLE @DATA(lt_send).
    IF sy-subrc = 0.
      SELECT bkpf~companycode,
             bkpf~accountingdocument,
             bkpf~fiscalyear,
             bseg~accountingdocumentitem,
             bseg~customer,
             customer~organizationbpname1 AS customername,
             customer~organizationbpname2 AS customersurname,
             subscriber~bankinternalid,
             send~invoicenumber,
             customer~taxnumber1,
             customer~taxnumber2,
             subscriber~subscriber_number AS subscribernumber,
             bseg~accountingdocumenttype,
             bseg~documentdate,
             bseg~postingdate,
             bseg~duecalculationbasedate,
             bseg~cashdiscount1days,
             send~invoiceduedate,
             bseg~absoluteamountintransaccrcy,
             bseg~transactioncurrency,
             bseg~absoluteamountintransaccrcy AS invoiceamount,
             bkpf~documentreferenceid,
             bseg~paymentmethod,
             bseg~paymentblockingreason,
             bseg~reference1idbybusinesspartner,
             bseg~reference2idbybusinesspartner,
             bseg~reference3idbybusinesspartner,
             bseg~assignmentreference,
             bseg~originalreferencedocument,
             bseg~documentitemtext,
             send~invoicestatus
       FROM @lt_send AS send INNER JOIN i_journalentry            AS bkpf ON bkpf~companycode = send~companycode
                                                                         AND bkpf~accountingdocument = send~accountingdocument
                                                                         AND bkpf~fiscalyear = send~fiscalyear
                             INNER JOIN i_operationalacctgdocitem AS bseg ON bseg~companycode        = send~companycode
                                                                         AND bseg~accountingdocument = send~accountingdocument
                                                                         AND bseg~fiscalyear         = send~fiscalyear
                                                                         AND bseg~accountingdocumentitem = send~accountingdocumentitem
                             INNER JOIN i_customer AS customer ON customer~customer = bseg~customer
                             INNER JOIN ydbs_t_subsmap AS subscriber ON subscriber~companycode = send~companycode
                                                                    AND subscriber~bankinternalid = send~bankinternalid
                                                                    AND subscriber~customer = customer~customer
              INTO CORRESPONDING FIELDS OF TABLE @lt_send_documents.
      IF sy-subrc = 0.
        SORT lt_send_documents BY companycode accountingdocument fiscalyear accountingdocumentitem bankinternalid.
        DELETE ADJACENT DUPLICATES FROM lt_send_documents COMPARING companycode accountingdocument fiscalyear accountingdocumentitem bankinternalid.
        SELECT limit~* FROM ydbs_t_limit AS limit INNER JOIN @lt_send_documents AS itab ON limit~companycode = itab~companycode
                                                                                AND limit~bankinternalid = itab~bankinternalid
                                                                                AND limit~customer = itab~customer
                                                                                AND limit~currency = itab~transactioncurrency
        ORDER BY limit_timestamp DESCENDING
        INTO TABLE @DATA(lt_send_limit).

        LOOP AT lt_send_documents ASSIGNING FIELD-SYMBOL(<ls_send_data>).
          READ TABLE lt_limit INTO DATA(ls_send_limit) WITH KEY companycode = <ls_send_data>-companycode
                                                             bankinternalid = <ls_send_data>-bankinternalid
                                                                   customer = <ls_send_data>-customer
                                                                   currency = <ls_send_data>-transactioncurrency.
          IF sy-subrc = 0.
            <ls_send_data>-limit_date             = ls_send_limit-limit_date.
            <ls_send_data>-limit_time             = ls_send_limit-limit_time.
            <ls_send_data>-total_limit            = ls_send_limit-total_limit.
            <ls_send_data>-available_limit        = ls_send_limit-available_limit.
            <ls_send_data>-risk                   = ls_send_limit-risk.
            <ls_send_data>-maturity_amount        = ls_send_limit-maturity_amount.
            <ls_send_data>-maturity_invoice_count = ls_send_limit-maturity_invoice_count.
            <ls_send_data>-over_limit             = ls_send_limit-over_limit.
          ENDIF.
          <ls_send_data>-invoicestatustext = VALUE #( lt_invoicestatus[ value = 'R' ]-description OPTIONAL ).
        ENDLOOP.
        APPEND LINES OF lt_send_documents TO ms_response-data.
      ENDIF.
    ENDIF.
*************************************
    DATA(lv_response_body) = /ui2/cl_json=>serialize( EXPORTING data = ms_response ).
    response->set_text( lv_response_body ).
    response->set_header_field( i_name = mc_header_content i_value = mc_content_type ).

  ENDMETHOD.