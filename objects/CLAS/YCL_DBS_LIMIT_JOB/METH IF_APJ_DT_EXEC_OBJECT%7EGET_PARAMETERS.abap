  METHOD if_apj_dt_exec_object~get_parameters.

    et_parameter_def = VALUE #( ( selname = 'S_CCODE'
                                  kind = if_apj_dt_exec_object=>select_option
                                  datatype = 'C'
                                  length = 4
                                  param_text = 'Şirket Kodu'
                                  changeable_ind = abap_true )
                                ( selname = 'S_BANKK'
                                  kind = if_apj_dt_exec_object=>select_option
                                  datatype = 'C'
                                  length = 15
                                  param_text = 'Banka Anahtarı'
                                  changeable_ind = abap_true )
                                ( selname = 'S_CUST'
                                  kind = if_apj_dt_exec_object=>select_option
                                  datatype = 'C'
                                  length = 10
                                  param_text = 'Müşteri No'
                                  changeable_ind = abap_true )
                                  ).

  ENDMETHOD.