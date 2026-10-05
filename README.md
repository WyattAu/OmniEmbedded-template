# OmniEmbedded-template

Maximalist embedded C/C++ template for **RP2040/RP2350** (Pico): pico-sdk
pinned, CMake presets (host tests + cross firmware), PIO scaffold, UF2/BIN
artifacts, **flash/RAM size-budget gates**, clang-format/tidy, optional HIL
smoke on a self-hosted runner — nix flake + dual devcontainers + VS Code.
Part of the [WyattAu Omni family](https://github.com/WyattAu?tab=repositories&q=omni-).

## Start here

1. Rename `omni-firmware` → your target (CMakeLists.txt, presets keep working).
2. Door: nix+direnv / devcontainer(image|nix) — `./scripts/bootstrap.sh` for manual.
3. `make ci` — host tests, cross build (both boards), size budgets.

## Make targets

| Target | Gate |
|---|---|
| `make build` | all presets (host + cross) |
| `make test` | host unit tests (ctest) |
| `make size` | flash/RAM budgets (`FLASH_BUDGET`/`RAM_BUDGET` env) |
| `make flash` | probe-rs download; BOOTSEL instructions as fallback |
| `make contract` / `make ci` | contract / contract+build+test+size |

## Hardware-in-loop

`hil-smoke` runs on `[self-hosted, linux, embedded]` runners — flashes a
real board and continues past failure, so CI never blocks on a cable
(ADR-0001). Your Rust companions (can-core, dbc-parse) cover the no_std
codec layer in OmniRust's embedded toggle.

## License

Apache-2.0 — commercial use expressly permitted.


## Performance budgets

Performance is a gate, not a hope. `make bench` measures, writes
`bench/current.tsv`, and compares it against the committed
`bench/baseline.tsv`; anything more than the threshold worse fails. The
comparator (`scripts/compare-bench.py`) is identical across the whole Omni
estate, so the policy is auditable in one place.

| Verb | What it does |
|---|---|
| `make bench` | measure + compare (advisory job in CI: `perf`) |
| `make bench-update` | deliberately re-baseline; the only way a baseline moves |

The first run on a fresh clone records the baseline instead of failing, so the
gate is meaningful from the second run onwards. Override the budget per run
with `OMNI_BENCH_THRESHOLD_PCT=15 make bench`. Rationale and per-template
metrics: `docs/adr/0004-performance-budget-gate.md`.
