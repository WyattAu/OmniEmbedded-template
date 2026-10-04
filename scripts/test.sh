#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
ctest --preset host --test-dir build/host-debug
