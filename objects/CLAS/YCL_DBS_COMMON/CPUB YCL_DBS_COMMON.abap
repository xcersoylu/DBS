CLASS ycl_dbs_common DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF mty_xml_node,
             node_type  TYPE string,
             prefix     TYPE string,
             name       TYPE string,
             nsuri      TYPE string,
             value_type TYPE string,
             value      TYPE string,
           END OF mty_xml_node,
           mty_xml_nodes TYPE TABLE OF mty_xml_node WITH EMPTY KEY,
           mty_hash      TYPE c LENGTH 32.
    TYPES : BEGIN OF ty_local_time_info,
              timestamp TYPE timestamp,
              date      TYPE d,
              time      TYPE t,
            END OF ty_local_time_info.
    CLASS-METHODS parse_xml
      IMPORTING
        iv_xml_string  TYPE string
        iv_xml_xstring TYPE xstring OPTIONAL
      RETURNING
        VALUE(rt_data) TYPE mty_xml_nodes.
    CLASS-METHODS get_node_type
      IMPORTING
        node_type_int           TYPE i
      RETURNING
        VALUE(node_type_string) TYPE string.
    CLASS-METHODS get_value_type
      IMPORTING
        value_type_int           TYPE i
      RETURNING
        VALUE(value_type_string) TYPE string.
    CLASS-METHODS get_local_time
      RETURNING VALUE(local_time_info) TYPE ty_local_time_info.