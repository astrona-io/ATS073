#!/usr/bin/env bash
# Check: metric data points carry no customer.id
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

metrics="$(count_in_signal ResourceMetrics 'Resource attributes')"
if [ "$metrics" -lt 1 ]; then
  echo "FAIL: no metrics in the last 120 seconds; wait and submit again"
  exit 1
fi
n="$(count_in_signal ResourceMetrics 'customer.id')"
if [ "$n" -gt 0 ]; then
  echo "FAIL: metric data points still carry customer.id"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: metric data points carry no unbounded identifier"
fi
exit "$fail"
