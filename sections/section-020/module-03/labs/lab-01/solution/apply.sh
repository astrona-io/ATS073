#!/usr/bin/env bash
# Reference solution.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "$DIR/solution.yaml"
kubectl -n observability set env deployment/otel-collector OTEL_RESOURCE_ATTRIBUTES=deployment.environment.name=staging
kubectl -n observability rollout status deployment/otel-collector --timeout=180s
