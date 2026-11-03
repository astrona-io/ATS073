#!/usr/bin/env bash
# Check: the traces pipeline uses tail_sampling with an error policy and no head sampler
set -uo pipefail

fail=0
config="$(kubectl -n observability get configmap otel-collector-config -o jsonpath='{.data.collector\.yaml}' 2>/dev/null)"
flat="$(printf '%s' "$config" | tr -d ' \n')"

if ! printf '%s' "$flat" | grep -Eq 'traces:receivers:\[[^]]*\],processors:\[[^]]*tail_sampling[^]]*\]'; then
  echo "FAIL: the traces pipeline does not list the tail_sampling processor (flow style, order receivers, processors, exporters)"
  fail=1
fi
if printf '%s' "$flat" | grep -Eq 'traces:receivers:\[[^]]*\],processors:\[[^]]*probabilistic_sampler[^]]*\]'; then
  echo "FAIL: the traces pipeline still lists the probabilistic_sampler head sampler"
  fail=1
fi
if ! printf '%s' "$flat" | grep -q 'type:status_code'; then
  echo "FAIL: no policy of type status_code is defined"
  fail=1
fi
if ! printf '%s' "$flat" | grep -Eq 'status_codes:\[[^]]*ERROR[^]]*\]'; then
  echo "FAIL: the status_code policy does not list ERROR in status_codes"
  fail=1
fi
if ! printf '%s' "$flat" | grep -q 'type:probabilistic'; then
  echo "FAIL: no policy of type probabilistic is defined for the other traces"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: tail sampling is configured"
fi
exit "$fail"
