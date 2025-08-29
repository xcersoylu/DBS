  PROTECTED SECTION.
    DATA ms_service_info TYPE ydbs_t_service.
    DATA ms_subscribe TYPE ydbs_t_subsmap.
    DATA ms_invoice_data TYPE ydbs_s_invoice_cockpit_data.
    DATA mv_api_type TYPE ydbs_e_api_type.
    data mv_methodname type ydbs_e_methodname.
    CONSTANTS mc_id TYPE symsgid VALUE 'YDBS_MC'.
    CONSTANTS mc_error TYPE symsgty VALUE 'E'.
    CONSTANTS mc_success TYPE symsgty VALUE 'S'.
    CONSTANTS mc_send TYPE ydbs_e_invoicestatus VALUE 'S'.
    CONSTANTS mc_updated TYPE ydbs_e_invoicestatus VALUE 'U'.
    CONSTANTS mc_deleted TYPE ydbs_e_invoicestatus VALUE 'D'.
    CONSTANTS mc_collected TYPE ydbs_e_invoicestatus VALUE 'C'.
    CONSTANTS mc_value_node TYPE string VALUE 'CO_NT_VALUE'.
    METHODS adding_error_message IMPORTING iv_message TYPE string CHANGING ct_messages TYPE ydbs_tt_bapiret2.