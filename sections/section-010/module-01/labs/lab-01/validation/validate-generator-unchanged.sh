#!/usr/bin/env bash
# Check: the load generator is unchanged
set -uo pipefail

fail=0
names="$(kubectl -n starfleet get deployment bridge-load -o jsonpath='{.spec.template.spec.containers[*].name}' 2>/dev/null)"
images="$(kubectl -n starfleet get deployment bridge-load -o jsonpath='{.spec.template.spec.containers[*].image}' 2>/dev/null)"
if [ "$names" != "traces metrics logs" ]; then
  echo "FAIL: bridge-load containers are '$names'"
  fail=1
fi
for image in $images; do
  if [ "$image" != "ghcr.io/open-telemetry/opentelemetry-collector-contrib/telemetrygen:v0.162.0" ]; then
    echo "FAIL: unexpected image $image"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: the generator is unchanged"
fi
exit "$fail"
