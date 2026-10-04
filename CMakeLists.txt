cmake_minimum_required(VERSION 3.22)

project(omni-firmware C CXX ASM)

# Two personalities: HOST builds run the unit tests natively; PICO builds
# the firmware against the pinned SDK. Presets in CMakePresets.json select.
if(OMNI_HOST)
  enable_testing()
  add_subdirectory(tests)
else()
  include(cmake/pico.cmake)
  add_executable(omni-firmware src/main.c)
  pico_generate_pio_header(omni-firmware ${CMAKE_CURRENT_LIST_DIR}/pio/blink.pio)
  target_include_directories(omni-firmware PRIVATE include)
  target_link_libraries(omni-firmware pico_stdlib)
  pico_add_extra_outputs(omni-firmware) # UF2 + BIN + HEX + DIS
endif()
