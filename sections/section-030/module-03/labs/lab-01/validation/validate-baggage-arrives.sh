#!/usr/bin/env bash
# Check: the server spans carry customer.tier gold
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1 2>/dev/null)"
if ! printf '%s\n' "$collector_logs" | grep -qF -- 'customer.tier: Str(gold)'; then
  echo "FAIL: no span has the attribute customer.tier: Str(gold)"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the server spans carry customer.tier gold"
fi
exit "$fail"
