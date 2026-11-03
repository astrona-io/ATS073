#!/usr/bin/env bash
# Check: The Collector Deployment is available with its original image
set -uo pipefail

fail=0
image="$(kubectl -n observability get deployment otel-collector -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
available="$(kubectl -n observability get deployment otel-collector -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
if [ "$image" != "otel/opentelemetry-collector-contrib:0.164.0" ]; then
  echo "FAIL: the Collector image is '$image'"
  fail=1
fi
if [ "${available:-0}" -lt 1 ]; then
  echo "FAIL: the Collector Deployment has no available replica"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the Collector is available with its original image"
fi
exit "$fail"
