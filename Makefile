# Thin wrapper over scripts/ — the same verbs in every Omni template.
.PHONY: bench bench-update repro build test size flash lint contract ci clean

build:
	./scripts/build.sh

test:
	./scripts/test.sh

size:
	./scripts/size.sh

flash:
	./scripts/flash.sh

lint:
	clang-tidy -p build/host-debug tests/*.c 2>/dev/null || echo "clang-tidy: run after configure (make build)"

contract:
	./scripts/check-contract.sh

## What CI gates before merge (mirror of .github/workflows/ci.yml):
ci: contract build test size

repro:
	./scripts/repro-check.sh

bench:
	./scripts/bench-budget.sh

bench-update:
	./scripts/bench-budget.sh --update

clean:
	rm -rf build
