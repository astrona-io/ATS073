#!/usr/bin/env bash
# Starting state. The Collector has only a traces pipeline, and no resource identity is added. The generator sends three signals.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/observability.yaml"
kubectl apply -f "$DIR/manifests/starfleet.yaml"

kubectl -n observability rollout status deployment/otel-collector --timeout=300s
kubectl -n starfleet rollout status deployment/bridge-load --timeout=300s
echo "[lab] Ready."
