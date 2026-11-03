# Overview: Indicators, Objectives And Dashboards (Playground)

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

- Query `sum(http_requests_total{route="/orders"})` and then `sum by (code) (http_requests_total{route="/orders"})`. Add up the codes by hand and compare.
- Define valid events as all `/orders` requests except `4xx` and good events as `2xx` and `3xx`. Write the PromQL for both and compute the SLI.
- Compute the error budget for an SLO of 99.5 percent and decide whether it is spent.
- Query `rate(http_requests_total[1m])` and explain why the result is 0 here and what a live service would show.
- Compute the share of `shuttle` requests that finished in 0.3 seconds or less from the bucket `le="0.3"` and the count.
- Query a series that does not exist, such as `http_requests_total{route="/billing"}`, and explain the difference between an empty result and a value of 0.
