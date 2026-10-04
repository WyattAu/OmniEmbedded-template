/**
 * Omni firmware skeleton: boot → blink a PIO square wave → printf over USB.
 * Swap the body; keep the shape (std_init first, loop non-blocking).
 */
#include <pico/stdlib.h>
#include <stdio.h>

#include "blink.pio.h"

#define BLINK_PIN PICO_DEFAULT_LED_PIN

int main(void) {
    stdio_init_all();

    PIO pio = pio0;
    uint offset = pio_add_program(pio, &blink_program);
    uint sm = pio_claim_unused_sm(pio, true);
    blink_program_init(pio, sm, offset, BLINK_PIN, 1000);

    uint32_t heartbeats = 0;
    for (;;) {
        printf("omni heartbeat %lu\n", (unsigned long)heartbeats++);
        sleep_ms(1000);
    }
    return 0; /* unreachable */
}
