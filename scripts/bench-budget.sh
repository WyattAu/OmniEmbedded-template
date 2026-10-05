#!/usr/bin/env bash
# Perf budget gate: measure, emit bench/current.tsv, compare to the committed
# baseline with the shared comparator. `make bench-update` re-baselines
# deliberately - it is the only way a baseline moves.
set -euo pipefail
cd "$(dirname "$0")/.."
BASELINE=bench/baseline.tsv
CURRENT=bench/current.tsv
THRESHOLD_PCT="${OMNI_BENCH_THRESHOLD_PCT:-5}"
UPDATE=()
[ "${1:-}" = "--update" ] && UPDATE=(--update)
mkdir -p bench

# Firmware size IS the performance budget here, and it is fully deterministic -
# so this gate is tight (5%) rather than statistical.
./scripts/build.sh >/dev/null
report="$(./scripts/size.sh)"

flash="$(printf '%s\n' "$report" | sed -n 's/^flash: \([0-9][0-9]*\).*/\1/p')"
ram="$(printf '%s\n' "$report" | sed -n 's/.*ram(bss+data): \([0-9][0-9]*\).*/\1/p')"
[ -n "$flash" ] && [ -n "$ram" ] || {
  echo "bench: could not parse size.sh output:" >&2
  printf '%s\n' "$report" >&2
  exit 1
}

printf 'flash-bytes\t%s\tbytes\tgate\nram-bytes\t%s\tbytes\tgate\n' "$flash" "$ram" > "$CURRENT"

python3 scripts/compare-bench.py "$BASELINE" "$CURRENT" \
  --threshold-pct "$THRESHOLD_PCT" "${UPDATE[@]+"${UPDATE[@]}"}"
