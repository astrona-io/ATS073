#!/usr/bin/env bash
# Check: service.name stays scout and the generator is unchanged
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1 2>/dev/null)"
# Count the attribute lines that sit inside blocks of one signal. Blocks start
# with ResourceSpans, ResourceMetrics or ResourceLog at the start of a line.
count_in_signal() {
  printf '%s\n' "$collector_logs" | awk -v header="$1" -v needle="$2" '
    /^Resource(Spans|Metrics|Logs?) / { current = ($0 ~ header) }
    current && index($0, needle) { n++ }
    END { print n + 0 }'
}

n="$(count_in_signal ResourceSpans 'service.name: Str(scout)')"
if [ "$n" -lt 1 ]; then
  echo "FAIL: spans no longer carry service.name scout"
  fail=1
fi
for deployment in scout-load; do
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
  echo "PASS: the resource identity and the generator are unchanged"
fi
exit "$fail"
