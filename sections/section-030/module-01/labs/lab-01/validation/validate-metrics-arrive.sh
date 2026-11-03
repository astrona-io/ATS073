#!/usr/bin/env bash
# Check: the counter arrives
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=300s --tail=-1 2>/dev/null)"
# Count the attribute lines that sit inside blocks of one signal. Blocks start
# with ResourceSpans, ResourceMetrics or ResourceLog at the start of a line.
count_in_signal() {
  printf '%s\n' "$collector_logs" | awk -v header="$1" -v needle="$2" '
    /^Resource(Spans|Metrics|Logs?) / { current = ($0 ~ header) }
    current && index($0, needle) { n++ }
    END { print n + 0 }'
}

# Count blocks of one signal that contain both needles.
count_blocks_with() {
  printf '%s\n' "$collector_logs" | awk -v header="$1" -v first="$2" -v second="$3" '
    function flush() { if (current && a && b) n++ }
    /^Resource(Spans|Metrics|Logs?) / { flush(); current = ($0 ~ header); a = 0; b = 0 }
    current && index($0, first) { a = 1 }
    current && index($0, second) { b = 1 }
    END { flush(); print n + 0 }'
}

n="$(count_blocks_with ResourceMetrics 'service.name: Str(shuttle-orders)' 'orders.processed')"
if [ "$n" -lt 1 ]; then
  echo "FAIL: no metric orders.processed from service.name shuttle-orders in the last 300 seconds"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the counter arrives"
fi
exit "$fail"
