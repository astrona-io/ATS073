#!/usr/bin/env bash
# Reference solution.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RES="OTEL_RESOURCE_ATTRIBUTES=deployment.environment.name=production"
kubectl -n starfleet set env deployment/scout-api OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector.observability:4318 OTEL_SERVICE_NAME=scout-api "$RES"
kubectl -n starfleet set env deployment/scout-worker OTEL_SDK_DISABLED- "$RES"
kubectl -n starfleet set env deployment/probe-batch OTEL_TRACES_SAMPLER=always_on "$RES"
for name in scout-api scout-worker probe-batch; do
  kubectl -n starfleet rollout status "deployment/$name" --timeout=300s
done
kubectl apply -f "$DIR/solution.yaml"
