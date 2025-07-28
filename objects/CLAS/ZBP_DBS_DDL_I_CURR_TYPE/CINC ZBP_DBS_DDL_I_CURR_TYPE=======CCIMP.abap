CLASS lhc_ydbs_ddl_i_curr_type DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ydbs_ddl_i_curr_type RESULT result.

ENDCLASS.

CLASS lhc_ydbs_ddl_i_curr_type IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.