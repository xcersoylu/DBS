CLASS ycl_dbs_create_financial_doc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA ms_invoice_data TYPE ydbs_s_invoice_cockpit_data.
    DATA ms_bank_doctype TYPE ydbs_t_bnk_dtype.
    DATA ms_collect_detail TYPE ydbs_s_collect_detail.
    DATA mv_collect_fi_doc TYPE belnr_d.
    DATA mv_collect_fi_doc_year TYPE belnr_d.
    DATA mv_temporary_fi_doc TYPE belnr_d.
    DATA mv_temporary_fi_doc_year TYPE belnr_d.
    METHODS create_temporary_fi_doc EXPORTING ev_accountingdocument TYPE belnr_d
                                              ev_fiscalyear         TYPE gjahr
                                              et_messages           TYPE ydbs_tt_bapiret2.
    METHODS create_collect_fi_doc EXPORTING ev_accountingdocument TYPE belnr_d
                                            ev_fiscalyear         TYPE gjahr
                                            et_messages           TYPE ydbs_tt_bapiret2.
    METHODS create_clearing_doc
      EXPORTING ev_accountingdocument TYPE belnr_d
                ev_fiscalyear         TYPE gjahr
                et_messages           TYPE ydbs_tt_bapiret2.

    METHODS constructor IMPORTING is_invoice_data   TYPE ydbs_s_invoice_cockpit_data
                                  is_bank_doctype   TYPE ydbs_t_bnk_dtype
                                  is_collect_detail TYPE ydbs_s_collect_detail OPTIONAL.