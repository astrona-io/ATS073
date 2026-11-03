#!/usr/bin/env bash
# Check: the generators are unchanged
set -uo pipefail

fail=0
for deployment in scout-load shuttle-load probe-load; do
  images="$(kubectl -n starfleet get deployment "$deployment" -o jsonpath='{.spec.template.spec.containers[*].image}' 2>/dev/null)"
  if [ -z "$images" ]; then
    echo "FAIL: Deployment $deployment is missing"
    fail=1
  fi
  for image in $images; do
    if [ "$image" != "ghcr.io/open-telemetry/opentelemetry-collector-contrib/telemetrygen:v0.162.0" ]; then
      echo "FAIL: $deployment uses unexpected image $image"
      fail=1
    fi
  done
  args="$(kubectl -n starfleet get deployment "$deployment" -o jsonpath='{.spec.template.spec.containers[*].args}' 2>/dev/null)"
  case "$args" in
    *http.method*|*user.email*|*customer.id*|*http.status_code*) ;;
    *) echo "FAIL: $deployment no longer sends its original attributes"; fail=1 ;;
  esac
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: the generators are unchanged"
fi
exit "$fail"
