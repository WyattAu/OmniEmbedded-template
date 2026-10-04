#!/usr/bin/env bash
# Build all presets. CI gates both personalities; locally, pick one:
# ./scripts/build.sh pico-release
set -euo pipefail
cd "$(dirname "$0")/.."
presets=("$@")
[ ${#presets[@]} -eq 0 ] && presets=(host-debug pico-release)
for p in "${presets[@]}"; do
  [[ "$p" == pico-* ]] && ./scripts/ensure-pico-sdk.sh
  cmake --preset "$p"
  cmake --build "build/$p" -j"$(nproc 2>/dev/null || sysctl -n hw.ncpu)"
done
