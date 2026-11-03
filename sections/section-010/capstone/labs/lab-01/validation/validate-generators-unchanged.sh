#!/usr/bin/env bash
# Check: both load generators are unchanged
set -uo pipefail

fail=0
for deployment in bridge-load probe-load; do
  images="$(kubectl -n starfleet get deployment "$deployment" -o jsonpath='{.spec.template.spec.containers[*].image}' 2>/dev/null)"
  if [ -z "$images" ]; then
    echo "FAIL: Deployment $deployment is missing"
    fail=1
  fi
  for image in $images; do
    if [ "$image" != "ghcr.io/open-telemetry/opentelemetry-collector-contrib/telemetrygen:v0.162.0" ]; then
      echo "FAIL: $deployment uses unexpected image $image"
      fail=1
    fi
  done
done
count="$(kubectl -n starfleet get deployment bridge-load -o jsonpath='{.spec.template.spec.containers[*].name}' 2>/dev/null | wc -w | tr -d ' ')"
if [ "$count" != "3" ]; then
  echo "FAIL: bridge-load must keep its three containers"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the generators are unchanged"
fi
exit "$fail"
