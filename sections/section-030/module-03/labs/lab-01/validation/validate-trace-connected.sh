#!/usr/bin/env bash
# Check: a server span shares its trace ID with a client span and has a parent
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1 2>/dev/null)"
spans="$(printf '%s\n' "$collector_logs" | awk '
  function flush() { if (tid != "") print kind, tid, parent }
  /Span #[0-9]+/ { flush(); tid = ""; kind = ""; parent = "" }
  /^ *Trace ID *: / { tid = $NF }
  /^ *Parent ID *: / { parent = (NF >= 4) ? $NF : "" }
  /^ *Kind *: / { kind = $NF }
  END { flush() }')"
if [ "$(printf '%s\n' "$spans" | grep -c '^Server ')" -lt 1 ]; then
  echo "FAIL: no server spans in the last 120 seconds; the new pod needs about a minute, so wait and submit again"
  exit 1
fi
printf '%s\n' "$spans" | awk '$1 == "Client" { print $2 }' | sort -u > /tmp/validate-client-ids.$$
linked="$(printf '%s\n' "$spans" | awk '$1 == "Server" && $3 != "" { print $2 }' | grep -c -Fxf /tmp/validate-client-ids.$$)"
rm -f /tmp/validate-client-ids.$$
if [ "${linked:-0}" -lt 1 ]; then
  echo "FAIL: no server span has a parent and a trace ID that a client span shares"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: a server span shares its trace ID with a client span and has a parent"
fi
exit "$fail"
