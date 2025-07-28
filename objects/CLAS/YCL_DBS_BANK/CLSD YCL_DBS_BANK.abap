class-pool .
*"* class pool for class YCL_DBS_BANK

*"* local type definitions
include YCL_DBS_BANK==================ccdef.

*"* class YCL_DBS_BANK definition
*"* public declarations
  include YCL_DBS_BANK==================cu.
*"* protected declarations
  include YCL_DBS_BANK==================co.
*"* private declarations
  include YCL_DBS_BANK==================ci.
endclass. "YCL_DBS_BANK definition

*"* macro definitions
include YCL_DBS_BANK==================ccmac.
*"* local class implementation
include YCL_DBS_BANK==================ccimp.

*"* test class
include YCL_DBS_BANK==================ccau.

class YCL_DBS_BANK implementation.
*"* method's implementations
  include methods.
endclass. "YCL_DBS_BANK implementation
