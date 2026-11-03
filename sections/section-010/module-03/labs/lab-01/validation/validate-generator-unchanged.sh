#!/usr/bin/env bash
# Check: the shuttle-logs Deployment still has its two containers and its original image
set -uo pipefail

fail=0
names="$(kubectl -n starfleet get deployment shuttle-logs -o jsonpath='{.spec.template.spec.containers[*].name}' 2>/dev/null)"
image="$(kubectl -n starfleet get deployment shuttle-logs -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
if [ "$names" != "logs-info logs-debug" ] || [ "$image" != "ghcr.io/open-telemetry/opentelemetry-collector-contrib/telemetrygen:v0.162.0" ]; then
  echo "FAIL: shuttle-logs must keep the containers logs-info and logs-debug and its image"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the shuttle-logs Deployment still has its two containers and its original image"
fi
exit "$fail"
