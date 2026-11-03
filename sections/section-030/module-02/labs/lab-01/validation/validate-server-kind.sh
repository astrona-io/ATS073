#!/usr/bin/env bash
# Check: process-order spans have the kind Server
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=300s --tail=-1 2>/dev/null)"
# Per span: read the name, the kind and the status, then count when the span ends.
count_spans() {
  printf '%s\n' "$collector_logs" | awk -v want_kind="$1" '
    function flush() { if (name == "process-order" && kind == want_kind) n++ }
    /Span #[0-9]+/ { flush(); name = ""; kind = "" }
    /^ *Name *: / { name = $NF }
    /^ *Kind *: / { kind = $NF }
    END { flush(); print n + 0 }'
}

total="$(printf '%s\n' "$collector_logs" | grep -c 'Span #')"
if [ "$total" -lt 1 ]; then
  echo "FAIL: no spans in the last 300 seconds (a new pod needs about a minute after the change)"
  exit 1
fi
if [ "$(count_spans Server)" -lt 1 ]; then
  echo "FAIL: no process-order span has the kind Server"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: process-order spans are server spans"
fi
exit "$fail"
