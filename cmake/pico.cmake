# Pico SDK discovery: PICO_SDK_PATH env wins, otherwise fetch pinned.
# Pinned because "latest SDK" is not a reproducible pin (REPRODUCIBILITY).
set(PICO_SDK_FETCH_FROM_GIT ON)
set(PICO_SDK_FETCH_FROM_GIT_TAG "2.1.1" CACHE STRING "pico-sdk pin")
include(pico_sdk_import.cmake)
pico_sdk_init()

set(OMNI_HOST OFF)
