#!/usr/bin/env bash
# Check: the review record is complete
set -uo pipefail

fail=0
get_key() { kubectl -n starfleet get configmap semconv-review -o "jsonpath={.data.$1}" 2>/dev/null; }
if ! kubectl -n starfleet get configmap semconv-review >/dev/null 2>&1; then
  echo "FAIL: ConfigMap semconv-review does not exist in starfleet"
  exit 1
fi
renamed="$(get_key renamed)"
for needle in http.method http.request.method http.status_code http.response.status_code; do
  case "$renamed" in
    *"$needle"*) ;;
    *) echo "FAIL: key renamed must mention $needle"; fail=1 ;;
  esac
done
removed="$(get_key removed)"
for needle in user.email customer.id; do
  case "$removed" in
    *"$needle"*) ;;
    *) echo "FAIL: key removed must mention $needle"; fail=1 ;;
  esac
done
if [ "$(get_key resource-attribute)" != "deployment.environment.name" ]; then
  echo "FAIL: key resource-attribute must be deployment.environment.name"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the review record is complete"
fi
exit "$fail"
