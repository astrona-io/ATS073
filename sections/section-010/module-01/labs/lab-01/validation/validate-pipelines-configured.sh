#!/usr/bin/env bash
# Check: traces, metrics and logs pipelines each list the resource processor
set -uo pipefail

fail=0
config="$(kubectl -n observability get configmap otel-collector-config -o jsonpath='{.data.collector\.yaml}' 2>/dev/null)"
flat="$(printf '%s' "$config" | tr -d ' \n')"
# True when pipeline $1 lists $2 inside its processors list (flow style).
pipeline_has_processor() {
  printf '%s' "$flat" | grep -Eq "$1:receivers:\[[^]]*\],processors:\[[^]]*$2[^]]*\]"
}

for signal in traces metrics logs; do
  if ! pipeline_has_processor "$signal" resource; then
    echo "FAIL: the $signal pipeline does not list the resource processor (flow style, order receivers, processors, exporters)"
    fail=1
  fi
done
if ! printf '%s' "$flat" | grep -q 'resource:attributes:'; then
  echo "FAIL: no resource processor with attributes is defined"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: all three pipelines use the resource processor"
fi
exit "$fail"
