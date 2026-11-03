#!/usr/bin/env bash
# Check: log records carry no user.email
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1 2>/dev/null)"
# Count the attribute lines that sit inside blocks of one signal. Blocks start
# with ResourceSpans, ResourceMetrics or ResourceLog at the start of a line.
count_in_signal() {
  printf '%s\n' "$collector_logs" | awk -v header="$1" -v needle="$2" '
    /^Resource(Spans|Metrics|Logs?) / { current = ($0 ~ header) }
    current && index($0, needle) { n++ }
    END { print n + 0 }'
}

records="$(count_in_signal ResourceLog 'Resource attributes')"
if [ "$records" -lt 1 ]; then
  echo "FAIL: no log records in the last 120 seconds; wait and submit again"
  exit 1
fi
n="$(count_in_signal ResourceLog 'user.email')"
if [ "$n" -gt 0 ]; then
  echo "FAIL: log records still carry user.email"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: log records carry no personal data"
fi
exit "$fail"
