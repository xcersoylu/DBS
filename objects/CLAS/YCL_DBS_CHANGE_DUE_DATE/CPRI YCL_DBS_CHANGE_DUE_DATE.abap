  PRIVATE SECTION.
    DATA: ms_request  TYPE ydbs_s_change_due_date_req,
          ms_response TYPE ydbs_s_change_due_date_res.
    CONSTANTS: mc_header_content TYPE string VALUE 'content-type',
               mc_content_type   TYPE string VALUE 'text/json'.