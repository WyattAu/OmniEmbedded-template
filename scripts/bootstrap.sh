#!/usr/bin/env bash
# Non-nix fallback. Canonical env: flake.nix (arm-none-eabi toolchain).
set -euo pipefail
cat <<'MSG'
Manual toolchain (no nix):
  1. gcc-arm-none-eabi, cmake, ninja, python3
     (Arch: pacman -S arm-none-eabi-gcc arm-none-eabi-newlib cmake ninja)
  2. Optional: probe-rs (cargo install probe-rs-tools) or picotool
  3. make ci
Prefer zero setup? Open the repo in a devcontainer, or `nix develop`.
MSG
