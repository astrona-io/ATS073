#!/usr/bin/env bash
# Check: spans use the current names and carry no personal data
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
for needle in 'http.method:' 'http.status_code:' 'user.email'; do
  n="$(count_in_signal ResourceSpans "$needle")"
  if [ "$n" -gt 0 ]; then
    echo "FAIL: spans still carry $needle"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: spans are normalized"
fi
exit "$fail"
