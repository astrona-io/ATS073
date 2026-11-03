#!/usr/bin/env bash
# Check: spans arrive with the service name and the span name
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

n="$(count_blocks_with ResourceSpans 'service.name: Str(shuttle-orders)' 'process-order')"
if [ "$n" -lt 1 ]; then
  echo "FAIL: no span process-order from service.name shuttle-orders in the last 300 seconds (a new pod needs about a minute after the change)"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: spans arrive named"
fi
exit "$fail"
