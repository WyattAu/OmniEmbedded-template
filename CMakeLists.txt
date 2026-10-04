cmake_minimum_required(VERSION 3.22)

# Two personalities: HOST builds run the unit tests natively; PICO builds
# the firmware against the pinned SDK (scripts/ensure-pico-sdk.sh acquires
# it; presets point the cross toolchain at it before project()).
project(omni-firmware C CXX ASM)

if(OMNI_HOST)
  enable_testing()
  add_subdirectory(tests)
else()
  # PICO_SDK_PATH comes from the preset cache (or the environment).
  include("$PICO_SDK_PATH/pico_sdk_init.cmake")
  pico_sdk_init()

  add_executable(omni-firmware src/main.c)
  pico_generate_pio_header(omni-firmware ${CMAKE_CURRENT_LIST_DIR}/pio/blink.pio)
  target_include_directories(omni-firmware PRIVATE include)
  target_link_libraries(omni-firmware pico_stdlib)
  pico_add_extra_outputs(omni-firmware) # UF2 + BIN + HEX + DIS
endif()
