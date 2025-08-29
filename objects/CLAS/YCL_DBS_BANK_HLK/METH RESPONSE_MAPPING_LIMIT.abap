  METHOD response_mapping_limit.
    TYPES : BEGIN OF ty_kullanilan_limit,
              fatura_adet       TYPE string,
              fatura_toplam     TYPE wrbtr,
              fatura_toplam_try TYPE wrbtr,
              para_birimi       TYPE waers,
            END OF ty_kullanilan_limit,
            tt_kullanilan_limit TYPE TABLE OF ty_kullanilan_limit WITH DEFAULT KEY,
            BEGIN OF ty_limit_result,
              gayri_nakdi_risk     TYPE wrbtr,
              kullanilabilir_limit TYPE wrbtr,
              kullanilan_limit     TYPE tt_kullanilan_limit,
              musteri_dbs_no       TYPE string,
              nakdi_risk           TYPE wrbtr,
              toplam_limit         TYPE wrbtr,
              zaman_damgasi        TYPE string,
            END OF ty_limit_result,
            tt_limit_result TYPE TABLE OF ty_limit_result WITH DEFAULT KEY,
            BEGIN OF ty_limit_response,
              dbs_limit_sorgularesult TYPE tt_limit_result,
            END OF ty_limit_response,
            BEGIN OF ty_error,
              errorcode    TYPE string,
              errormessage TYPE string,
            END OF ty_error,
            BEGIN OF ty_json,
              errordetails          TYPE ty_error,
              faturaduzenleresponse TYPE string,
              faturaiptalresponse   TYPE string,
              faturasorgularesponse TYPE string,
              faturayukleresponse   TYPE string,
              limitsorgularesponse  TYPE ty_limit_response,
              pesinodemeresponse    TYPE string,
            END OF ty_json.
    DATA ls_json TYPE ty_json.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json             = iv_response
      CHANGING
        data             = ls_json
    ).
    IF ls_json-errordetails-errorcode IS INITIAL.
      DATA ls_limit TYPE ydbs_t_limit.
      DATA(ls_time_info) = ycl_dbs_common=>get_local_time(  ).
      READ TABLE ls_json-limitsorgularesponse-dbs_limit_sorgularesult INTO DATA(ls_result) INDEX 1.

      ls_limit = VALUE #( companycode    = ms_service_info-companycode
                          bankinternalid = ms_service_info-bankinternalid
                          customer       = ms_subscribe-customer
                          currency       = ms_service_info-currency
                          limit_timestamp = ls_time_info-timestamp
                          limit_date      = ls_time_info-date
                          limit_time      = ls_time_info-time
                          total_limit     = ls_result-toplam_limit
                          available_limit = ls_result-kullanilabilir_limit
                          risk            = ls_result-nakdi_risk
                          maturity_amount = REDUCE #( INIT x TYPE ydbs_e_maturity_amount FOR wa IN ls_result-kullanilan_limit
                                                                    NEXT x = x + wa-fatura_toplam_try )
                          maturity_invoice_count = REDUCE #( INIT y TYPE ydbs_e_maturity_invoice_count FOR wa2 IN ls_result-kullanilan_limit
                                                                    NEXT y = y + wa2-fatura_adet )
                          ).
      MODIFY ydbs_t_limit FROM @ls_limit.
    ELSE.
      adding_error_message(
        EXPORTING
          iv_message  = ls_json-errordetails-errormessage
        CHANGING
          ct_messages = rt_messages
      ).
    ENDIF.
  ENDMETHOD.