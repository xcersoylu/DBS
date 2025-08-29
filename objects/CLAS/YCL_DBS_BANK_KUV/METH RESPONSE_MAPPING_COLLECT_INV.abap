  METHOD response_mapping_collect_inv.
    TYPES : BEGIN OF ty_collect,
              amount                  TYPE string,
              campaignname            TYPE string,
              fec                     TYPE string,
              invoiceduedate          TYPE string,
              invoiceno               TYPE string,
              lastcollectdate         TYPE string,
              partialguarenteedamount TYPE string,
              purchasercode           TYPE string,
              status                  TYPE string,
              statusdetail            TYPE string,
              totitle                 TYPE string,
              trandate                TYPE string,
            END OF ty_collect,
            tt_collect TYPE TABLE OF ty_collect WITH DEFAULT KEY,
            BEGIN OF ty_liste,
              faturaliste TYPE tt_collect,
            END OF ty_liste,
            BEGIN OF ty_json,
              result_code    TYPE string,
              result_message TYPE string,
              result         TYPE ty_liste,
            END OF ty_json.
    DATA ls_json TYPE ty_json.
    /ui2/cl_json=>deserialize(
      EXPORTING
        json             = iv_response
      CHANGING
        data             = ls_json
    ).

    IF ls_json-result_code = '000'.
      APPEND VALUE #( id = mc_id type = mc_success number = 003 ) TO rt_messages.
      READ TABLE ls_json-result-faturaliste INTO DATA(ls_response) WITH KEY invoiceno = ms_invoice_data-invoicenumber
                                                                            status = '1'."1-tahsil edildi, 2-tahsil edilmedi
      es_collect_detail = VALUE #( payment_amount = ls_response-amount
                                   payment_date = ls_response-trandate
                                   payment_currency = ls_response-fec ).
    ELSE.
      APPEND VALUE #( id = mc_id type = mc_error number = 004 ) TO rt_messages.
      adding_error_message(
        EXPORTING
          iv_message  = ls_json-result_message
        CHANGING
          ct_messages = rt_messages
      ).
    ENDIF.

  ENDMETHOD.