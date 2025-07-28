class-pool .
*"* class pool for class YCL_DBS_COMMON

*"* local type definitions
include YCL_DBS_COMMON================ccdef.

*"* class YCL_DBS_COMMON definition
*"* public declarations
  include YCL_DBS_COMMON================cu.
*"* protected declarations
  include YCL_DBS_COMMON================co.
*"* private declarations
  include YCL_DBS_COMMON================ci.
endclass. "YCL_DBS_COMMON definition

*"* macro definitions
include YCL_DBS_COMMON================ccmac.
*"* local class implementation
include YCL_DBS_COMMON================ccimp.

*"* test class
include YCL_DBS_COMMON================ccau.

class YCL_DBS_COMMON implementation.
*"* method's implementations
  include methods.
endclass. "YCL_DBS_COMMON implementation
