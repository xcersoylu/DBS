managed implementation in class zbp_dbs_ddl_i_parameter unique;
strict ( 2 );

define behavior for YDBS_DDL_I_PARAMETER //alias <alias_name>
persistent table ydbs_t_parameter
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) ParameterName, ParameterKey;
  mapping for ydbs_t_parameter
    {
      ParameterName        = parameter_name;
      ParameterKey         = parameter_key;
      ParameterValue       = parameter_value;
      ParameterDescription = parameter_description;
    }
}