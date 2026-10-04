#!/usr/bin/env bash
# Flash/RAM budget gate (percentile-kit philosophy: committed budgets, CI
# enforced). Defaults fit RP2350; override via env.
set -euo pipefail
cd "$(dirname "$0")/.."
ELF="${1:-build/pico-release/omni-firmware.elf}"
FLASH_BUDGET="${FLASH_BUDGET:-1048576}" # 1 MiB
RAM_BUDGET="${RAM_BUDGET:-524288}"      # 512 KiB
SIZE_BIN="${SIZE_BIN:-arm-none-eabi-size}"
command -v "$SIZE_BIN" >/dev/null || { echo "size tool missing (arm-none-eabi-binutils)"; exit 2; }
read -r text data bss dec _ < <("$SIZE_BIN" "$ELF")
echo "flash: $dec / $FLASH_BUDGET   ram(bss+data): $((bss + data)) / $RAM_BUDGET"
[ "$dec" -le "$FLASH_BUDGET" ] || { echo "FAIL: flash budget exceeded"; exit 1; }
[ "$((bss + data))" -le "$RAM_BUDGET" ] || { echo "FAIL: RAM budget exceeded"; exit 1; }
