#!/usr/bin/env bash
# Check: each signal carries the added resource attributes and keeps service.name bridge
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

for header in ResourceSpans ResourceMetrics ResourceLog; do
  for needle in 'deployment.environment.name: Str(production)' 'service.namespace: Str(starfleet)' 'service.name: Str(bridge)'; do
    n="$(count_in_signal "$header" "$needle")"
    if [ "$n" -lt 1 ]; then
      echo "FAIL: no '$needle' in $header blocks"
      fail=1
    fi
  done
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: every signal carries the resource identity"
fi
exit "$fail"
