managed implementation in class zbp_dbs_ddl_i_curr_type unique;
strict ( 2 );

define behavior for YDBS_DDL_I_CURR_TYPE //alias <alias_name>
persistent table ydbs_t_curr_type
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) Companycode,CurrencyType;
  mapping for ydbs_t_curr_type
    {
      Companycode      = companycode;
      CurrencyType     = currency_type;
      Currency         = currency;
      ExchangeRateType = exchange_rate_type;
    }

}