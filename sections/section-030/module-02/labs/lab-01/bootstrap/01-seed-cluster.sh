#!/usr/bin/env bash
# Starting state. The program starts spans without a kind, swallows the rejection error without recording it, and has no duration histogram.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/observability.yaml"
kubectl apply -f "$DIR/manifests/starfleet.yaml"

kubectl -n observability rollout status deployment/otel-collector --timeout=300s
kubectl -n starfleet rollout status deployment/shuttle-orders --timeout=300s
echo "[lab] Ready."
