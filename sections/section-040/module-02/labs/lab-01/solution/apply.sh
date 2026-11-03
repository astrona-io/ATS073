#!/usr/bin/env bash
# Reference solution: add the rule file to the ConfigMap and restart Prometheus.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "$DIR/solution.yaml"
kubectl -n observability rollout restart deployment/prometheus
kubectl -n observability rollout status deployment/prometheus --timeout=180s
