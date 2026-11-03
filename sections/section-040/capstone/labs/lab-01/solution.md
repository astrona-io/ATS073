# Solution

A target that Prometheus cannot reach reports `up` as 0 and produces no series. The fix is in the scrape configuration. The histogram buckets are cumulative, so the bucket `le="0.3"` already counts every request up to 0.3 seconds.

## Step 1: find the cause

```sh
kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/targets'
```

The target of the job `scout` is down and shows a connection error. Its address ends in port 9090, but the Service `scout-metrics` listens on 8080.

## Step 2: fix the scrape job

Save this as `prometheus-config.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: observability
data:
  prometheus.yml: |
    global:
      scrape_interval: 5s
    scrape_configs:
      - job_name: bridge
        static_configs:
          - targets: ['bridge-metrics.observability:8080']
      - job_name: scout
        static_configs:
          - targets: ['scout-metrics.observability:8080']
      - job_name: probe
        static_configs:
          - targets: ['probe-metrics.observability:8080']
```

```sh
kubectl apply -f prometheus-config.yaml
kubectl -n observability rollout restart deployment/prometheus
kubectl -n observability rollout status deployment/prometheus
```

Wait 15 seconds and check `up{job="scout"}`. The value is 1. The job `probe` stays at 0, because no `probe-metrics` Service exists.

## Step 3: compute the SLI

Query `http_request_duration_seconds_count{job="scout"}` (48000) and `http_request_duration_seconds_bucket{job="scout",le="0.3"}` (45360). The SLI is 45360 / 48000 * 100 = 94.50 percent. The target is 95 percent, so the objective is not met.

## Step 4: record the report

Save this as `latency-report.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: latency-report
  namespace: starfleet
data:
  requests_total: "48000"
  under_300ms: "45360"
  latency_sli: "94.50"
  slo_target: "95"
  slo_met: "no"
  probe_status: "no-data"
```

```sh
kubectl apply -f latency-report.yaml
```

`probe_status` is `no-data`. A query for a series that Prometheus never received returns an empty result, which is different from a series with the value 0.

Submit with `astrona submit`.
