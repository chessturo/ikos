###############################################################################
#
# Find LLVM headers and libraries.
#
# Author: Maxime Arthaud
#
# Contact: ikos@lists.nasa.gov
#
# Notices:
#
# Copyright (c) 2018-2019 United States Government as represented by the
# Administrator of the National Aeronautics and Space Administration.
# All Rights Reserved.
#
# Disclaimers:
#
# No Warranty: THE SUBJECT SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY WARRANTY OF
# ANY KIND, EITHER EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING, BUT NOT LIMITED
# TO, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL CONFORM TO SPECIFICATIONS,
# ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
# OR FREEDOM FROM INFRINGEMENT, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL BE
# ERROR FREE, OR ANY WARRANTY THAT DOCUMENTATION, IF PROVIDED, WILL CONFORM TO
# THE SUBJECT SOFTWARE. THIS AGREEMENT DOES NOT, IN ANY MANNER, CONSTITUTE AN
# ENDORSEMENT BY GOVERNMENT AGENCY OR ANY PRIOR RECIPIENT OF ANY RESULTS,
# RESULTING DESIGNS, HARDWARE, SOFTWARE PRODUCTS OR ANY OTHER APPLICATIONS
# RESULTING FROM USE OF THE SUBJECT SOFTWARE.  FURTHER, GOVERNMENT AGENCY
# DISCLAIMS ALL WARRANTIES AND LIABILITIES REGARDING THIRD-PARTY SOFTWARE,
# IF PRESENT IN THE ORIGINAL SOFTWARE, AND DISTRIBUTES IT "AS IS."
#
# Waiver and Indemnity:  RECIPIENT AGREES TO WAIVE ANY AND ALL CLAIMS AGAINST
# THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS, AS WELL
# AS ANY PRIOR RECIPIENT.  IF RECIPIENT'S USE OF THE SUBJECT SOFTWARE RESULTS
# IN ANY LIABILITIES, DEMANDS, DAMAGES, EXPENSES OR LOSSES ARISING FROM SUCH
# USE, INCLUDING ANY DAMAGES FROM PRODUCTS BASED ON, OR RESULTING FROM,
# RECIPIENT'S USE OF THE SUBJECT SOFTWARE, RECIPIENT SHALL INDEMNIFY AND HOLD
# HARMLESS THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS,
# AS WELL AS ANY PRIOR RECIPIENT, TO THE EXTENT PERMITTED BY LAW.
# RECIPIENT'S SOLE REMEDY FOR ANY SUCH MATTER SHALL BE THE IMMEDIATE,
# UNILATERAL TERMINATION OF THIS AGREEMENT.
#
###############################################################################

if (NOT LLVM_FOUND)
  find_program(LLVM_CONFIG_EXECUTABLE CACHE NAMES llvm-config DOC "Path to llvm-config binary")

  if (LLVM_CONFIG_EXECUTABLE)
    function(run_llvm_config FLAG OUTPUT_VAR)
      execute_process(
        COMMAND "${LLVM_CONFIG_EXECUTABLE}" "${FLAG}"
        RESULT_VARIABLE HAD_ERROR
        OUTPUT_VARIABLE ${OUTPUT_VAR}
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
      )
      if (HAD_ERROR)
        message(FATAL_ERROR "llvm-config failed with status: ${HAD_ERROR}")
      endif()
      set(${OUTPUT_VAR} "${${OUTPUT_VAR}}" PARENT_SCOPE)
    endfunction()

    run_llvm_config("--version" LLVM_VERSION)

    run_llvm_config("--prefix" LLVM_ROOT)
    file(TO_CMAKE_PATH "${LLVM_ROOT}" LLVM_ROOT)

    run_llvm_config("--includedir" LLVM_INCLUDE_DIR)
    file(TO_CMAKE_PATH "${LLVM_INCLUDE_DIR}" LLVM_INCLUDE_DIR)

    run_llvm_config("--bindir" LLVM_TOOLS_BINARY_DIR)
    file(TO_CMAKE_PATH "${LLVM_TOOLS_BINARY_DIR}" LLVM_TOOLS_BINARY_DIR)

    run_llvm_config("--libdir" LLVM_LIBRARY_DIR)
    file(TO_CMAKE_PATH "${LLVM_LIBRARY_DIR}" LLVM_LIBRARY_DIR)

    run_llvm_config("--cppflags" LLVM_CPPFLAGS)

    run_llvm_config("--cxxflags" LLVM_CXXFLAGS)

    run_llvm_config("--ldflags" LLVM_LDFLAGS)

    run_llvm_config("--obj-root" LLVM_OBJ_ROOT)
    file(TO_CMAKE_PATH "${LLVM_OBJ_ROOT}" LLVM_OBJ_ROOT)

    run_llvm_config("--cmakedir" LLVM_CMAKE_DIR)
    file(TO_CMAKE_PATH "${LLVM_CMAKE_DIR}" LLVM_CMAKE_DIR)
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(LLVM
    REQUIRED_VARS
      LLVM_ROOT
      LLVM_INCLUDE_DIR
      LLVM_TOOLS_BINARY_DIR
      LLVM_LIBRARY_DIR
      LLVM_CPPFLAGS
      LLVM_CXXFLAGS
      LLVM_LDFLAGS
      LLVM_OBJ_ROOT
      LLVM_VERSION
    VERSION_VAR
      LLVM_VERSION
    FAIL_MESSAGE
      "Could NOT find LLVM. Please provide -DLLVM_CONFIG_EXECUTABLE=/path/to/llvm-config")
endif()
