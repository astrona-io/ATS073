#!/usr/bin/env bash
# Check: the verdict is correct
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

if ! close_to "$(get_key slo_target)" 99.5 0.001; then
  echo "FAIL: slo_target must be 99.5"
  fail=1
fi
verdict="$(awk -v g="$good" -v v="$valid" 'BEGIN { print (g / v * 100 >= 99.5) ? "yes" : "no" }')"
if [ "$(get_key slo_met)" != "$verdict" ]; then
  echo "FAIL: slo_met must be $verdict"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the verdict is correct"
fi
exit "$fail"
