class-pool .
*"* class pool for class YCL_DBS_BANK_ISB

*"* local type definitions
include YCL_DBS_BANK_ISB==============ccdef.

*"* class YCL_DBS_BANK_ISB definition
*"* public declarations
  include YCL_DBS_BANK_ISB==============cu.
*"* protected declarations
  include YCL_DBS_BANK_ISB==============co.
*"* private declarations
  include YCL_DBS_BANK_ISB==============ci.
endclass. "YCL_DBS_BANK_ISB definition

*"* macro definitions
include YCL_DBS_BANK_ISB==============ccmac.
*"* local class implementation
include YCL_DBS_BANK_ISB==============ccimp.

*"* test class
include YCL_DBS_BANK_ISB==============ccau.

class YCL_DBS_BANK_ISB implementation.
*"* method's implementations
  include methods.
endclass. "YCL_DBS_BANK_ISB implementation
