#!/usr/bin/env bash
# Check: the service name harbor is kept and the generator is unchanged
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1 2>/dev/null)"
if ! printf '%s\n' "$collector_logs" | grep -q 'service.name: Str(harbor)'; then
  echo "FAIL: no span with service.name harbor in the last 120 seconds"
  fail=1
fi
image="$(kubectl -n starfleet get deployment harbor-db-load -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
if [ "$image" != "ghcr.io/open-telemetry/opentelemetry-collector-contrib/telemetrygen:v0.162.0" ]; then
  echo "FAIL: the harbor-db-load image is '$image'"
  fail=1
fi
if ! kubectl -n starfleet get deployment harbor-db-load -o jsonpath='{.spec.template.spec.containers[0].args}' 2>/dev/null | grep -q 'db.statement'; then
  echo "FAIL: the harbor-db-load arguments were changed; fix the Collector instead"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the service name is kept and the generator is unchanged"
fi
exit "$fail"
