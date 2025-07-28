  PRIVATE SECTION.
    DATA: ms_request  TYPE ydbs_s_inv_cockpit_data_req,
          ms_response TYPE ydbs_s_inv_cockpit_data_res.
    CONSTANTS: mc_header_content TYPE string VALUE 'content-type',
               mc_content_type   TYPE string VALUE 'text/json'.