#!/usr/bin/env bash
# Check: bridge:http_requests:total equals the sum of all bridge requests
set -uo pipefail

query_value() {
  kubectl -n observability exec deploy/prometheus -- wget -qO- "http://localhost:9090/api/v1/query?query=$1" 2>/dev/null \
    | sed -n 's/.*"value":\[[^,]*,"\([^"]*\)".*/\1/p'
}

value="$(query_value 'bridge:http_requests:total')"
if [ -z "$value" ]; then
  echo "FAIL: the query bridge:http_requests:total returns no value (the rule may be missing or not evaluated yet)"
  exit 1
fi
if awk -v v="$value" -v e="119240" 'BEGIN { d = v - e; if (d < 0) d = -d; exit !(d <= 0.5) }'; then
  echo "PASS: bridge:http_requests:total is $value"
  exit 0
fi
echo "FAIL: bridge:http_requests:total is $value, expected about 119240"
exit 1
