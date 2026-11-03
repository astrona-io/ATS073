#!/usr/bin/env bash
# Runs under `astrona test` after the reference solution: the pod installs the
# SDK with pip at start, so wait until the new metric shows up in the log.
set -euo pipefail

for attempt in $(seq 1 60); do
  if kubectl -n observability logs deploy/otel-collector --since=300s --tail=-1 2>/dev/null | grep -q -- '-> Name: orders.duration'; then
    break
  fi
  sleep 5
done
echo "[testing] settled."
