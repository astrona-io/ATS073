#!/usr/bin/env bash
# Check: the client and the server keep their images and the client keeps its propagators
set -uo pipefail

fail=0
for name in shuttle-billing shuttle-client; do
  image="$(kubectl -n starfleet get deployment "$name" -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
  if [ "$image" != "python:3.13-slim" ]; then
    echo "FAIL: $name must keep the image python:3.13-slim"
    fail=1
  fi
done
client="$(kubectl -n starfleet get deployment shuttle-client -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="OTEL_PROPAGATORS")].value}' 2>/dev/null)"
if [ "$client" != "tracecontext,baggage" ]; then
  echo "FAIL: the client must keep OTEL_PROPAGATORS=tracecontext,baggage"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the client and the server keep their images and the client keeps its propagators"
fi
exit "$fail"
