  METHOD response_mapping_send_invoice.
    DATA(lt_xml) = ycl_dbs_common=>parse_xml( EXPORTING iv_xml_string  = iv_response ).
    READ TABLE lt_xml INTO DATA(ls_bankstatus) WITH KEY node_type = mc_value_node name = 'StatusCode'.
    IF ls_bankstatus-value = '0000'.
      get_batch_trailer(  ).
    ENDIF.
  ENDMETHOD.