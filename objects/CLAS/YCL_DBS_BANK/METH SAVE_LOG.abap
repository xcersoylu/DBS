  METHOD save_log.
    DATA ls_log TYPE ydbs_t_log.
    CASE mv_api_type.
      WHEN mc_send.
        ls_log = VALUE #( companycode             = ms_invoice_data-companycode
                          accountingdocument      = ms_invoice_data-accountingdocument
                          fiscalyear              = ms_invoice_data-fiscalyear
                          accountingdocumentitem  = ms_invoice_data-accountingdocumentitem
                          invoicenumber           = ms_invoice_data-invoicenumber
                          invoiceduedate          = ms_invoice_data-invoiceduedate
                          invoiceamount           = ms_invoice_data-invoiceamount
                          transactioncurrency     = ms_invoice_data-transactioncurrency
                          invoicestatus           = iv_invoicestatus  ).
        MODIFY ydbs_t_log FROM @ls_log.
      WHEN mc_updated.
        UPDATE ydbs_t_log
           SET invoicenumber           = @ms_invoice_data-invoicenumber,
               invoiceduedate          = @ms_invoice_data-invoiceduedate,
               invoiceamount           = @ms_invoice_data-invoiceamount,
               transactioncurrency     = @ms_invoice_data-transactioncurrency,
               invoicestatus           = @iv_invoicestatus
         WHERE companycode             = @ms_invoice_data-companycode
           AND accountingdocument      = @ms_invoice_data-accountingdocument
           AND fiscalyear              = @ms_invoice_data-fiscalyear
           AND accountingdocumentitem  = @ms_invoice_data-accountingdocumentitem.
      WHEN mc_deleted.
        UPDATE ydbs_t_log
           SET invoicenumber           = @ms_invoice_data-invoicenumber,
               invoiceduedate          = @ms_invoice_data-invoiceduedate,
               invoiceamount           = @ms_invoice_data-invoiceamount,
               transactioncurrency     = @ms_invoice_data-transactioncurrency,
               invoicestatus           = @iv_invoicestatus
         WHERE companycode             = @ms_invoice_data-companycode
           AND accountingdocument      = @ms_invoice_data-accountingdocument
           AND fiscalyear              = @ms_invoice_data-fiscalyear
           AND accountingdocumentitem  = @ms_invoice_data-accountingdocumentitem.
      WHEN mc_collected.
        UPDATE ydbs_t_log
           SET invoicenumber           = @ms_invoice_data-invoicenumber,
               invoiceduedate          = @ms_invoice_data-invoiceduedate,
               invoiceamount           = @ms_invoice_data-invoiceamount,
               transactioncurrency     = @ms_invoice_data-transactioncurrency,
               invoicestatus           = @iv_invoicestatus
         WHERE companycode             = @ms_invoice_data-companycode
           AND accountingdocument      = @ms_invoice_data-accountingdocument
           AND fiscalyear              = @ms_invoice_data-fiscalyear
           AND accountingdocumentitem  = @ms_invoice_data-accountingdocumentitem.
    ENDCASE.
  ENDMETHOD.