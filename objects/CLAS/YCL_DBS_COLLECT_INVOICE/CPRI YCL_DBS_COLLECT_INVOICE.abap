  PRIVATE SECTION.
    DATA: ms_request  TYPE ydbs_s_collect_invoice_req,
          ms_response TYPE ydbs_s_collect_invoice_res.
    CONSTANTS: mc_header_content TYPE string VALUE 'content-type',
               mc_content_type   TYPE string VALUE 'text/json',
               mc_collect        TYPE ydbs_e_api_type VALUE 'C',
               mc_error          TYPE symsgty VALUE 'E',
               mc_ready          TYPE ydbs_e_invoicestatus VALUE 'R',
               mc_deleted        TYPE ydbs_e_invoicestatus VALUE 'D',
               mc_collected      TYPE ydbs_e_invoicestatus VALUE 'C'.