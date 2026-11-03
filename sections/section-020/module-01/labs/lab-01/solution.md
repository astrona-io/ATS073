# Solution

The `attributes` processor changes the attributes of spans, log records and metric data points. It runs its actions in the order of the list. A rename is two actions: copy the value to the new key with `upsert` and `from_attribute`, then delete the old key.

## Step 1: look at the spans

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1
```

Each span lists `http.method`, `http.status_code` and `user.email` under `Attributes:`.

## Step 2: replace the configuration

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
      attributes/semconv:
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
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [attributes/semconv]
          exporters: [debug]
```

Apply it and restart:

```sh
kubectl apply -f collector-config.yaml
kubectl -n observability rollout restart deployment/otel-collector
kubectl -n observability rollout status deployment/otel-collector
```

## Step 3: check the result

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1
```

Each span now shows `http.request.method: Str(GET)` and `http.response.status_code: Int(200)`. The old keys and `user.email` are gone. `service.name` is still `scout`, because the processor changes span attributes and not resource attributes.

Submit with `astrona submit`. If a check reports no spans, wait 30 seconds and submit again.
