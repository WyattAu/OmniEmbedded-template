# This is a copy of <PICO_SDK_PATH>/external/pico_sdk_import.cmake — the
# canonical SDK bootstrap from pico-examples. Refresh it when bumping the
# SDK pin in cmake/pico.cmake.

# This can be dropped into an external project to help ensure this file
# is stubbed out only for host builds; for firmware builds the SDK is
# fetched or located exactly once.

if (NOT PICO_SDK_PATH)
    set(PICO_SDK_PATH "${CMAKE_SOURCE_DIR}/lib/pico-sdk")
endif ()

if (NOT EXISTS "${PICO_SDK_PATH}")
    if (PICO_SDK_FETCH_FROM_GIT)
        include(FetchContent)
        set(FETCHCONTENT_BASE_DIR_SAVE "${FETCHCONTENT_BASE_DIR}")
        if (PICO_SDK_FETCH_FROM_GIT_PATH)
            get_filename_component(FETCHCONTENT_BASE_DIR "${PICO_SDK_FETCH_FROM_GIT_PATH}" REALPATH)
        endif ()
        FetchContent_Declare(
                pico_sdk
                GIT_REPOSITORY ${PICO_SDK_FETCH_FROM_GIT_REPOSITORY}
                GIT_TAG ${PICO_SDK_FETCH_FROM_GIT_TAG}
        )
        if (NOT pico_sdk)
            FetchContent_Populate(pico_sdk)
            set(PICO_SDK_PATH ${pico_sdk_SOURCE_DIR})
        endif ()
        set(FETCHCONTENT_BASE_DIR "${FETCHCONTENT_BASE_DIR_SAVE}")
    else ()
        message(FATAL_ERROR
                "SDK location was not specified. Please set PICO_SDK_PATH, or "
                "set PICO_SDK_FETCH_FROM_GIT to fetch the pinned SDK.")
    endif ()
endif ()

get_filename_component(PICO_SDK_PATH "${PICO_SDK_PATH}" REALPATH BASE_DIR "${CMAKE_BINARY_DIR}")
if (NOT EXISTS ${PICO_SDK_PATH})
    message(FATAL_ERROR "Directory '${PICO_SDK_PATH}' not found")
endif ()

set(PICO_SDK_INIT_CMAKE_FILE ${PICO_SDK_PATH}/pico_sdk_init.cmake)
if (NOT EXISTS ${PICO_SDK_INIT_CMAKE_FILE})
    message(FATAL_ERROR "Directory '${PICO_SDK_PATH}' does not appear to contain the Raspberry Pi Pico SDK")
endif ()

set(PICO_SDK_PATH ${PICO_SDK_PATH} CACHE PATH "Path to the Raspberry Pi Pico SDK" FORCE)
include(${PICO_SDK_INIT_CMAKE_FILE})
