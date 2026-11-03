#!/usr/bin/env bash
# Reference solution: replace the program code and restart the Deployment.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "$DIR/solution.yaml"
kubectl -n starfleet rollout restart deployment/shuttle-orders
kubectl -n starfleet rollout status deployment/shuttle-orders --timeout=300s
