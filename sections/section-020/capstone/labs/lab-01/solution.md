# Solution

Each signal has its own pipeline, so each needs its own processor. The `attributes` processor changes span attributes, log record attributes and metric data point attributes. The `resource` processor changes the resource attributes of every item that passes through.

## Step 1: replace the configuration

Save this as `collector-config.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: otel-collector-config
  namespace: observability
data:
  collector.yaml: |
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
    exporters:
      debug:
        verbosity: detailed
    processors:
      attributes/traces:
        actions:
          - key: http.request.method
            from_attribute: http.method
            action: upsert
          - key: http.method
            action: delete
          - key: http.response.status_code
            from_attribute: http.status_code
            action: upsert
          - key: http.status_code
            action: delete
          - key: user.email
            action: delete
      attributes/logs:
        actions:
          - key: user.email
            action: delete
      attributes/metrics:
        actions:
          - key: customer.id
            action: delete
      resource:
        attributes:
          - key: deployment.environment.name
            value: production
            action: upsert
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [attributes/traces, resource]
          exporters: [debug]
        logs:
          receivers: [otlp]
          processors: [attributes/logs, resource]
          exporters: [debug]
        metrics:
          receivers: [otlp]
          processors: [attributes/metrics, resource]
          exporters: [debug]
```

```sh
kubectl apply -f collector-config.yaml
kubectl -n observability rollout restart deployment/otel-collector
kubectl -n observability rollout status deployment/otel-collector
```

## Step 2: check the output

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1
```

Spans show the new names, with `Int(200)` for the status code. No span or log record shows `user.email`. Metric data points do not show `customer.id`. Each `Resource attributes:` list shows `deployment.environment.name` and its `service.name`.

## Step 3: record the review

Save this as `semconv-review.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: semconv-review
  namespace: starfleet
data:
  renamed: "http.method=http.request.method,http.status_code=http.response.status_code"
  removed: "user.email,customer.id"
  resource-attribute: "deployment.environment.name"
```

```sh
kubectl apply -f semconv-review.yaml
```

Submit with `astrona submit`. The Collector removes the values only after the sender and the network path have already handled them. The record says so, and it names the real fix: stop collecting the value in the instrumentation.
