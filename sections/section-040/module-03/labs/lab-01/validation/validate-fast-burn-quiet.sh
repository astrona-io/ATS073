#!/usr/bin/env bash
# Check: BridgeFastBurn is not firing
set -uo pipefail

fail=0
alerts="$(kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/alerts' 2>/dev/null || true)"
if ! printf '%s' "$alerts" | grep -q '"alertname":"BridgeSlowBurn"'; then
  echo "FAIL: Prometheus reports no active alert yet; load the rules and wait"
  exit 1
fi
if printf '%s' "$alerts" | grep -q '"alertname":"BridgeFastBurn"'; then
  echo "FAIL: BridgeFastBurn is active; its threshold must be 14.4 * 0.001"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: BridgeFastBurn is not firing"
fi
exit "$fail"
