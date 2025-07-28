class-pool .
*"* class pool for class YCL_DBS_BANK_ALB

*"* local type definitions
include YCL_DBS_BANK_ALB==============ccdef.

*"* class YCL_DBS_BANK_ALB definition
*"* public declarations
  include YCL_DBS_BANK_ALB==============cu.
*"* protected declarations
  include YCL_DBS_BANK_ALB==============co.
*"* private declarations
  include YCL_DBS_BANK_ALB==============ci.
endclass. "YCL_DBS_BANK_ALB definition

*"* macro definitions
include YCL_DBS_BANK_ALB==============ccmac.
*"* local class implementation
include YCL_DBS_BANK_ALB==============ccimp.

*"* test class
include YCL_DBS_BANK_ALB==============ccau.

class YCL_DBS_BANK_ALB implementation.
*"* method's implementations
  include methods.
endclass. "YCL_DBS_BANK_ALB implementation
