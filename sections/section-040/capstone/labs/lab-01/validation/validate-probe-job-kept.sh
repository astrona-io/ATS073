#!/usr/bin/env bash
# Check: the probe job is kept and has no request series
set -uo pipefail

fail=0
config="$(kubectl -n observability get configmap prometheus-config -o jsonpath='{.data.prometheus\.yml}' 2>/dev/null)"
if ! printf '%s' "$config" | grep -q 'job_name: probe'; then
  echo "FAIL: the job probe was removed from prometheus-config"
  fail=1
fi
result="$(kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/query?query=http_requests_total%7Bservice%3D%22probe%22%7D' 2>/dev/null || true)"
if ! printf '%s' "$result" | grep -q '"result":\[\]'; then
  echo "FAIL: Prometheus returns series for the service probe; the probe target must have no data"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the probe job is kept and has no series"
fi
exit "$fail"
