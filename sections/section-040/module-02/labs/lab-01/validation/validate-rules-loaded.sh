#!/usr/bin/env bash
# Check: Prometheus has loaded three recording rules with the required names
set -uo pipefail

fail=0
rules="$(kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/rules?type=record' 2>/dev/null || true)"
if ! printf '%s' "$rules" | grep -q '"type":"recording"'; then
  echo "FAIL: Prometheus has loaded no recording rule (list rule_files in prometheus.yml and restart Prometheus)"
  exit 1
fi
for name in bridge:http_requests:total bridge:http_error_ratio:ratio shuttle:http_request_duration_seconds:under_300ms_ratio; do
  if ! printf '%s' "$rules" | grep -q "\"name\":\"$name\""; then
    echo "FAIL: the recording rule $name is not loaded"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: the three recording rules are loaded"
fi
exit "$fail"
