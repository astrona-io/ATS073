#!/usr/bin/env bash
# Starting state. Three programs run the same instrumented code with three different configuration mistakes.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/observability.yaml"
kubectl apply -f "$DIR/manifests/starfleet.yaml"

kubectl -n observability rollout status deployment/otel-collector --timeout=300s
kubectl -n starfleet rollout status deployment/scout-api --timeout=300s
kubectl -n starfleet rollout status deployment/scout-worker --timeout=300s
kubectl -n starfleet rollout status deployment/probe-batch --timeout=300s
echo "[lab] Ready."
