#!/usr/bin/env bash
# Check: the fixed metric files and the scrape jobs are unchanged
set -uo pipefail

fail=0
bridge="$(kubectl -n observability get configmap bridge-metrics-data -o jsonpath='{.data.metrics}' 2>/dev/null)"
shuttle="$(kubectl -n observability get configmap shuttle-metrics-data -o jsonpath='{.data.metrics}' 2>/dev/null)"
if ! printf '%s' "$bridge" | grep -q 'route="/orders",code="200"} 91200' || ! printf '%s' "$bridge" | grep -q 'route="/status",code="503"} 40'; then
  echo "FAIL: the file in bridge-metrics-data was changed"
  fail=1
fi
if ! printf '%s' "$shuttle" | grep -q 'le="0.3"} 18400'; then
  echo "FAIL: the file in shuttle-metrics-data was changed"
  fail=1
fi
config="$(kubectl -n observability get configmap prometheus-config -o jsonpath='{.data.prometheus\.yml}' 2>/dev/null)"
for target in bridge-metrics.observability:8080 shuttle-metrics.observability:8080; do
  if ! printf '%s' "$config" | grep -q "$target"; then
    echo "FAIL: the scrape target $target was removed from prometheus.yml"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: the sources and the scrape jobs are unchanged"
fi
exit "$fail"
