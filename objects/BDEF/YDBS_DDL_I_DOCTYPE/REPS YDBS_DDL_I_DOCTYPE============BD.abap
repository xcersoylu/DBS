managed implementation in class zbp_dbs_ddl_i_doctype unique;
strict ( 2 );

define behavior for YDBS_DDL_I_DOCTYPE //alias <alias_name>
persistent table ydbs_t_doctype
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) Companycode, DocumentType;
  mapping for ydbs_t_doctype
    {
      Companycode  = companycode;
      DocumentType = document_type;
    }
}