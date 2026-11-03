#!/usr/bin/env bash
# Starting state. The server span and the client span are in different traces.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/observability.yaml"
kubectl apply -f "$DIR/manifests/starfleet.yaml"

kubectl -n observability rollout status deployment/otel-collector --timeout=300s
kubectl -n starfleet rollout status deployment/shuttle-billing --timeout=300s
kubectl -n starfleet rollout status deployment/shuttle-client --timeout=300s
echo "[lab] Ready."
