#!/usr/bin/env bash
# Check: valid_events and good_events are correct
set -uo pipefail

fail=0
metrics="$(kubectl -n observability get configmap bridge-metrics-data -o jsonpath='{.data.metrics}' 2>/dev/null)"
# Population: requests on route /orders. Valid = all except 4xx. Good = 2xx and 3xx.
read -r valid good <<<"$(printf '%s\n' "$metrics" | awk '
  /^http_requests_total\{/ && /route="\/orders"/ {
    match($0, /code="[0-9]+"/)
    code = substr($0, RSTART + 6, RLENGTH - 7)
    if (code ~ /^4/) next
    valid += $NF
    if (code ~ /^[23]/) good += $NF
  }
  END { printf "%d %d\n", valid, good }')"
if [ -z "${valid:-}" ] || [ "$valid" -eq 0 ]; then
  echo "FAIL: cannot read the metrics ConfigMap bridge-metrics-data"
  exit 1
fi
get_key() { kubectl -n starfleet get configmap slo-report -o "jsonpath={.data.$1}" 2>/dev/null; }
if ! kubectl -n starfleet get configmap slo-report >/dev/null 2>&1; then
  echo "FAIL: ConfigMap slo-report does not exist in starfleet"
  exit 1
fi

if [ "$(get_key valid_events)" != "$valid" ]; then
  echo "FAIL: valid_events must count all /orders requests except 4xx"
  fail=1
fi
if [ "$(get_key good_events)" != "$good" ]; then
  echo "FAIL: good_events must count the 2xx and 3xx /orders requests"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the populations are correct"
fi
exit "$fail"
