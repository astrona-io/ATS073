#!/usr/bin/env bash
# Check: the traces pipeline lists the transform processor
set -uo pipefail

fail=0
config="$(kubectl -n observability get configmap otel-collector-config -o jsonpath='{.data.collector\.yaml}' 2>/dev/null)"
flat="$(printf '%s' "$config" | tr -d ' \n')"
if ! printf '%s' "$flat" | grep -Eq 'traces:receivers:\[[^]]*\],processors:\[[^]]*transform[^]]*\]'; then
  echo "FAIL: the traces pipeline does not list the transform processor (flow style, order receivers, processors, exporters)"
  fail=1
fi
if ! printf '%s' "$flat" | grep -q 'replace_pattern('; then
  echo "FAIL: no replace_pattern statement is defined"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the transform processor is configured"
fi
exit "$fail"
