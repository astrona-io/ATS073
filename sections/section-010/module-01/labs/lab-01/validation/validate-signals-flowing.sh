#!/usr/bin/env bash
# Check: the Collector log shows spans, metrics and log records
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

for header in ResourceSpans ResourceMetrics 'ResourceLog'; do
  n="$(printf '%s\n' "$collector_logs" | grep -c "^$header" || true)"
  if [ "$n" -lt 1 ]; then
    echo "FAIL: no $header block in the last 120 seconds of Collector output"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: spans, metrics and log records reach the debug exporter"
fi
exit "$fail"
