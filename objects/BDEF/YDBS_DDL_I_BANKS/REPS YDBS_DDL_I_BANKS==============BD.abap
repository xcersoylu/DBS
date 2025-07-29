managed implementation in class zbp_dbs_ddl_i_banks unique;
strict ( 2 );

define behavior for YDBS_DDL_I_BANKS //alias <alias_name>
persistent table ydbs_t_banks
lock master
authorization master ( instance )
//etag master <field_name>
{
  create;
  update;
  delete;
  field ( readonly : update ) Bankinternalid;
  association _Bank_DocType { create; }
  association _Service { create; }
}

define behavior for YDBS_DDL_I_BNK_DTYPE //alias <alias_name>
persistent table ydbs_t_bnk_dtype
lock dependent by _Banks
authorization dependent by _Banks
//etag master <field_name>
{
  update;
  delete;
  field ( readonly :update ) Bankinternalid, Companycode;
  association _Banks;

  mapping for ydbs_t_bnk_dtype
    {
      Bankinternalid         = bankinternalid;
      Companycode            = companycode;
      Housebank              = housebank;
      Housebankaccount       = housebankaccount;
      ShortDescription       = short_description;
      ArbitrageAccount       = arbitrage_account;
      CollectionDocumentType = collection_document_type;
      SendingDocumentType    = sending_document_type;
      DifferenceDocumentType = difference_document_type;
      ClearingAccount        = clearing_account;
      MainAccount            = main_account;
      Profitcenter           = profitcenter;
    }
}

define behavior for YDBS_DDL_I_SERVICE //alias <alias_name>
persistent table ydbs_t_service
lock dependent by _Banks
authorization dependent by _Banks
//etag master <field_name>
{
  update;
  delete;
  field ( readonly : update ) Bankinternalid, Companycode;
  association _Banks;
  mapping for ydbs_t_service
    {
      Bankinternalid   = bankinternalid;
      Companycode      = companycode;
      FirmCode         = firm_code;
      CpiUsername      = cpi_username;
      CpiPassword      = cpi_password;
      CpiUrl           = cpi_url;
      ClassName        = class_name;
      AdditionalField1 = additional_field1;
      AdditionalField2 = additional_field2;
      AdditionalField3 = additional_field3;
      AdditionalField4 = additional_field4;
      Currency         = currency;
      ServiceType      = service_type;
      Username         = username;
      Password         = password;
      ClassSuffix      = class_suffix;
    }
}