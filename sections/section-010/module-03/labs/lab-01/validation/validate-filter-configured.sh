#!/usr/bin/env bash
# Check: the logs pipeline lists a filter processor that tests the severity
set -uo pipefail

fail=0
config="$(kubectl -n observability get configmap otel-collector-config -o jsonpath='{.data.collector\.yaml}' 2>/dev/null)"
flat="$(printf '%s' "$config" | tr -d ' \n')"
if ! printf '%s' "$flat" | grep -Eq 'processors:.*filter(/[a-z0-9_-]+)?:'; then
  echo "FAIL: no filter processor is defined"
  fail=1
fi
if ! printf '%s' "$flat" | grep -q 'severity_number'; then
  echo "FAIL: the filter must test severity_number"
  fail=1
fi
if ! printf '%s' "$flat" | grep -Eq 'logs:receivers:\[otlp\],processors:\[[^]]*filter[^]]*\],exporters:\[debug\]'; then
  echo "FAIL: the logs pipeline must list the filter processor between otlp and debug"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the logs pipeline lists a filter processor that tests the severity"
fi
exit "$fail"
