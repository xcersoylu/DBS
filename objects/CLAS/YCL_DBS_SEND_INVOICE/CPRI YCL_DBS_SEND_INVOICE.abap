  PRIVATE SECTION.
    DATA: ms_request  TYPE ydbs_s_send_invoice_req,
          ms_response TYPE ydbs_s_send_invoice_res.
    CONSTANTS: mc_header_content TYPE string VALUE 'content-type',
               mc_content_type   TYPE string VALUE 'text/json',
               mc_send           TYPE ydbs_e_api_type VALUE 'S',
               mc_error          TYPE symsgty VALUE 'E',
               mc_ready          TYPE ydbs_e_invoicestatus VALUE 'R'.