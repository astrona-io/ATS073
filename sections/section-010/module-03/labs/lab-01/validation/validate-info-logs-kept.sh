#!/usr/bin/env bash
# Check: Info log records are still exported
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1 2>/dev/null)"
info="$(printf '%s\n' "$collector_logs" | grep -ci 'SeverityText: *info')"
if [ "$info" -lt 5 ]; then
  echo "FAIL: only $info Info records in the last 120 seconds; the filter must keep Info and above"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: Info log records are still exported"
fi
exit "$fail"
