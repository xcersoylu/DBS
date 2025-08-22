CLASS ycl_dbs_bank DEFINITION
  PUBLIC
  ABSTRACT
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA ms_collect_detail TYPE ydbs_s_collect_detail.
    DATA mv_batch_id TYPE ydbs_e_batch_id.
    DATA mv_trf_id TYPE ydbs_e_trf_id.
    CLASS-METHODS factory IMPORTING iv_bankinternalid TYPE bankk
                                    iv_companycode    TYPE bukrs
                                    iv_customer       TYPE kunnr
                                    iv_invoice_data   TYPE ydbs_s_invoice_cockpit_data OPTIONAL
                          RETURNING VALUE(ro_object)  TYPE REF TO ycl_dbs_bank.
    METHODS prepare_update_limit ABSTRACT RETURNING VALUE(rv_request) TYPE string.
    METHODS prepare_send_invoice ABSTRACT RETURNING VALUE(rv_request) TYPE string.
    METHODS prepare_delete_invoice ABSTRACT RETURNING VALUE(rv_request) TYPE string.
    METHODS prepare_update_invoice ABSTRACT RETURNING VALUE(rv_request) TYPE string.
    METHODS prepare_collect_invoice ABSTRACT RETURNING VALUE(rv_request) TYPE string.
    METHODS response_mapping_limit ABSTRACT IMPORTING iv_response TYPE string RETURNING VALUE(rt_messages) TYPE ydbs_tt_bapiret2.
    METHODS response_mapping_send_invoice ABSTRACT IMPORTING iv_response TYPE string RETURNING VALUE(rt_messages) TYPE ydbs_tt_bapiret2.
    METHODS response_mapping_update_inv ABSTRACT IMPORTING iv_response TYPE string RETURNING VALUE(rt_messages) TYPE ydbs_tt_bapiret2.
    METHODS response_mapping_delete_inv ABSTRACT IMPORTING iv_response TYPE string RETURNING VALUE(rt_messages) TYPE ydbs_tt_bapiret2.
    METHODS response_mapping_collect_inv ABSTRACT IMPORTING iv_response TYPE string EXPORTING es_collect_detail TYPE ydbs_s_collect_detail
                                                            RETURNING VALUE(rt_messages) TYPE ydbs_tt_bapiret2.

    METHODS call_api IMPORTING iv_api_type TYPE ydbs_e_api_type
                     EXPORTING et_messages TYPE ydbs_tt_bapiret2.
    METHODS save_log IMPORTING iv_invoicestatus TYPE ydbs_e_invoicestatus.
    METHODS get_log RETURNING VALUE(rs_log) TYPE ydbs_t_log.