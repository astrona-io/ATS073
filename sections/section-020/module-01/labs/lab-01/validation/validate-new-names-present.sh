#!/usr/bin/env bash
# Check: spans carry the current attribute names with the right types
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

for needle in 'http.request.method: Str(GET)' 'http.response.status_code: Int(200)'; do
  n="$(count_in_signal ResourceSpans "$needle")"
  if [ "$n" -lt 1 ]; then
    echo "FAIL: no '$needle' in the spans of the last 120 seconds"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: spans carry the current attribute names"
fi
exit "$fail"
