projection;
strict ( 2 );

define behavior for YDBS_DDL_P_BANKS //alias <alias_name>
{
  use create;
  use update;
  use delete;

  use association _Bank_DocType { create; }
  use association _Service { create; }
}

define behavior for YDBS_DDL_P_BNK_DTYPE //alias <alias_name>
{
  use update;
  use delete;

  use association _Banks;
}

define behavior for YDBS_DDL_P_SERVICE //alias <alias_name>
{
  use update;
  use delete;

  use association _Banks;
}