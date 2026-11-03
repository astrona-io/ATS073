# Solution

A recording rule file does nothing until `rule_files` lists it. Prometheus reads the list at start, and this Prometheus runs without the flag `--web.enable-lifecycle`, so a restart of the Deployment loads the changed ConfigMap.

## Step 1: read the current configuration

```sh
kubectl -n observability get configmap prometheus-config -o jsonpath='{.data.prometheus\.yml}'
```

The output has the `global` block, with `evaluation_interval: 5s`, and the two scrape jobs, and no `rule_files`.

## Step 2: write the rules

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
      evaluation_interval: 5s
    rule_files:
      - /etc/prometheus/rules.yml
    scrape_configs:
      - job_name: bridge
        static_configs:
          - targets: ['bridge-metrics.observability:8080']
      - job_name: shuttle
        static_configs:
          - targets: ['shuttle-metrics.observability:8080']
  rules.yml: |
    groups:
      - name: starfleet-signals
        rules:
          - record: bridge:http_requests:total
            expr: sum(http_requests_total{service="bridge"})
          - record: bridge:http_error_ratio:ratio
            expr: sum(http_requests_total{service="bridge", code=~"5.."}) / sum(http_requests_total{service="bridge"})
          - record: shuttle:http_request_duration_seconds:under_300ms_ratio
            expr: sum(http_request_duration_seconds_bucket{service="shuttle", le="0.3"}) / sum(http_request_duration_seconds_count{service="shuttle"})
```

Apply it:

```sh
kubectl apply -f prometheus-config.yaml
```

## Step 3: restart Prometheus

```sh
kubectl -n observability rollout restart deployment/prometheus
kubectl -n observability rollout status deployment/prometheus
```

## Step 4: check the series

Wait about 15 seconds for a scrape and an evaluation. Then query the three names:

```sh
kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/query?query=bridge:http_error_ratio:ratio'
kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/rules'
```

The error ratio is about 0.004529 (540 of 119240 requests), the total is 119240, and the latency ratio is 0.92. If a query returns an empty result, read `/api/v1/rules` and check the field `health` of the rule. Submit the lab with `astrona submit`.
