#!/usr/bin/env bash
# Starting state. Three services send telemetry with legacy names, personal data and a high-cardinality attribute; the Collector changes nothing.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/observability.yaml"
kubectl apply -f "$DIR/manifests/starfleet.yaml"

kubectl -n observability rollout status deployment/otel-collector --timeout=300s
kubectl -n starfleet rollout status deployment/scout-load --timeout=300s
kubectl -n starfleet rollout status deployment/shuttle-load --timeout=300s
kubectl -n starfleet rollout status deployment/probe-load --timeout=300s
echo "[lab] Ready."
