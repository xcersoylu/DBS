  METHOD response_mapping_delete_inv.
    TYPES : BEGIN OF ty_response,
              aciklama       TYPE string,
              banka_kayit_no TYPE string,
              durum_kodu     TYPE string,
              fatura_no      TYPE string,
              fatura_tarihi  TYPE string,
              fatura_tutari  TYPE wrbtr,
              musteri_dbs_no TYPE string,
              odeme_tarihi   TYPE string,
              odeme_tutari   TYPE string,
              para_birimi    TYPE waers,
              vade_tarihi    TYPE string,
            END OF ty_response,
            BEGIN OF ty_result,
              dbs_fatura_iptalresult TYPE ty_response,
            END OF ty_result,
            BEGIN OF ty_error,
              errorcode    TYPE string,
              errormessage TYPE string,
            END OF ty_error,
            BEGIN OF ty_json,
              errordetails          TYPE ty_error,
              faturaiptalresponse   TYPE ty_result,
              faturasorgularesponse TYPE string,
              faturayukleresponse   TYPE string,
              limitsorgularesponse  TYPE string,
            END OF ty_json.
    DATA ls_json TYPE ty_json.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json             = iv_response
      CHANGING
        data             = ls_json
    ).
    IF ls_json-errordetails-errorcode IS INITIAL.
      APPEND VALUE #( id = mc_id type = mc_success number = 003 ) TO rt_messages.
    ELSE.
      APPEND VALUE #( id = mc_id type = mc_error number = 004 ) TO rt_messages.
      adding_error_message(
        EXPORTING
          iv_message  = ls_json-errordetails-errormessage
        CHANGING
          ct_messages = rt_messages
      ).
    ENDIF.
  ENDMETHOD.