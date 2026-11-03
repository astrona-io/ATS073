#!/usr/bin/env bash
# Check: a process-order span has the status Error and an exception event
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=300s --tail=-1 2>/dev/null)"
count_spans() {
  printf '%s\n' "$collector_logs" | awk -v mode="$1" '
    function flush() {
      if (name == "process-order") {
        if (mode == "error" && status == "Error") n++
        if (mode == "event" && has_event) n++
      }
    }
    /Span #[0-9]+/ { flush(); name = ""; status = ""; has_event = 0 }
    /^ *Name *: / { name = $NF }
    /^ *Status code *: / { status = $NF }
    /-> Name: exception/ { has_event = 1 }
    END { flush(); print n + 0 }'
}

total="$(printf '%s\n' "$collector_logs" | grep -c 'Span #')"
if [ "$total" -lt 1 ]; then
  echo "FAIL: no spans in the last 300 seconds (a new pod needs about a minute after the change)"
  exit 1
fi
if [ "$(count_spans error)" -lt 1 ]; then
  echo "FAIL: no process-order span has the status Error; set the status when the order is rejected (about one order in five is rejected, so wait and submit again)"
  fail=1
fi
if [ "$(count_spans event)" -lt 1 ]; then
  echo "FAIL: no process-order span has an exception event; record the exception on the span"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the failure is recorded on the process-order span"
fi
exit "$fail"
