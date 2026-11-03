#!/usr/bin/env bash
# Check: the shuttle-load Deployment still has its original container and image
set -uo pipefail

fail=0
names="$(kubectl -n starfleet get deployment shuttle-load -o jsonpath='{.spec.template.spec.containers[*].name}' 2>/dev/null)"
image="$(kubectl -n starfleet get deployment shuttle-load -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
if [ "$names" != "traces" ] || [ "$image" != "ghcr.io/open-telemetry/opentelemetry-collector-contrib/telemetrygen:v0.162.0" ]; then
  echo "FAIL: shuttle-load must keep the container traces and its image"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the shuttle-load Deployment still has its original container and image"
fi
exit "$fail"
