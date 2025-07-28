  METHOD get_log.
    SELECT SINGLE * FROM ydbs_t_log WHERE companycode = @ms_invoice_data-companycode
                                      AND accountingdocument = @ms_invoice_data-accountingdocument
                                      AND fiscalyear = @ms_invoice_data-fiscalyear
                                      AND accountingdocumentitem = @ms_invoice_data-accountingdocumentitem
                     INTO @rs_log.

  ENDMETHOD.