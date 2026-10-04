/**
 * Omni firmware skeleton: boot → blink a PIO square wave → printf over USB.
 * Swap the body; keep the shape (std_init first, loop non-blocking).
 */
#include <hardware/clocks.h>
#include <pico/stdlib.h>
#include <stdio.h>

#include "blink.pio.h"

#define BLINK_PIN PICO_DEFAULT_LED_PIN

/* pico-examples pattern: pioasm generates the program + default config;
 * the app supplies the pin/clock wiring as a tiny init helper. */
void blink_program_init(PIO pio, uint sm, uint offset, uint pin, uint32_t toggle_hz) {
    pio_sm_config c = blink_program_get_default_config(offset);
    sm_config_set_set_pins(&c, pin, 1);
    pio_gpio_init(pio, pin);
    pio_sm_set_consecutive_pindirs(pio, sm, pin, 1, true);
    /* 64 SM cycles per full wave (2 x set + 2 x 31 delays). */
    float div = (float)clock_get_hz(clk_sys) / ((float)toggle_hz * 64.0f);
    sm_config_set_clkdiv(&c, div);
    pio_sm_init(pio, sm, offset, &c);
    pio_sm_set_enabled(pio, sm, true);
}

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
