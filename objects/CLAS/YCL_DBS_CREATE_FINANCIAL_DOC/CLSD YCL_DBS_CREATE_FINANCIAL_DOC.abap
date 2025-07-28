class-pool .
*"* class pool for class YCL_DBS_CREATE_FINANCIAL_DOC

*"* local type definitions
include YCL_DBS_CREATE_FINANCIAL_DOC==ccdef.

*"* class YCL_DBS_CREATE_FINANCIAL_DOC definition
*"* public declarations
  include YCL_DBS_CREATE_FINANCIAL_DOC==cu.
*"* protected declarations
  include YCL_DBS_CREATE_FINANCIAL_DOC==co.
*"* private declarations
  include YCL_DBS_CREATE_FINANCIAL_DOC==ci.
endclass. "YCL_DBS_CREATE_FINANCIAL_DOC definition

*"* macro definitions
include YCL_DBS_CREATE_FINANCIAL_DOC==ccmac.
*"* local class implementation
include YCL_DBS_CREATE_FINANCIAL_DOC==ccimp.

*"* test class
include YCL_DBS_CREATE_FINANCIAL_DOC==ccau.

class YCL_DBS_CREATE_FINANCIAL_DOC implementation.
*"* method's implementations
  include methods.
endclass. "YCL_DBS_CREATE_FINANCIAL_DOC implementation
