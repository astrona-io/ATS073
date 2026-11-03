#!/usr/bin/env bash
# Starting state. The Collector has traces and logs pipelines only, no processors, and no evidence record exists.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/observability.yaml"
kubectl apply -f "$DIR/manifests/starfleet.yaml"

kubectl -n observability rollout status deployment/otel-collector --timeout=300s
kubectl -n starfleet rollout status deployment/bridge-load --timeout=300s
kubectl -n starfleet rollout status deployment/probe-load --timeout=300s
echo "[lab] Ready."
