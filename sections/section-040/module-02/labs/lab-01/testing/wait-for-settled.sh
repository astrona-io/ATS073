#!/usr/bin/env bash
# Runs under `astrona test` after the reference solution: waits until the
# recorded series exist (one scrape and one evaluation).
set -euo pipefail

for attempt in $(seq 1 40); do
  if kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/query?query=shuttle:http_request_duration_seconds:under_300ms_ratio' 2>/dev/null | grep -q '"value"'; then
    echo "[testing] settled."
    exit 0
  fi
  sleep 3
done
echo "[testing] the recording rules did not produce values in time." >&2
exit 1
