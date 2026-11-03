#!/usr/bin/env bash
# Check: db.query.text has the literal id replaced by a question mark
set -uo pipefail

fail=0
collector_logs="$(kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1 2>/dev/null)"
sanitized="$(printf '%s\n' "$collector_logs" | grep -c -- '-> db.query.text: Str(SELECT \* FROM orders WHERE id = ?)')"
literal="$(printf '%s\n' "$collector_logs" | grep -c -- 'id = 42')"

if [ "$sanitized" -lt 1 ]; then
  echo "FAIL: no span has db.query.text 'SELECT * FROM orders WHERE id = ?'"
  fail=1
fi
if [ "$literal" -gt 0 ]; then
  echo "FAIL: the literal value 'id = 42' still appears in the output"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the query text is sanitized"
fi
exit "$fail"
