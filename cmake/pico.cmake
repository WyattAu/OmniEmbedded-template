# Pico SDK discovery: PICO_SDK_PATH env wins, otherwise fetch the pinned
# tag. Pinned because "latest SDK" is not a reproducible pin
# (REPRODUCIBILITY). Only included for non-host presets.
if(NOT DEFINED ENV{PICO_SDK_PATH} AND NOT EXISTS ${CMAKE_SOURCE_DIR}/lib/pico-sdk)
  set(PICO_SDK_FETCH_FROM_GIT ON)
  set(PICO_SDK_FETCH_FROM_GIT_TAG "2.1.1" CACHE STRING "pico-sdk pin")
endif()
include(pico_sdk_import.cmake)
pico_sdk_init()

set(OMNI_HOST OFF)
