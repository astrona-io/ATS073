#!/usr/bin/env bash
# Check: the metric orders.duration arrives as a histogram in seconds
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=300s --tail=-1 2>/dev/null)"
metrics="$(printf '%s\n' "$collector_logs" | grep -c -- '-> Name: orders.duration')"
if [ "$metrics" -lt 1 ]; then
  echo "FAIL: no metric orders.duration in the last 300 seconds (a new pod needs about a minute after the change)"
  exit 1
fi
if ! printf '%s\n' "$collector_logs" | grep -A6 -- '-> Name: orders.duration' | grep -q 'Unit: s'; then
  echo "FAIL: orders.duration must have the unit s"
  fail=1
fi
if ! printf '%s\n' "$collector_logs" | grep -A6 -- '-> Name: orders.duration' | grep -q 'Histogram'; then
  echo "FAIL: orders.duration must be a histogram"
  fail=1
fi
if ! printf '%s\n' "$collector_logs" | grep -q 'order.outcome: Str('; then
  echo "FAIL: the measurements must carry the attribute order.outcome"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: orders.duration arrives as a histogram"
fi
exit "$fail"
