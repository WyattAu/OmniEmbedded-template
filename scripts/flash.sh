#!/usr/bin/env bash
# Hardware flash: probe-rs preferred, BOOTSEL+picotool documented as the
# no-debugger path. HIL smoke runs on the self-hosted runner (see ci.yml).
set -euo pipefail
cd "$(dirname "$0")/.."
UF2="${1:-build/pico-release/omni-firmware.uf2}"
if command -v probe-rs >/dev/null; then
  exec probe-rs download "$UF2" --probe auto
fi
echo "probe-rs not found. BOOTSEL path:"
echo "  1. hold BOOTSEL, plug USB"
echo "  2. picotool copy -F '$UF2' /run/media/*/*  (or drag the UF2 in your file manager)"
exit 2
