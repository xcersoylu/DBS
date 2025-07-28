private section.
    DATA: ms_request  TYPE ydbs_s_update_invoice_req,
          ms_response TYPE ydbs_s_update_invoice_res.
    CONSTANTS: mc_header_content TYPE string VALUE 'content-type',
               mc_content_type   TYPE string VALUE 'text/json',
               mc_update type ydbs_e_api_type VALUE 'U'.