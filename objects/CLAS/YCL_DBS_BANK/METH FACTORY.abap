  METHOD factory.
    SELECT SINGLE * FROM ydbs_t_service WHERE companycode = @iv_companycode
                                          AND bankinternalid = @iv_bankinternalid
    INTO @DATA(ls_service_info).
    IF sy-subrc = 0.
      IF ls_service_info IS NOT INITIAL.
        CREATE OBJECT ro_object TYPE (ls_service_info-class_name).
        ro_object->ms_service_info = ls_service_info.
        SELECT SINGLE * FROM ydbs_t_subsmap WHERE companycode = @iv_companycode
                                              AND bankinternalid = @iv_bankinternalid
                                              AND customer = @iv_customer
        INTO @ro_object->ms_subscribe.
        ro_object->ms_invoice_data = iv_invoice_data.
      ENDIF.
    ENDIF.
  ENDMETHOD.