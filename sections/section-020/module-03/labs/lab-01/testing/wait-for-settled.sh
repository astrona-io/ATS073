#!/usr/bin/env bash
# Runs under `astrona test` after the reference solution.
set -euo pipefail

kubectl -n observability rollout status deployment/otel-collector --timeout=180s
for attempt in $(seq 1 40); do
  if kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1 2>/dev/null | grep -q 'host.name: Str'; then
    echo "[testing] settled."
    exit 0
  fi
  sleep 3
done
echo "[testing] the expected output did not appear in time." >&2
exit 1
