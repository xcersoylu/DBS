managed implementation in class zbp_dbs_ddl_i_subscription_map unique;
strict ( 2 );

define behavior for YDBS_DDL_I_subscription_map //alias <alias_name>
persistent table ydbs_t_subsmap
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) Companycode, Bankinternalid, Customer;
  mapping for ydbs_t_subsmap
    {
      Companycode      = companycode;
      Bankinternalid   = bankinternalid;
      Customer         = customer;
      CustomerName     = customer_name;
      CustomerSurname  = customer_surname;
      SubscriberNumber = subscriber_number;
      Priority         = priority;
    }
}