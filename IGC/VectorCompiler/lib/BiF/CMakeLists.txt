#=========================== begin_copyright_notice ============================
#
# Copyright (C) 2021-2023 Intel Corporation
#
# SPDX-License-Identifier: MIT
#
#============================ end_copyright_notice =============================

include(cmake/Functions.cmake)

set(RESOURCE_EMBEDDER_SCRIPT ${IGC_SOURCE_DIR}/BiFModule/resource_embedder.py)
set(VCB_EXE "vcb" CACHE STRING "")

set(PRINTF_COMMON ${CMAKE_CURRENT_SOURCE_DIR}/Print/common.h)
vc_embed_bif(PRINTF_OCL_32 Print/ocl.cpp VCBiFPrintfOCL 32 DEPENDS ${PRINTF_COMMON})
vc_embed_bif(PRINTF_OCL_64 Print/ocl.cpp VCBiFPrintfOCL 64 DEPENDS ${PRINTF_COMMON})
vc_embed_bif(PRINTF_ZE_32 Print/ze.cpp VCBiFPrintfZE 32 DEPENDS ${PRINTF_COMMON})
vc_embed_bif(PRINTF_ZE_64 Print/ze.cpp VCBiFPrintfZE 64 DEPENDS ${PRINTF_COMMON})

#Define the macro if Khronos SPIR-V translator is used.
if(IGC_OPTION__USE_KHRONOS_SPIRV_TRANSLATOR_IN_SC)
  set(CLANG_FLAGS_FOR_SPIRV_BUILTINS "-D__USE_KHRONOS_SPIRV_TRANSLATOR_IN_SC__")
endif()

get_target_include_opt_list(IGC_SPIRV_HEADERS_INCLUDES IGCSPIRVHeaders)

set(SPIRV_BUILTIN_SOURCES
  Spirv/atomic.cpp
  Spirv/assert.cpp
  Spirv/barrier.cpp
  Spirv/exec.cpp
  Spirv/math.cpp)

vc_embed_bif(SPIRV_BUILTINS "${SPIRV_BUILTIN_SOURCES}" VCSPIRVBuiltins 64
  CLANG_INCLUDES ${IGC_SPIRV_HEADERS_INCLUDES}
  CLANG_FLAGS ${CLANG_FLAGS_FOR_SPIRV_BUILTINS})

set(BUILTIN_SOURCES
  Library/Math/F16/fptoi.cpp
  Library/Math/F16/itofp.cpp

  Library/Math/F32/fdiv.cpp
  Library/Math/F32/frem.cpp
  Library/Math/F32/fptoi.cpp
  Library/Math/F32/itofp.cpp

  Library/Math/F64/rsqrt.cpp
  Library/Math/F64/fdiv.cpp
  Library/Math/F64/fptoi.cpp
  Library/Math/F64/frem.cpp
  Library/Math/F64/fsqrt.cpp
  Library/Math/F64/itofp.cpp

  Library/Math/Integer/i64divrem.cpp
  Library/Math/Integer/sdivrem.cpp
  Library/Math/Integer/udivrem.cpp

  Library/Atomics/Local/binop.cpp)

vc_embed_optimized_bif(BUILTINS "${BUILTIN_SOURCES}" VCBuiltins 64)

add_custom_target(VCBiFPreparation
  DEPENDS ${PRINTF_OCL_32} ${PRINTF_OCL_64} ${PRINTF_ZE_32} ${PRINTF_ZE_64}
  ${BUILTINS} ${SPIRV_BUILTINS})

add_library(VCEmbeddedBiF OBJECT
  ${PRINTF_OCL_32} ${PRINTF_OCL_64} ${PRINTF_ZE_32} ${PRINTF_ZE_64}
  ${BUILTINS} ${SPIRV_BUILTINS})
add_dependencies(VCEmbeddedBiF VCBiFPreparation)
target_link_libraries(VCEmbeddedBiF VCHeaders)
