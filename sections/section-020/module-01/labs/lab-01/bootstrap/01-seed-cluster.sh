#!/usr/bin/env bash
# Starting state. The generator emits old attribute names and a personal attribute; the Collector changes nothing.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/observability.yaml"
kubectl apply -f "$DIR/manifests/starfleet.yaml"

kubectl -n observability rollout status deployment/otel-collector --timeout=300s
kubectl -n starfleet rollout status deployment/scout-load --timeout=300s
echo "[lab] Ready."
