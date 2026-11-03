#!/usr/bin/env bash
# Check: the verdict and the data gap are recorded
set -uo pipefail

fail=0
# True when the numeric value $1 is within $3 of $2 (a trailing % is ignored).
close_to() {
  awk -v got="${1%\%}" -v want="$2" -v tol="$3" 'BEGIN { d = got - want; if (d < 0) d = -d; exit !(got != "" && d <= tol) }'
}

metrics="$(kubectl -n observability get configmap scout-metrics-data -o jsonpath='{.data.metrics}' 2>/dev/null)"
total="$(printf '%s\n' "$metrics" | awk '/^http_request_duration_seconds_count/ { print $NF }')"
under="$(printf '%s\n' "$metrics" | awk '/^http_request_duration_seconds_bucket/ && /le="0.3"/ { print $NF }')"
get_key() { kubectl -n starfleet get configmap latency-report -o "jsonpath={.data.$1}" 2>/dev/null; }
if ! kubectl -n starfleet get configmap latency-report >/dev/null 2>&1; then
  echo "FAIL: ConfigMap latency-report does not exist in starfleet"
  exit 1
fi
if ! close_to "$(get_key slo_target)" 95 0.001; then
  echo "FAIL: slo_target must be 95"
  fail=1
fi
verdict="$(awk -v u="$under" -v t="$total" 'BEGIN { print (u / t * 100 >= 95) ? "yes" : "no" }')"
if [ "$(get_key slo_met)" != "$verdict" ]; then
  echo "FAIL: slo_met must be $verdict"
  fail=1
fi
if [ "$(get_key probe_status)" != "no-data" ]; then
  echo "FAIL: probe_status must be no-data, because the probe target has no series"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the verdict and the data gap are recorded"
fi
exit "$fail"
