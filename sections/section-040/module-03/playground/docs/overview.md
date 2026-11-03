# Overview: Alerting And Burn-Rate (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with Prometheus and two metric sources, and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it.
- Prometheus in `observability`: Deployment and Service `prometheus` on port 9090. The configuration is in the ConfigMap `prometheus-config`, with a scrape interval and an evaluation interval of 5 seconds, and no `rule_files`.
- The Deployment `bridge-metrics` with a fixed `http_requests_total` for the service `bridge`: 119240 requests, 540 of them with a 5xx code, and the gauge `bridge_worker_utilization_ratio`.
- The Deployment `shuttle-metrics` with a fixed histogram `http_request_duration_seconds`.

The counters never change, so every query returns the same values.

## Query Prometheus

```sh
kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/alerts'
```

## Practice tasks

- Add a rule file as the key `alerts.yml`, list it under `rule_files` and restart Prometheus with `kubectl -n observability rollout restart deployment/prometheus`.
- Write an alert with `for: 1m` and watch it stay pending before it fires.
- Add a template such as `{{ $value }}` to an annotation and read the result in `/api/v1/alerts`.
- Write an alert for the gauge `bridge_worker_utilization_ratio` above 0.9 and confirm that it does not fire.