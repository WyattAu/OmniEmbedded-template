/** REQ-001: CI proves the host toolchain + test runner work before any
 * hardware is touched. Replace with real domain tests. */
#include <assert.h>

/* Reimplementation note: keep host-testable logic in pure C headers under
 * include/ so tests exercise the same code the firmware runs. */
static unsigned next_heartbeat(unsigned current) { return current + 1u; }

int main(void) {
    assert(next_heartbeat(0) == 1);
    assert(next_heartbeat(41) == 42);
    return 0;
}
