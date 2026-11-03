#!/usr/bin/env bash
# Reference solution.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "$DIR/solution.yaml"
kubectl -n starfleet rollout status deployment/shuttle-billing --timeout=300s
