# Overview: RED, USE And The Four Golden Signals (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with Prometheus and a fixed set of request counters, and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it.
- Prometheus in `observability`: Deployment and Service `prometheus` on port 9090, configuration in the ConfigMap `prometheus-config`. It scrapes the jobs `bridge` and `shuttle` every 5 seconds.
- The Deployment `bridge-metrics`, nginx serving a fixed text file at `/metrics` from the ConfigMap `bridge-metrics-data`. The values never change, so `rate()` of these counters is 0. Use the raw counters and the `sum` function.
- The series of `bridge`: `http_requests_total{service,route,code}` for the routes `/orders` and `/status`, and the gauge `bridge_worker_utilization_ratio`.
- The series of `shuttle`: the histogram `http_request_duration_seconds` with the buckets `le` 0.1, 0.3, 0.5, 1 and `+Inf`.

## Query Prometheus

```sh
kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/query?query=up'
```

Replace the query with any expression. Characters such as quotes and braces must be URL encoded, for example `%7B` for `{`, `%7D` for `}` and `%22` for a double quote. To avoid this, run `kubectl -n observability port-forward svc/prometheus 9090:9090` in one terminal and open `http://127.0.0.1:9090` in a browser.

## Practice tasks

- Compute the RED measurements of `bridge` from the counters: the total, the `5xx` count and the error ratio.
- Compute the share of `shuttle` requests within 0.3 seconds, and the share within 0.1 seconds.
- Fill in the USE checklist for the worker pool of `bridge`: mark which of the three measurements exist and which are missing.
- Query `rate(http_requests_total[1m])` and explain why the result is 0 here.
- Add `rule_files` and a `rules.yml` key to the ConfigMap `prometheus-config`, restart Prometheus with `kubectl -n observability rollout restart deployment/prometheus`, and query your recording rule.
- Open `/api/v1/rules` and find the evaluation time and the health of each rule. Then write a rule with an error in its expression and read the health field again.
