#!/usr/bin/env bash
# Check: the running Collector exports no Debug log records
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1 2>/dev/null)"
info="$(printf '%s\n' "$collector_logs" | grep -ci 'SeverityText: *info')"
if [ "$info" -lt 5 ]; then
  echo "FAIL: only $info Info records in the last 120 seconds; restart the Collector, wait 60 seconds and submit again"
  exit 1
fi
debug="$(printf '%s\n' "$collector_logs" | grep -ci 'SeverityText: *debug')"
if [ "$debug" -gt 0 ]; then
  echo "FAIL: $debug Debug records were exported in the last 120 seconds"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the running Collector exports no Debug log records"
fi
exit "$fail"
