#!/usr/bin/env bash
# Check: the error budget is correct
set -uo pipefail

fail=0
# True when the numeric value $1 is within $3 of $2 (a trailing % is ignored).
close_to() {
  awk -v got="${1%\%}" -v want="$2" -v tol="$3" 'BEGIN { d = got - want; if (d < 0) d = -d; exit !(got != "" && d <= tol) }'
}

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

bad=$((valid - good))
allowed="$(awk -v v="$valid" 'BEGIN { printf "%.4f", v * 0.5 / 100 }')"
consumed="$(awk -v b="$bad" -v a="$allowed" 'BEGIN { printf "%.4f", b / a * 100 }')"
remaining="$(awk -v b="$bad" -v a="$allowed" 'BEGIN { printf "%.4f", a - b }')"
if ! close_to "$(get_key allowed_bad_events)" "$allowed" 0.06; then
  echo "FAIL: allowed_bad_events is '$(get_key allowed_bad_events)'"
  fail=1
fi
if ! close_to "$(get_key budget_consumed_percent)" "$consumed" 0.06; then
  echo "FAIL: budget_consumed_percent is '$(get_key budget_consumed_percent)'"
  fail=1
fi
if ! close_to "$(get_key budget_remaining_events)" "$remaining" 0.06; then
  echo "FAIL: budget_remaining_events is '$(get_key budget_remaining_events)'"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the error budget is correct"
fi
exit "$fail"
