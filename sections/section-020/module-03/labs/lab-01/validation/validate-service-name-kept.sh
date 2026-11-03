#!/usr/bin/env bash
# Check: the traces keep the service name shuttle
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1 2>/dev/null)"
if ! printf '%s\n' "$collector_logs" | grep -qF -- 'service.name: Str(shuttle)'; then
  echo "FAIL: the output has no service.name: Str(shuttle)"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the traces keep the service name shuttle"
fi
exit "$fail"
