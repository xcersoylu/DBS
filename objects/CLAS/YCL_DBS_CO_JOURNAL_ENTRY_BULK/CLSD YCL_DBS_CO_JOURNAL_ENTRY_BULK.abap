class-pool .
*"* class pool for class YCL_DBS_CO_JOURNAL_ENTRY_BULK

*"* local type definitions
include YCL_DBS_CO_JOURNAL_ENTRY_BULK=ccdef.

*"* class YCL_DBS_CO_JOURNAL_ENTRY_BULK definition
*"* public declarations
  include YCL_DBS_CO_JOURNAL_ENTRY_BULK=cu.
*"* protected declarations
  include YCL_DBS_CO_JOURNAL_ENTRY_BULK=co.
*"* private declarations
  include YCL_DBS_CO_JOURNAL_ENTRY_BULK=ci.
endclass. "YCL_DBS_CO_JOURNAL_ENTRY_BULK definition

*"* macro definitions
include YCL_DBS_CO_JOURNAL_ENTRY_BULK=ccmac.
*"* local class implementation
include YCL_DBS_CO_JOURNAL_ENTRY_BULK=ccimp.

class YCL_DBS_CO_JOURNAL_ENTRY_BULK implementation.
*"* method's implementations
  include methods.
endclass. "YCL_DBS_CO_JOURNAL_ENTRY_BULK implementation
