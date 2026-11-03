#!/usr/bin/env bash
# Check: Prometheus is intact and still scrapes bridge
set -uo pipefail

fail=0
image="$(kubectl -n observability get deployment prometheus -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
available="$(kubectl -n observability get deployment prometheus -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
if [ "$image" != "prom/prometheus:v3.15.1" ] || [ "${available:-0}" -lt 1 ]; then
  echo "FAIL: Prometheus must keep its image and be available (image '$image')"
  fail=1
fi
result="$(kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/query?query=up%7Bjob%3D%22bridge%22%7D' 2>/dev/null || true)"
if ! printf '%s' "$result" | grep -q '"1"\]'; then
  echo "FAIL: Prometheus does not report up == 1 for job bridge"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: Prometheus is intact and scrapes bridge"
fi
exit "$fail"
