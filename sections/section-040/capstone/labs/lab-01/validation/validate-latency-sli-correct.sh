#!/usr/bin/env bash
# Check: the latency counts and SLI are correct
set -uo pipefail

fail=0
# True when the numeric value $1 is within $3 of $2 (a trailing % is ignored).
close_to() {
  awk -v got="${1%\%}" -v want="$2" -v tol="$3" 'BEGIN { d = got - want; if (d < 0) d = -d; exit !(got != "" && d <= tol) }'
}

metrics="$(kubectl -n observability get configmap scout-metrics-data -o jsonpath='{.data.metrics}' 2>/dev/null)"
total="$(printf '%s\n' "$metrics" | awk '/^http_request_duration_seconds_count/ { print $NF }')"
under="$(printf '%s\n' "$metrics" | awk '/^http_request_duration_seconds_bucket/ && /le="0.3"/ { print $NF }')"
if [ -z "$total" ] || [ -z "$under" ]; then
  echo "FAIL: cannot read the scout-metrics-data ConfigMap"
  exit 1
fi
get_key() { kubectl -n starfleet get configmap latency-report -o "jsonpath={.data.$1}" 2>/dev/null; }
if ! kubectl -n starfleet get configmap latency-report >/dev/null 2>&1; then
  echo "FAIL: ConfigMap latency-report does not exist in starfleet"
  exit 1
fi
if [ "$(get_key requests_total)" != "$total" ]; then
  echo "FAIL: requests_total must be the histogram count ($total)"
  fail=1
fi
if [ "$(get_key under_300ms)" != "$under" ]; then
  echo "FAIL: under_300ms must be the cumulative bucket le=0.3 ($under)"
  fail=1
fi
want="$(awk -v u="$under" -v t="$total" 'BEGIN { printf "%.4f", u / t * 100 }')"
if ! close_to "$(get_key latency_sli)" "$want" 0.006; then
  echo "FAIL: latency_sli is '$(get_key latency_sli)'; recompute under_300ms / requests_total * 100"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the latency counts and SLI are correct"
fi
exit "$fail"
