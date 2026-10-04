# Locate/fetch the pico-sdk BEFORE project(). PICO_SDK_PATH env wins,
# otherwise clone the pinned tag once into lib/pico-sdk (gitignored).
# Pinned because "latest SDK" is not a reproducible pin (REPRODUCIBILITY).
set(PICO_SDK_VERSION "2.1.1")

if(DEFINED ENV{PICO_SDK_PATH})
  set(PICO_SDK_PATH "$ENV{PICO_SDK_PATH}" CACHE PATH "Path to the pico-sdk" FORCE)
  return()
endif()

set(PICO_SDK_PATH "${CMAKE_SOURCE_DIR}/lib/pico-sdk")
if(NOT EXISTS "${PICO_SDK_PATH}/pico_sdk_init.cmake")
  file(MAKE_DIRECTORY "${CMAKE_SOURCE_DIR}/lib")
  message(STATUS "Fetching pico-sdk ${PICO_SDK_VERSION} ...")
  execute_process(
    COMMAND git clone --depth 1 --branch ${PICO_SDK_VERSION}
            https://github.com/raspberrypi/pico-sdk.git "${PICO_SDK_PATH}"
    RESULT_VARIABLE _clone_result
  )
  if(NOT _clone_result EQUAL 0)
    message(FATAL_ERROR
      "Could not clone pico-sdk ${PICO_SDK_VERSION}; set PICO_SDK_PATH to an existing checkout instead")
  endif()
endif()
set(PICO_SDK_PATH "${PICO_SDK_PATH}" CACHE PATH "Path to the pico-sdk" FORCE)
