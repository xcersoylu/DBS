managed implementation in class zbp_dbs_ddl_i_limit unique;
//strict ( 2 );

define behavior for YDBS_DDL_I_LIMIT //alias <alias_name>
with unmanaged save
lock master
authorization master ( instance )
//etag master <field_name>
{
  //  create;
  //  update;
  //  delete;
  field ( readonly ) Companycode, Bankinternalid, Customer;
  action ( features : instance ) UpdateLimit result [1] $self;
}