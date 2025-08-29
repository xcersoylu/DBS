  METHOD get_error_text.
    SELECT SINGLE message FROM ydbs_t_gar_error WHERE code = @iv_code INTO @rv_error_text.
  ENDMETHOD.