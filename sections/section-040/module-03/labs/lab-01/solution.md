# Solution

The error ratio is 540 / 119240, about 0.0045, so the burn rate is about 4.5. That is above 3 and below 14.4. The slow burn fires, and the fast burn stays inactive.

## Step 1: read the configuration

```sh
kubectl -n observability get configmap prometheus-config -o jsonpath='{.data.prometheus\.yml}'
```

The file has no `rule_files`.

## Step 2: write the rules and the reference

Save this as `prometheus-config.yaml` and keep the scrape jobs as they are:

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
      - /etc/prometheus/alerts.yml
    scrape_configs:
      - job_name: bridge
        static_configs:
          - targets: ['bridge-metrics.observability:8080']
      - job_name: shuttle
        static_configs:
          - targets: ['shuttle-metrics.observability:8080']
  alerts.yml: |
    groups:
      - name: bridge-error-budget
        rules:
          - alert: BridgeSlowBurn
            expr: sum(http_requests_total{service="bridge", code=~"5.."}) / sum(http_requests_total{service="bridge"}) > 3 * 0.001
            for: 10s
            labels:
              severity: ticket
            annotations:
              summary: "The bridge error budget burns more than 3 times faster than allowed"
          - alert: BridgeFastBurn
            expr: sum(http_requests_total{service="bridge", code=~"5.."}) / sum(http_requests_total{service="bridge"}) > 14.4 * 0.001
            for: 10s
            labels:
              severity: page
            annotations:
              summary: "The bridge error budget burns more than 14.4 times faster than allowed"
```

Apply it:

```sh
kubectl apply -f prometheus-config.yaml
```

## Step 3: restart Prometheus

Prometheus reads the rule files at start. The ConfigMap is mounted as a directory, so the new key appears in the pod:

```sh
kubectl -n observability rollout restart deployment/prometheus
kubectl -n observability rollout status deployment/prometheus --timeout=180s
```

## Step 4: check the rules and the alerts

Wait about 30 seconds, then:

```sh
kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/rules?type=alert'
kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/alerts'
```

Both rules are listed. The alerts list has `BridgeSlowBurn` with the state `firing`, and no entry for `BridgeFastBurn`. Submit the lab with `astrona submit`.
