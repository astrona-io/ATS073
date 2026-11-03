#!/usr/bin/env bash
# Check: the receiver, the exporter and the traces pipeline are intact
set -uo pipefail

fail=0
config="$(kubectl -n observability get configmap otel-collector-config -o jsonpath='{.data.collector\.yaml}' 2>/dev/null)"
flat="$(printf '%s' "$config" | tr -d ' \n')"
if ! printf '%s' "$flat" | grep -q 'otlp:protocols:grpc:endpoint:0.0.0.0:4317'; then
  echo "FAIL: the otlp receiver on 0.0.0.0:4317 is missing"
  fail=1
fi
if ! printf '%s' "$flat" | grep -q 'debug:verbosity:detailed'; then
  echo "FAIL: the debug exporter with verbosity detailed is missing"
  fail=1
fi
if ! printf '%s' "$flat" | grep -Eq 'traces:receivers:\[otlp\],exporters:\[debug\]'; then
  echo "FAIL: the traces pipeline must receive from otlp and export to debug without processors"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the receiver, the exporter and the traces pipeline are intact"
fi
exit "$fail"
