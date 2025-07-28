projection;
strict ( 2 );

define behavior for YDBS_DDL_P_NONDBSINV //alias <alias_name>
{
  use create;
  use update;
  use delete;
}