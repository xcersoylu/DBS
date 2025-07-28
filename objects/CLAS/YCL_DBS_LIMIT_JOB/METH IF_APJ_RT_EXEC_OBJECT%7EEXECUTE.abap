  METHOD if_apj_rt_exec_object~execute.
    TYPES : BEGIN OF ty_ccode_range,
              sign   TYPE c LENGTH 1,
              option TYPE c LENGTH 2,
              low    TYPE bukrs,
              high   TYPE bukrs,
            END OF ty_ccode_range,
            BEGIN OF ty_bankk_range,
              sign   TYPE c LENGTH 1,
              option TYPE c LENGTH 2,
              low    TYPE bankk,
              high   TYPE bankk,
            END OF ty_bankk_range,
            BEGIN OF ty_customer_range,
              sign   TYPE c LENGTH 1,
              option TYPE c LENGTH 2,
              low    TYPE kunnr,
              high   TYPE kunnr,
            END OF ty_customer_range,
            tt_ccode_range    TYPE TABLE OF ty_ccode_range WITH EMPTY KEY,
            tt_bankk_range    TYPE TABLE OF ty_bankk_range WITH EMPTY KEY,
            tt_customer_range TYPE TABLE OF ty_customer_range WITH EMPTY KEY.
    DATA lr_ccode TYPE tt_ccode_range.
    DATA lr_bankk TYPE tt_bankk_range.
    DATA lr_customer TYPE tt_customer_range.
    DATA lt_messages TYPE ydbs_tt_bapiret2.
    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'S_CCODE'.
          APPEND VALUE #( sign = ls_parameter-sign
                          option = ls_parameter-option
                          low = ls_parameter-low
                          high = ls_parameter-high ) TO lr_ccode.
        WHEN 'S_BANKK'.
          APPEND VALUE #( sign = ls_parameter-sign
                          option = ls_parameter-option
                          low = ls_parameter-low
                          high = ls_parameter-high ) TO lr_bankk.
        WHEN 'S_CUST'.
          APPEND VALUE #( sign = ls_parameter-sign
                          option = ls_parameter-option
                          low = ls_parameter-low
                          high = ls_parameter-high ) TO lr_customer.
      ENDCASE.
    ENDLOOP.
    TRY.
        DATA(lo_log) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create( object = 'YDBS_APP_LOG'
                                                                                       subobject = 'YDBS_LIMIT_LOG' ) ).
      CATCH cx_bali_runtime.
    ENDTRY.
    SELECT * FROM ydbs_ddl_i_limit
             WHERE companycode IN @lr_ccode
               AND bankinternalid IN @lr_bankk
               AND customer IN @lr_customer
               INTO TABLE @DATA(lt_limit).
    IF sy-subrc = 0.
      LOOP AT lt_limit INTO DATA(ls_limit).
        DATA(lo_limit) = ycl_dbs_bank=>factory( iv_bankinternalid = ls_limit-bankinternalid
                                                iv_companycode    = ls_limit-companycode
                                                iv_customer       = ls_limit-customer ).
        lo_limit->call_api( EXPORTING iv_api_type = 'L' IMPORTING et_messages = lt_messages ).

        IF lt_messages IS NOT INITIAL.
          LOOP AT lt_messages INTO DATA(ls_message).
            DATA(lo_message) = cl_bali_message_setter=>create( severity = if_bali_constants=>c_severity_information
                                                               id = ls_message-id
                                                               number = ls_message-number
                                                               variable_1 =  ls_message-message_v1
                                                               variable_2 =  ls_message-message_v2
                                                               variable_3 =  ls_message-message_v3
                                                               variable_4 =  ls_message-message_v4 ).
            TRY.
                lo_log->add_item( lo_message ).
              CATCH cx_bali_runtime.
            ENDTRY.
          ENDLOOP.
          CLEAR lt_messages.
          FREE lo_limit. CLEAR lo_limit.
        ENDIF.

      ENDLOOP.
    ELSE.
      lo_message = cl_bali_message_setter=>create( severity = if_bali_constants=>c_severity_information
                                                         id = 'YDBS_MC'
                                                         number = 001 ).
      TRY.
          lo_log->add_item( lo_message ).
        CATCH cx_bali_runtime.
      ENDTRY.
    ENDIF.

  ENDMETHOD.