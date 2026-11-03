#!/usr/bin/env bash
# Check: the Deployment keeps its image, its launcher and its ConfigMap volume
set -uo pipefail

fail=0
image="$(kubectl -n starfleet get deployment shuttle-orders -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
volume="$(kubectl -n starfleet get deployment shuttle-orders -o jsonpath='{.spec.template.spec.volumes[0].configMap.name}' 2>/dev/null)"
command_line="$(kubectl -n starfleet get deployment shuttle-orders -o jsonpath='{.spec.template.spec.containers[0].command}' 2>/dev/null)"
if [ "$image" != "python:3.13-slim" ] || [ "$volume" != "orders-app" ]; then
  echo "FAIL: shuttle-orders must keep its image and the orders-app volume"
  fail=1
fi
if ! printf '%s' "$command_line" | grep -q 'opentelemetry-instrument'; then
  echo "FAIL: shuttle-orders must still start through opentelemetry-instrument"
  fail=1
fi
if ! kubectl -n starfleet get configmap orders-app -o jsonpath='{.data.app\.py}' 2>/dev/null | grep -q 'get_tracer("starfleet.orders"'; then
  echo "FAIL: the program must keep the tracer scope starfleet.orders"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the Deployment and the scope are unchanged"
fi
exit "$fail"
