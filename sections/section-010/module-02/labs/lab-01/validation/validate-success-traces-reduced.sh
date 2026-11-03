#!/usr/bin/env bash
# Check: success traces are sampled down, so the Ok spans are fewer than the generator sends
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1 2>/dev/null)"
ok="$(printf '%s\n' "$collector_logs" | grep -c 'Status code *: Ok')"
errors="$(printf '%s\n' "$collector_logs" | grep -c 'Status code *: Error')"

if [ "$errors" -lt 20 ]; then
  echo "FAIL: too few error spans to judge; restart the Collector, wait 60 seconds and submit again"
  exit 1
fi
# The generator sends 15 Ok spans for each error span. Without sampling, ok would be about 15 times errors.
if [ "$ok" -gt $((errors * 6)) ]; then
  echo "FAIL: $ok Ok spans for $errors error spans; the other traces are not sampled down"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: success traces are sampled down"
fi
exit "$fail"
