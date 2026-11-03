#!/usr/bin/env bash
# Check: old attribute names are gone from the spans
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

spans="$(count_in_signal ResourceSpans 'Resource attributes')"
if [ "$spans" -lt 1 ]; then
  echo "FAIL: no spans in the last 120 seconds; wait and submit again"
  exit 1
fi
for needle in 'http.method:' 'http.status_code:'; do
  n="$(count_in_signal ResourceSpans "$needle")"
  if [ "$n" -gt 0 ]; then
    echo "FAIL: spans still carry $needle"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: old attribute names are gone"
fi
exit "$fail"
