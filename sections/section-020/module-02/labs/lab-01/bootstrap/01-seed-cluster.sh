#!/usr/bin/env bash
# Starting state. The generator emits old database attribute names and a literal id in the query text; the Collector changes nothing.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/observability.yaml"
kubectl apply -f "$DIR/manifests/starfleet.yaml"

kubectl -n observability rollout status deployment/otel-collector --timeout=300s
kubectl -n starfleet rollout status deployment/harbor-db-load --timeout=300s
echo "[lab] Ready."
