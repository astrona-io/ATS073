#!/usr/bin/env bash
# Starting state. The program starts with a wrong exporter port and no service name or resource attributes.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/observability.yaml"
kubectl apply -f "$DIR/manifests/starfleet.yaml"

kubectl -n observability rollout status deployment/otel-collector --timeout=300s
kubectl -n starfleet rollout status deployment/shuttle-orders --timeout=300s
echo "[lab] Ready."
