#!/usr/bin/env bash
# Check: the Collector container has OTEL_RESOURCE_ATTRIBUTES with the environment name staging
set -uo pipefail

fail=0
value="$(kubectl -n observability get deployment otel-collector -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="OTEL_RESOURCE_ATTRIBUTES")].value}' 2>/dev/null)"
if [ "$value" != "deployment.environment.name=staging" ]; then
  echo "FAIL: OTEL_RESOURCE_ATTRIBUTES is '$value', expected deployment.environment.name=staging"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the Collector container has OTEL_RESOURCE_ATTRIBUTES with the environment name staging"
fi
exit "$fail"
