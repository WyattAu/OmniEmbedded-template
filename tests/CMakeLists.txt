# Host tests: plain assert-based — zero deps, runs everywhere (no gtest
# until the suite earns it; ADR-0001).
add_executable(host_tests sanity.c)
add_test(NAME sanity COMMAND host_tests)
