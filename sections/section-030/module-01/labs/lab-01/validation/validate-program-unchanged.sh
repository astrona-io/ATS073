#!/usr/bin/env bash
# Check: the program is unchanged
set -uo pipefail

fail=0
for deployment in shuttle-orders; do
  image="$(kubectl -n starfleet get deployment "$deployment" -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
  volume="$(kubectl -n starfleet get deployment "$deployment" -o jsonpath='{.spec.template.spec.volumes[0].configMap.name}' 2>/dev/null)"
  if [ "$image" != "python:3.13-slim" ] || [ "$volume" != "orders-app" ]; then
    echo "FAIL: $deployment must keep its image and the orders-app code"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: the program is unchanged"
fi
exit "$fail"
