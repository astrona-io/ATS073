#!/usr/bin/env bash
# Check: the review record names the causes
set -uo pipefail

fail=0
get_key() { kubectl -n starfleet get configmap instrumentation-review -o "jsonpath={.data.$1}" 2>/dev/null; }
if ! kubectl -n starfleet get configmap instrumentation-review >/dev/null 2>&1; then
  echo "FAIL: ConfigMap instrumentation-review does not exist in starfleet"
  exit 1
fi
for pair in scout-api:wrong-endpoint-port scout-worker:sdk-disabled probe-batch:sampler-always-off; do
  key="${pair%%:*}"
  expected="${pair##*:}"
  if [ "$(get_key "$key")" != "$expected" ]; then
    echo "FAIL: key $key must be $expected"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: the review record is complete"
fi
exit "$fail"
