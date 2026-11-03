#!/usr/bin/env bash
# Check: the exported traces carry host.name, os.type and deployment.environment.name staging
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1 2>/dev/null)"
if [ "$(printf '%s\n' "$collector_logs" | grep -c 'Span #')" -lt 1 ]; then
  echo "FAIL: no spans in the last 120 seconds; wait 60 seconds and submit again"
  exit 1
fi
for pattern in 'host.name: Str(' 'os.type: Str(' 'deployment.environment.name: Str(staging)'; do
  if ! printf '%s\n' "$collector_logs" | grep -qF -- "$pattern"; then
    echo "FAIL: the output has no attribute $pattern"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: the exported traces carry host.name, os.type and deployment.environment.name staging"
fi
exit "$fail"
