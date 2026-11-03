#!/usr/bin/env bash
# Check: the shuttle ratio is the requests within 0.3 seconds divided by all requests
set -uo pipefail

query_value() {
  kubectl -n observability exec deploy/prometheus -- wget -qO- "http://localhost:9090/api/v1/query?query=$1" 2>/dev/null \
    | sed -n 's/.*"value":\[[^,]*,"\([^"]*\)".*/\1/p'
}

value="$(query_value 'shuttle:http_request_duration_seconds:under_300ms_ratio')"
if [ -z "$value" ]; then
  echo "FAIL: the query shuttle:http_request_duration_seconds:under_300ms_ratio returns no value (the rule may be missing or not evaluated yet)"
  exit 1
fi
if awk -v v="$value" -v e="0.92" 'BEGIN { d = v - e; if (d < 0) d = -d; exit !(d <= 0.0001) }'; then
  echo "PASS: shuttle:http_request_duration_seconds:under_300ms_ratio is $value"
  exit 0
fi
echo "FAIL: shuttle:http_request_duration_seconds:under_300ms_ratio is $value, expected about 0.92"
exit 1
