  PRIVATE SECTION.
    DATA mv_sessionkey TYPE string.
    CONSTANTS mc_success_code TYPE i VALUE 200.
    METHODS login RETURNING VALUE(rv_sessionkey) TYPE string.