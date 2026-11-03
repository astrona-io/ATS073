#!/usr/bin/env bash
# Check: the shuttle-load Deployment still has its two containers and its original image
set -uo pipefail

fail=0
images="$(kubectl -n starfleet get deployment shuttle-load -o jsonpath='{range .spec.template.spec.containers[*]}{.image}{"\n"}{end}' 2>/dev/null)"
names="$(kubectl -n starfleet get deployment shuttle-load -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{"\n"}{end}' 2>/dev/null)"
if [ "$(printf '%s\n' "$names" | grep -c .)" -ne 2 ]; then
  echo "FAIL: shuttle-load must keep exactly two containers"
  fail=1
fi
if printf '%s\n' "$images" | grep -qv 'telemetrygen:v0.162.0'; then
  echo "FAIL: a shuttle-load container has a changed image"
  fail=1
fi
if ! kubectl -n starfleet get deployment shuttle-load -o jsonpath='{.spec.template.spec.containers[*].args}' 2>/dev/null | grep -q 'Error'; then
  echo "FAIL: the traces-error container no longer sends the status code Error"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the generator is unchanged"
fi
exit "$fail"
