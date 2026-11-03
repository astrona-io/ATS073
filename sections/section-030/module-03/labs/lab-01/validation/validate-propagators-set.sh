#!/usr/bin/env bash
# Check: the server propagators include tracecontext and baggage
set -uo pipefail

fail=0
value="$(kubectl -n starfleet get deployment shuttle-billing -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="OTEL_PROPAGATORS")].value}' 2>/dev/null)"
case ",$value," in
  *,tracecontext,*) ;;
  *) echo "FAIL: OTEL_PROPAGATORS is '$value' and does not include tracecontext"; fail=1 ;;
esac
case ",$value," in
  *,baggage,*) ;;
  *) echo "FAIL: OTEL_PROPAGATORS is '$value' and does not include baggage"; fail=1 ;;
esac

if [ "$fail" -eq 0 ]; then
  echo "PASS: the server propagators include tracecontext and baggage"
fi
exit "$fail"
