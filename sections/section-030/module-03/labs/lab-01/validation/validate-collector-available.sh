#!/usr/bin/env bash
# Check: the Collector Deployment is available with its original image
set -uo pipefail

image="$(kubectl -n observability get deployment otel-collector -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
available="$(kubectl -n observability get deployment otel-collector -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
if [ "$image" != "otel/opentelemetry-collector-contrib:0.164.0" ] || [ "${available:-0}" -lt 1 ]; then
  echo "FAIL: the Collector must keep its image and be available (image '$image', available '${available:-0}')"
  exit 1
fi
echo "PASS: the Collector is available"
