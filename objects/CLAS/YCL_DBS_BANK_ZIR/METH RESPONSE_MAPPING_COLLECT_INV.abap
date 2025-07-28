  METHOD response_mapping_collect_inv.
    TYPES : BEGIN OF ty_xml,
              cevapkodu               TYPE string,
              cevapmesaji             TYPE string,
              dbsno                   TYPE string,
              faturano                TYPE string,
              sonodemetarihi          TYPE string,
              faturatutari            TYPE string,
              faturadovizkodu         TYPE string,
              tahsilattutari          TYPE string,
              tahsilatdovizkodu       TYPE string,
              hesabakonanbloketutari  TYPE string,
              krediyekonanbloketutari TYPE string,
              kayitdurumu             TYPE string,
              kayitzaman              TYPE string,
              iptalzaman              TYPE string,
            END OF ty_xml.
    data lt_xml_response type table of ty_xml.
    DATA lv_day          TYPE c LENGTH 2.
    DATA lv_month        TYPE c LENGTH 2.
    DATA lv_year         TYPE c LENGTH 4.
    data lv_payment_date type d.
    DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = iv_response ).

      LOOP AT lt_xml INTO DATA(ls_xml_line) WHERE name = 'CevapKodu'
                                              AND node_type = 'CO_NT_ELEMENT_OPEN'.
        APPEND INITIAL LINE TO lt_xml_response ASSIGNING FIELD-SYMBOL(<ls_response_line>).
        DATA(lv_index) = sy-tabix + 1.
        LOOP AT lt_xml INTO DATA(ls_xml_line2) FROM lv_index.
          IF ( ls_xml_line2-name = 'CevapKodu' AND ls_xml_line2-node_type = 'CO_NT_ELEMENT_CLOSE' ).
            EXIT.
          ENDIF.
          CHECK ls_xml_line2-node_type = 'CO_NT_VALUE'.
          TRANSLATE ls_xml_line2-name TO UPPER CASE.
          ASSIGN COMPONENT ls_xml_line2-name OF STRUCTURE <ls_response_line> TO FIELD-SYMBOL(<lv_value>).
          CHECK sy-subrc = 0.
          <lv_value> = ls_xml_line2-value.
        ENDLOOP.
      ENDLOOP.

    READ TABLE lt_xml_response INTO DATA(ls_xml_response) WITH KEY faturano = ms_invoice_data-invoicenumber.
    IF ls_xml_response-cevapkodu = '0'. "başarılı

          lv_day = ls_xml_response-kayitzaman(2).
          IF lv_day CS '.'.
            CONCATENATE '0' ls_xml_response-kayitzaman(1) INTO lv_day.
            lv_month = ls_xml_response-kayitzaman+2(2).
            IF lv_month CS '.'.
              CONCATENATE '0' ls_xml_response-kayitzaman+2(1) INTO lv_month.
              lv_year = ls_xml_response-kayitzaman+4(4).
            ELSE.
              lv_year = ls_xml_response-kayitzaman+5(4).
            ENDIF.
          ELSE.
            lv_month = ls_xml_response-kayitzaman+3(2).
            IF lv_month CS '.'.
              CONCATENATE '0' ls_xml_response-kayitzaman+3(1) INTO lv_month.
              lv_year = ls_xml_response-kayitzaman+5(4).
            ELSE.
              lv_year = ls_xml_response-kayitzaman+6(4).
            ENDIF.
          ENDIF.
          CONCATENATE lv_year lv_month lv_day INTO lv_payment_date.

      es_collect_detail = VALUE #( payment_amount = ls_xml_response-faturatutari
                                   payment_date = lv_payment_date
                                   payment_currency = COND #(  when ls_xml_response-faturadovizkodu = '1' then 'USD'
                                                               when ls_xml_response-faturadovizkodu = '2' then 'EUR'
                                                               when ls_xml_response-faturadovizkodu = '88' then 'TRY'
                                                               ) ).
    ELSE.
      APPEND VALUE #( id = mc_id type = mc_error number = 004 ) TO rt_messages.
      adding_error_message(
        EXPORTING
          iv_message  = ls_xml_response-cevapmesaji
        CHANGING
          ct_messages = rt_messages
      ).
    ENDIF.
  ENDMETHOD.