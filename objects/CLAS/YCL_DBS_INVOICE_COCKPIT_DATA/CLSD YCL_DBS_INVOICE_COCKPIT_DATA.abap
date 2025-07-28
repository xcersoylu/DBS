class-pool .
*"* class pool for class YCL_DBS_INVOICE_COCKPIT_DATA

*"* local type definitions
include YCL_DBS_INVOICE_COCKPIT_DATA==ccdef.

*"* class YCL_DBS_INVOICE_COCKPIT_DATA definition
*"* public declarations
  include YCL_DBS_INVOICE_COCKPIT_DATA==cu.
*"* protected declarations
  include YCL_DBS_INVOICE_COCKPIT_DATA==co.
*"* private declarations
  include YCL_DBS_INVOICE_COCKPIT_DATA==ci.
endclass. "YCL_DBS_INVOICE_COCKPIT_DATA definition

*"* macro definitions
include YCL_DBS_INVOICE_COCKPIT_DATA==ccmac.
*"* local class implementation
include YCL_DBS_INVOICE_COCKPIT_DATA==ccimp.

*"* test class
include YCL_DBS_INVOICE_COCKPIT_DATA==ccau.

class YCL_DBS_INVOICE_COCKPIT_DATA implementation.
*"* method's implementations
  include methods.
endclass. "YCL_DBS_INVOICE_COCKPIT_DATA implementation
