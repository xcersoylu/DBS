  PRIVATE SECTION.
    DATA: ms_request  TYPE ydbs_s_delete_invoice_req,
          ms_response TYPE ydbs_s_delete_invoice_res.
    CONSTANTS: mc_header_content TYPE string VALUE 'content-type',
               mc_content_type   TYPE string VALUE 'text/json',
               mc_delete         TYPE ydbs_e_api_type VALUE 'D',
               mc_ready          TYPE ydbs_e_invoicestatus VALUE 'R',
               mc_collected      TYPE ydbs_e_invoicestatus VALUE 'C',
               mc_error          TYPE symsgty VALUE 'E'.