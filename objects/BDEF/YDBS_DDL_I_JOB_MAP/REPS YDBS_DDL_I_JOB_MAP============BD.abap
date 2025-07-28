managed implementation in class zbp_dbs_ddl_i_job_map unique;
strict ( 2 );

define behavior for YDBS_DDL_I_JOB_MAP //alias <alias_name>
persistent table ydbs_t_job_map
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) Companycode;
  mapping for ydbs_t_job_map
    {
      Companycode    = companycode;
      Send           = send;
      Collect        = collect;
      DaysToMaturity = days_to_maturity;
    }
}