# 0001 — Host-first embedded testing

Date: 2026-10-04

## Status

Accepted

## Context

Embedded projects rot when the only test is "plug it in and look". Hardware
access is slow, scarce, and un-CI-able by default.

## Decision

Two build personalities: HOST (native, assert-based unit tests, every PR)
and PICO (cross firmware, size-budgeted). Target logic that can be pure C
lives in `include/` headers so host tests exercise it verbatim. HIL smoke
is an allowed-to-fail self-hosted job — never a merge blocker.

## Consequences

- CI never requires hardware; hardware debt is visible, not blocking.
- PIO/hardware-register code stays thin and is exercised by HIL only.
