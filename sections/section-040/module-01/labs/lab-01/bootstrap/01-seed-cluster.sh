#!/usr/bin/env bash
# Starting state. Prometheus scrapes fixed request counters for bridge. No SLO report exists.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/starfleet.yaml"
kubectl apply -f "$DIR/manifests/observability.yaml"

kubectl -n observability rollout status deployment/prometheus --timeout=300s
kubectl -n observability rollout status deployment/bridge-metrics --timeout=300s
echo "[lab] Ready."
