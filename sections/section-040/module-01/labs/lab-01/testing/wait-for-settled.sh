#!/usr/bin/env bash
# Runs under `astrona test` after the reference solution: waits for Prometheus
# to scrape the targets again.
set -euo pipefail

kubectl -n observability rollout status deployment/prometheus --timeout=180s
for attempt in $(seq 1 40); do
  if kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/query?query=up%7Bjob%3D%22bridge%22%7D' 2>/dev/null | grep -q '"1"\]'; then
    echo "[testing] settled."
    exit 0
  fi
  sleep 3
done
echo "[testing] Prometheus did not report the target as up in time." >&2
exit 1

