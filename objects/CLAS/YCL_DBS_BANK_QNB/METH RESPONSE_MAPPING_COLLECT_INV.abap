  METHOD response_mapping_collect_inv.
    TYPES : BEGIN OF ty_xml,
              bayireferans        TYPE string,
              bayiunvani          TYPE string,
              blokajkodu          TYPE string,
              dovizkodu           TYPE string,
              faturano            TYPE string,
              faturatutari        TYPE string,
              faturayuklemetarihi TYPE string,
              garantidisitutar    TYPE string,
              garantiicitutar     TYPE string,
              odemestatusu        TYPE string,
              sonodemetarihi      TYPE string,
              tahakkuktipi        TYPE string,
              tahsilattarihi      TYPE string,
              tahsilattutari      TYPE string,
            END OF ty_xml.
    DATA lt_xml_response TYPE TABLE OF ty_xml.
    DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = iv_response ).
    READ TABLE lt_xml INTO DATA(ls_error_code) WITH KEY node_type = mc_value_node name = 'errorCode'.
    READ TABLE lt_xml INTO DATA(ls_error_text) WITH KEY node_type = mc_value_node name = 'errorDescription'.
    IF ls_error_code-value = 'THS01'. "başarılı
      LOOP AT lt_xml INTO DATA(ls_xml_line) WHERE name = 'bayiReferans'
                                              AND node_type = 'CO_NT_ELEMENT_OPEN'.
        APPEND INITIAL LINE TO lt_xml_response ASSIGNING FIELD-SYMBOL(<ls_response_line>).
        DATA(lv_index) = sy-tabix + 1.
        LOOP AT lt_xml INTO DATA(ls_xml_line2) FROM lv_index.
          IF ( ls_xml_line2-name = 'bayiReferans' AND ls_xml_line2-node_type = 'CO_NT_ELEMENT_CLOSE' ).
            EXIT.
          ENDIF.
          CHECK ls_xml_line2-node_type = 'CO_NT_VALUE'.
          TRANSLATE ls_xml_line2-name TO UPPER CASE.
          ASSIGN COMPONENT ls_xml_line2-name OF STRUCTURE <ls_response_line> TO FIELD-SYMBOL(<lv_value>).
          CHECK sy-subrc = 0.
          <lv_value> = ls_xml_line2-value.
        ENDLOOP.
      ENDLOOP.
       READ TABLE lt_xml_response INto data(ls_xml_response) with key faturano = ms_invoice_data-invoicenumber
                                                                      odemestatusu = 'T'.
      es_collect_detail = VALUE #( payment_amount = ls_xml_response-faturatutari
                                   payment_date = |{ ls_xml_response-sonodemetarihi(4) }{ ls_xml_response-sonodemetarihi+5(2) }{ ls_xml_response-sonodemetarihi+8(2) }|
                                   payment_currency = ls_xml_response-dovizkodu ).
    ELSE.
      APPEND VALUE #( id = mc_id type = mc_error number = 004 ) TO rt_messages.
      APPEND VALUE #( id = mc_id type = mc_error number = 000 message_v1 = ls_error_text-value(50)
                                                             message_v2 = ls_error_text-value+50(50)
                                                             message_v3 = ls_error_text-value+100(50)
                                                             message_v4 = ls_error_text-value+150(50) ) TO rt_messages.
    ENDIF.
  ENDMETHOD.