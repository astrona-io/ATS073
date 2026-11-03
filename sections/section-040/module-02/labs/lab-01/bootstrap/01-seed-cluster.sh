#!/usr/bin/env bash
# Starting state. Prometheus scrapes bridge and shuttle and evaluates rules every 5 seconds, but no rule file is configured.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/observability.yaml"

kubectl -n observability rollout status deployment/prometheus --timeout=300s
kubectl -n observability rollout status deployment/bridge-metrics --timeout=300s
kubectl -n observability rollout status deployment/shuttle-metrics --timeout=300s
echo "[lab] Ready."
