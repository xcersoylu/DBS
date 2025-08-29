  PRIVATE SECTION.
    CONSTANTS mc_success_code TYPE i VALUE 200.
    METHODS get_batch_header RETURNING VALUE(rv_ok) TYPE abap_boolean.
    METHODS get_batch_trailer RETURNING VALUE(rv_ok) TYPE abap_boolean.
    METHODS get_batchid RETURNING VALUE(rv_batch_id) TYPE ydbs_e_batch_id.
    METHODS get_trfid RETURNING VALUE(rv_trf_id) TYPE ydbs_e_trf_id.
    METHODS get_dts_detail IMPORTING iv_trftype TYPE c RETURNING VALUE(rv_request) TYPE string.
    METHODS get_error_text IMPORTING iv_code TYPE ydbs_e_garanti_error_code RETURNING VALUE(rv_error_text) TYPE bapi_msg.