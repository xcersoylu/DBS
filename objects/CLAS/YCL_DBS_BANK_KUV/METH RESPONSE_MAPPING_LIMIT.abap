  METHOD response_mapping_limit.
    TYPES : BEGIN OF ty_limit,
              availablelimit            TYPE string,
              branchcode                TYPE string,
              campaignname              TYPE string,
              guarantedinvoiceamount    TYPE string,
              isactive                  TYPE string,
              limit                     TYPE string,
              limitmaturitydate         TYPE string,
              notguarantedinvoiceamount TYPE string,
              notguarantedinvoicecount  TYPE string,
              pendinginvoiceamount      TYPE string,
              pendinginvoicecount       TYPE string,
              purchasercode             TYPE string,
              risk                      TYPE string,
              taxnumber                 TYPE string,
            END OF ty_limit,
            tt_limit TYPE TABLE OF ty_limit WITH DEFAULT KEY,
            BEGIN OF ty_result,
              toplulimitliste TYPE tt_limit,
            END OF ty_result,
            BEGIN OF ty_json,
              result_code    TYPE string,
              result_message TYPE string,
              result         TYPE ty_result,
            END OF ty_json.
    DATA ls_json TYPE ty_json.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json             = iv_response
      CHANGING
        data             = ls_json
    ).
    IF ls_json-result_code = '000'.
      DATA ls_limit TYPE ydbs_t_limit.
      DATA(ls_time_info) = ycl_dbs_common=>get_local_time(  ).
      READ TABLE ls_json-result-toplulimitliste INTO DATA(ls_limit_info) INDEX 1.
      ls_limit = VALUE #( companycode            = ms_service_info-companycode
                          bankinternalid         = ms_service_info-bankinternalid
                          customer               = ms_subscribe-customer
                          currency               = ms_service_info-currency
                          limit_timestamp        = ls_time_info-timestamp
                          limit_date             = ls_time_info-date
                          limit_time             = ls_time_info-time
                          total_limit            = ls_limit_info-limit
                          available_limit        = ls_limit_info-availablelimit
                          risk                   = ls_limit_info-risk
                          maturity_amount        = ls_limit_info-pendinginvoiceamount
                          maturity_invoice_count = ls_limit_info-pendinginvoicecount
                          over_limit             = ls_limit_info-notguarantedinvoiceamount ).
      MODIFY ydbs_t_limit FROM @ls_limit.
    ELSE.
    ENDIF.
  ENDMETHOD.