#!/usr/bin/env bash
# SDK acquisition is a script (Omni Core Contract: scripts canonical). CI and
# local builds call this before cmake. PICO_SDK_PATH env wins; otherwise the
# pinned tag is cloned once into lib/pico-sdk (gitignored).
set -euo pipefail
cd "$(dirname "$0")/.."
PICO_SDK_VERSION="2.1.1"
if [ -n "${PICO_SDK_PATH:-}" ] && [ -f "${PICO_SDK_PATH}/pico_sdk_init.cmake" ]; then
  echo "pico-sdk: using PICO_SDK_PATH=${PICO_SDK_PATH}"
  exit 0
fi
SDK_DIR="lib/pico-sdk"
if [ ! -f "${SDK_DIR}/pico_sdk_init.cmake" ]; then
  mkdir -p lib
  echo "pico-sdk: cloning pinned ${PICO_SDK_VERSION} ..."
  git clone --depth 1 --branch "${PICO_SDK_VERSION}" \
    https://github.com/raspberrypi/pico-sdk.git "${SDK_DIR}"
fi
export PICO_SDK_PATH="$PWD/${SDK_DIR}"
echo "pico-sdk: ready at ${PICO_SDK_PATH}"
