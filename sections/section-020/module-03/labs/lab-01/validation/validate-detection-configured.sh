#!/usr/bin/env bash
# Check: the traces pipeline lists a resourcedetection processor with env, system and override false
set -uo pipefail

fail=0
config="$(kubectl -n observability get configmap otel-collector-config -o jsonpath='{.data.collector\.yaml}' 2>/dev/null)"
flat="$(printf '%s' "$config" | tr -d ' \n')"
if ! printf '%s' "$flat" | grep -q 'resourcedetection'; then
  echo "FAIL: no resourcedetection processor is defined"
  fail=1
fi
if ! printf '%s' "$flat" | grep -Eq 'detectors:\[(env,system|system,env)\]'; then
  echo "FAIL: the detectors must be env and system"
  fail=1
fi
if ! printf '%s' "$flat" | grep -q 'override:false'; then
  echo "FAIL: override must be false"
  fail=1
fi
if ! printf '%s' "$flat" | grep -Eq 'traces:receivers:\[otlp\],processors:\[[^]]*resourcedetection[^]]*\],exporters:\[debug\]'; then
  echo "FAIL: the traces pipeline must list resourcedetection between otlp and debug"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the traces pipeline lists a resourcedetection processor with env, system and override false"
fi
exit "$fail"
