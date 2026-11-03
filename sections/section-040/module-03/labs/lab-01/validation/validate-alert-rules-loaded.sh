#!/usr/bin/env bash
# Check: Prometheus has loaded BridgeSlowBurn and BridgeFastBurn with severity labels and a summary
set -uo pipefail

fail=0
rules="$(kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/rules?type=alert' 2>/dev/null || true)"
if ! printf '%s' "$rules" | grep -q '"type":"alerting"'; then
  echo "FAIL: Prometheus has loaded no alerting rule (list the file under rule_files and restart Prometheus)"
  exit 1
fi
for name in BridgeSlowBurn BridgeFastBurn; do
  if ! printf '%s' "$rules" | grep -q "\"name\":\"$name\""; then
    echo "FAIL: the alert $name is not loaded"
    fail=1
  fi
done
slow="$(printf '%s' "$rules" | grep -oE '"name":"BridgeSlowBurn".{0,700}' | head -1)"
fast="$(printf '%s' "$rules" | grep -oE '"name":"BridgeFastBurn".{0,700}' | head -1)"
if ! printf '%s' "$slow" | grep -q '"severity":"ticket"'; then
  echo "FAIL: BridgeSlowBurn needs the label severity: ticket"
  fail=1
fi
if ! printf '%s' "$fast" | grep -q '"severity":"page"'; then
  echo "FAIL: BridgeFastBurn needs the label severity: page"
  fail=1
fi
for rule in "$slow" "$fast"; do
  if ! printf '%s' "$rule" | grep -q '"summary":"[^"]'; then
    echo "FAIL: each alert needs a summary annotation with a text"
    fail=1
    break
  fi
  if ! printf '%s' "$rule" | grep -q 'http_requests_total'; then
    echo "FAIL: each alert must use http_requests_total"
    fail=1
    break
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: Prometheus has loaded BridgeSlowBurn and BridgeFastBurn with severity labels and a summary"
fi
exit "$fail"
