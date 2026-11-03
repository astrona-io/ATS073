#!/usr/bin/env bash
# Check: BridgeSlowBurn is firing
set -uo pipefail

fail=0
alerts="$(kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/alerts' 2>/dev/null || true)"
if ! printf '%s' "$alerts" | grep -qE '"alertname":"BridgeSlowBurn"[^}]*\},"annotations":\{[^}]*\},"state":"firing"'; then
  echo "FAIL: BridgeSlowBurn is not firing (a new alert needs about 20 seconds after Prometheus starts)"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: BridgeSlowBurn is firing"
fi
exit "$fail"
