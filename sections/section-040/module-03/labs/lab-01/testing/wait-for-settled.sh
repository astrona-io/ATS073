#!/usr/bin/env bash
# Runs under `astrona test` after the reference solution.
set -euo pipefail

kubectl -n observability rollout status deployment/prometheus --timeout=180s
for attempt in $(seq 1 40); do
  if kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/alerts' 2>/dev/null | grep -q '"state":"firing"'; then
    echo "[testing] settled."
    exit 0
  fi
  sleep 3
done
echo "[testing] the alert did not fire in time." >&2
exit 1
