  METHOD response_mapping_collect_inv.
    TYPES : BEGIN OF ty_satir,
              aboneno     TYPE string,
              faturano    TYPE string,
              fattutar    TYPE string,
              doviz       TYPE string,
              sonodmtarih TYPE string,
              odntutarytl TYPE string,
              odntutarusd TYPE string,
              refno       TYPE string,
              statu       TYPE string,
            END OF ty_satir,
            BEGIN OF ty_detay,
              trxno    TYPE string,
              seqno    TYPE string,
              islemtrh TYPE string,
              islemtip TYPE string,
              urun     TYPE string,
              kurum    TYPE string,
              satir    TYPE ty_satir,
            END OF ty_detay,
            BEGIN OF ty_fatura_detay,
              detay TYPE ty_detay,
            END OF ty_fatura_detay,
            tt_fatura_detay TYPE TABLE OF ty_fatura_detay WITH EMPTY KEY,
            BEGIN OF ty_xml,
              faturadetay TYPE tt_fatura_detay,
            END OF ty_xml.
    DATA lt_xml_response TYPE tt_fatura_detay. "ty_xml.
    FIELD-SYMBOLS <ls_satir> TYPE ty_satir.
    FIELD-SYMBOLS <ls_detay> TYPE ty_detay.
    DATA(lv_response) = iv_response.
    REPLACE ALL OCCURRENCES OF '&lt;' IN lv_response WITH '<'.
    REPLACE ALL OCCURRENCES OF '&gt;' IN lv_response WITH '>'.
    DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = lv_response ).
    READ TABLE lt_xml INTO DATA(ls_error_code) WITH KEY node_type = mc_value_node name = 'pErrCode'.
    READ TABLE lt_xml INTO DATA(ls_error_text) WITH KEY node_type = mc_value_node name = 'pErrText'.
    IF ls_error_code-value = '0'. "başarılı
      LOOP AT lt_xml INTO DATA(ls_xml_line) WHERE name = 'FaturaDetay'
                                              AND node_type = 'CO_NT_ELEMENT_OPEN'.
        APPEND INITIAL LINE TO lt_xml_response ASSIGNING FIELD-SYMBOL(<ls_response_line>).
        DATA(lv_index) = sy-tabix + 1.
        LOOP AT lt_xml INTO DATA(ls_xml_line2) FROM lv_index.
          IF ( ls_xml_line2-name = 'FaturaDetay' AND ls_xml_line2-node_type = 'CO_NT_ELEMENT_CLOSE' ).
            EXIT.
          ENDIF.
          CHECK ls_xml_line2-node_type = 'CO_NT_VALUE'.
          CASE ls_xml_line2-name.
            WHEN 'Detay'.
              TRANSLATE ls_xml_line2-name TO UPPER CASE.
              ASSIGN COMPONENT ls_xml_line2-name OF STRUCTURE <ls_response_line> TO <ls_detay>.
            WHEN 'TRXNO' OR 'SEQNO' OR 'ISLEMTRH' OR 'ISLEMTIP' OR 'URUN' OR 'KURUM'.
              TRANSLATE ls_xml_line2-name TO UPPER CASE.
              ASSIGN COMPONENT ls_xml_line2-name OF STRUCTURE <ls_detay> TO FIELD-SYMBOL(<lv_value>).
              CHECK sy-subrc = 0.
              <lv_value> = ls_xml_line2-value.
            WHEN 'SATIR'.
              TRANSLATE ls_xml_line2-name TO UPPER CASE.
              ASSIGN COMPONENT ls_xml_line2-name OF STRUCTURE <ls_detay> TO <ls_satir>.
            WHEN 'AboneNo' OR 'FaturaNo' OR 'FatTutar' OR 'Doviz' OR 'SonOdmTarih' OR 'OdnTutarYTL' OR 'OdnTutarUSD' OR 'RefNo' OR 'Statu'.
              TRANSLATE ls_xml_line2-name TO UPPER CASE.
              ASSIGN COMPONENT ls_xml_line2-name OF STRUCTURE <ls_satir> TO <lv_value>.
              CHECK sy-subrc = 0.
              <lv_value> = ls_xml_line2-value.
          ENDCASE.
        ENDLOOP.
      ENDLOOP.
      READ TABLE lt_xml_response INTO DATA(ls_xml_response) WITH KEY detay-satir-faturano = ms_invoice_data-invoicenumber.
      SHIFT ls_xml_response-detay-satir-fattutar    LEFT DELETING LEADING '0'.
      SHIFT ls_xml_response-detay-satir-odntutarytl LEFT DELETING LEADING '0'.
          IF ls_xml_response-detay-satir-odntutarytl IS NOT INITIAL AND ls_xml_response-detay-satir-odntutarytl GT 0.
          es_collect_detail-payment_amount = ls_xml_response-detay-satir-odntutarytl.
          es_collect_detail-payment_currency = 'TRY'.
          ELSE.
          es_collect_detail-payment_amount = ls_xml_response-detay-satir-fattutar.
          es_collect_detail-payment_currency = ls_xml_response-detay-satir-doviz.
          ENDIF.
          CONCATENATE ls_xml_response-detay-islemtrh(4) ls_xml_response-detay-islemtrh+5(2)
          ls_xml_response-detay-islemtrh+8(2) INTO es_collect_detail-payment_date.
    ELSE.
      APPEND VALUE #( id = mc_id type = mc_error number = 004 ) TO rt_messages.
      adding_error_message(
        EXPORTING
          iv_message  = ls_error_text-value
        CHANGING
          ct_messages = rt_messages
      ).
    ENDIF.
  ENDMETHOD.