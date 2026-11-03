#!/usr/bin/env bash
# Check: probabilistic_sampler at 25 percent in traces only
set -uo pipefail

fail=0
config="$(kubectl -n observability get configmap otel-collector-config -o jsonpath='{.data.collector\.yaml}' 2>/dev/null)"
flat="$(printf '%s' "$config" | tr -d ' \n')"
# True when pipeline $1 lists $2 inside its processors list (flow style).
pipeline_has_processor() {
  printf '%s' "$flat" | grep -Eq "$1:receivers:\[[^]]*\],processors:\[[^]]*$2[^]]*\]"
}

if ! printf '%s' "$flat" | grep -q 'probabilistic_sampler:sampling_percentage:25'; then
  echo "FAIL: probabilistic_sampler with sampling_percentage: 25 is not defined"
  fail=1
fi
if ! pipeline_has_processor traces probabilistic_sampler; then
  echo "FAIL: the traces pipeline does not list probabilistic_sampler"
  fail=1
fi
for signal in metrics logs; do
  if pipeline_has_processor "$signal" probabilistic_sampler; then
    echo "FAIL: the $signal pipeline lists probabilistic_sampler"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: only the traces pipeline samples, at 25 percent"
fi
exit "$fail"
