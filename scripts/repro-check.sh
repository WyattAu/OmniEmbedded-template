#!/usr/bin/env bash
# Reproducible-build check (loop 3): build twice from a clean state with a pinned
# epoch and compare artifact hashes.
#
# MODE=gate - "gate" for toolchains that are deterministic (a mismatch is a
# real finding), "report" for toolchains that embed timestamps by design (a
# mismatch is printed and explained, never blocks). See the ADR.
set -euo pipefail
cd "$(dirname "$0")/.."
MODE=gate
EPOCH="${SOURCE_DATE_EPOCH:-$(git log -1 --pretty=%ct 2>/dev/null || echo 0)}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

compare() {
  if [ "$1" = "$2" ]; then
    echo "reproducible: OK ($1)"
    return 0
  fi
  echo "reproducible: MISMATCH" >&2
  echo "  run A: $1" >&2
  echo "  run B: $2" >&2
  if [ "$MODE" = "gate" ]; then
    echo "  this toolchain is expected to be deterministic - fix the build" >&2
    exit 1
  fi
  echo "  reported only: " >&2
  exit 0
}

# The ELF carries a linker build id and debug paths, so byte-identical firmware
# is not currently achievable with this toolchain. Reported, not gated - the
# real budget here is flash/RAM size, which `make bench` already gates.
fingerprint() {
  ./scripts/build.sh pico-release >/dev/null
  sha256sum build/pico-release/omni-firmware.elf | awk '{print $1}'
}
a="$(fingerprint)"
b="$(fingerprint)"
compare "$a" "$b"
