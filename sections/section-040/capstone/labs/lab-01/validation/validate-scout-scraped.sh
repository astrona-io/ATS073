#!/usr/bin/env bash
# Check: Prometheus scrapes scout
set -uo pipefail

fail=0
result="$(kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/query?query=up%7Bjob%3D%22scout%22%7D' 2>/dev/null || true)"
if ! printf '%s' "$result" | grep -q '"1"\]'; then
  echo "FAIL: Prometheus does not report up == 1 for job scout"
  fail=1
fi
result="$(kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/query?query=http_request_duration_seconds_count%7Bjob%3D%22scout%22%7D' 2>/dev/null || true)"
if ! printf '%s' "$result" | grep -q '"48000"'; then
  echo "FAIL: Prometheus has no http_request_duration_seconds_count series with value 48000 for job scout"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: Prometheus scrapes scout"
fi
exit "$fail"
