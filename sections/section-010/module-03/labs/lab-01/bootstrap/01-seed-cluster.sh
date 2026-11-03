#!/usr/bin/env bash
# Starting state. The Collector passes every log record, including Debug records, to the debug exporter.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/observability.yaml"
kubectl apply -f "$DIR/manifests/starfleet.yaml"

kubectl -n observability rollout status deployment/otel-collector --timeout=300s
kubectl -n starfleet rollout status deployment/shuttle-logs --timeout=300s
echo "[lab] Ready."
