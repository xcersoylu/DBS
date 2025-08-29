  METHOD response_mapping_send_invoice.
    TYPES: BEGIN OF ty_json,
             errorcode    TYPE string,
             errormessage TYPE string,
           END OF ty_json.
    DATA ls_json TYPE ty_json.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json             = iv_response
      CHANGING
        data             = ls_json
    ).
    IF ls_json-errorcode = '000'.
      APPEND VALUE #( id = mc_id type = mc_success number = 003 ) TO rt_messages.
    ELSE.
      APPEND VALUE #( id = mc_id type = mc_error number = 004 ) TO rt_messages.
      adding_error_message(
        EXPORTING
          iv_message  = ls_json-errormessage
        CHANGING
          ct_messages = rt_messages
      ).
    ENDIF.
  ENDMETHOD.