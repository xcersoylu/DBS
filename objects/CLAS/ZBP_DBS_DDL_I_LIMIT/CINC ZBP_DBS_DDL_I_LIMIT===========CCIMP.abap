CLASS lhc_ydbs_ddl_i_limit DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR ydbs_ddl_i_limit RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ydbs_ddl_i_limit RESULT result.

    METHODS updatelimit FOR MODIFY
      IMPORTING keys FOR ACTION ydbs_ddl_i_limit~updatelimit RESULT result.

ENDCLASS.

CLASS lhc_ydbs_ddl_i_limit IMPLEMENTATION.

  METHOD get_instance_features.

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updatelimit.
    DATA lt_messages TYPE ydbs_tt_bapiret2.
    READ ENTITIES OF ydbs_ddl_i_limit IN LOCAL MODE
        ENTITY ydbs_ddl_i_limit
          ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_selected_lines)
      FAILED failed.
    CHECK lt_selected_lines IS NOT INITIAL.
    LOOP AT lt_selected_lines INTO DATA(ls_selected_line).
      DATA(lo_limit) = ycl_dbs_bank=>factory( iv_bankinternalid = ls_selected_line-bankinternalid
                                              iv_companycode    = ls_selected_line-companycode
                                              iv_customer       = ls_selected_line-customer ).
      lo_limit->call_api( EXPORTING iv_api_type = 'L' IMPORTING et_messages = lt_messages ).

      IF lt_messages IS NOT INITIAL.
        LOOP AT lt_messages INTO DATA(ls_message).
          APPEND VALUE #( %tky = ls_selected_line-%tky
                          %msg = new_message( severity = COND #( WHEN ls_message-type = 'S' THEN
                                                                                if_abap_behv_message=>severity-success
                                                                           WHEN ls_message-type = 'E' THEN
                                                                                if_abap_behv_message=>severity-error )
                                              id = ls_message-id
                                              number = ls_message-number
                                              v1 = ls_message-message_v1
                                              v2 = ls_message-message_v2
                                              v3 = ls_message-message_v3
                                              v4 = ls_message-message_v4
                                            ) ) TO reported-ydbs_ddl_i_limit.
        ENDLOOP.
        CLEAR lt_messages.
        FREE lo_limit. CLEAR lo_limit.
      ENDIF.
    ENDLOOP.

    READ ENTITIES OF ydbs_ddl_i_limit IN LOCAL MODE
        ENTITY ydbs_ddl_i_limit
          ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_updated)
      FAILED failed.

    result = VALUE #( FOR ls_updated IN lt_updated
       ( %tky   = ls_updated-%tky
         %param = ls_updated ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ydbs_ddl_i_limit DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ydbs_ddl_i_limit IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.