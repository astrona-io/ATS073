#!/usr/bin/env bash
# Check: the running Collector exports a large share of error spans
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1 2>/dev/null)"
total="$(printf '%s\n' "$collector_logs" | grep -c 'Span #')"
errors="$(printf '%s\n' "$collector_logs" | grep -c 'Status code *: Error')"

if [ "$total" -lt 10 ]; then
  echo "FAIL: only $total spans in the last 120 seconds; restart the Collector, wait 60 seconds and submit again"
  exit 1
fi
if [ "$errors" -lt 20 ]; then
  echo "FAIL: only $errors error spans in the last 120 seconds; the sampler must keep every error trace"
  fail=1
fi
# With every error kept, at least a quarter of the exported spans are errors.
if [ $((errors * 4)) -lt "$total" ]; then
  echo "FAIL: error spans are $errors of $total; the sampler still drops error traces"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: error traces are kept"
fi
exit "$fail"
