#!/usr/bin/env bash
# Check: bridge:http_error_ratio:ratio is the 5xx requests divided by all requests
set -uo pipefail

query_value() {
  kubectl -n observability exec deploy/prometheus -- wget -qO- "http://localhost:9090/api/v1/query?query=$1" 2>/dev/null \
    | sed -n 's/.*"value":\[[^,]*,"\([^"]*\)".*/\1/p'
}

value="$(query_value 'bridge:http_error_ratio:ratio')"
if [ -z "$value" ]; then
  echo "FAIL: the query bridge:http_error_ratio:ratio returns no value (the rule may be missing or not evaluated yet)"
  exit 1
fi
if awk -v v="$value" -v e="0.004528" 'BEGIN { d = v - e; if (d < 0) d = -d; exit !(d <= 0.00001) }'; then
  echo "PASS: bridge:http_error_ratio:ratio is $value"
  exit 0
fi
echo "FAIL: bridge:http_error_ratio:ratio is $value, expected about 0.004528"
exit 1
