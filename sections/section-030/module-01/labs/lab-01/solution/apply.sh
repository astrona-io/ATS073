#!/usr/bin/env bash
# Reference solution.
set -euo pipefail

kubectl -n starfleet set env deployment/shuttle-orders \
  OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector.observability:4318 \
  OTEL_SERVICE_NAME=shuttle-orders \
  OTEL_RESOURCE_ATTRIBUTES=deployment.environment.name=production,service.version=1.4.0
kubectl -n starfleet rollout status deployment/shuttle-orders --timeout=300s
