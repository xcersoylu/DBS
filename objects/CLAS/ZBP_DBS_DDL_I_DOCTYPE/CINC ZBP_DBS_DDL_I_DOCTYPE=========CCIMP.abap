CLASS lhc_ydbs_ddl_i_doctype DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ydbs_ddl_i_doctype RESULT result.

ENDCLASS.

CLASS lhc_ydbs_ddl_i_doctype IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.