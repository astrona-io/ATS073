# Solution

The `filter` processor drops every item for which a condition is true. A processor does nothing until a pipeline lists it, and the Collector reads its file only at start.

## Step 1: read the current configuration

```sh
kubectl -n observability get configmap otel-collector-config -o jsonpath='{.data.collector\.yaml}'
```

The `logs` pipeline has a receiver and an exporter, and no processors.

## Step 2: add the processor

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
    processors:
      filter/drop-debug:
        error_mode: ignore
        logs:
          log_record:
            - severity_number < SEVERITY_NUMBER_INFO
    exporters:
      debug:
        verbosity: detailed
    service:
      pipelines:
        traces:
          receivers: [otlp]
          exporters: [debug]
        logs:
          receivers: [otlp]
          processors: [filter/drop-debug]
          exporters: [debug]
```

Apply it:

```sh
kubectl apply -f collector-config.yaml
```

## Step 3: restart the Collector

```sh
kubectl -n observability rollout restart deployment/otel-collector
kubectl -n observability rollout status deployment/otel-collector
```

## Step 4: check the output

Wait about 30 seconds, then count the severity texts:

```sh
kubectl -n observability logs deploy/otel-collector --since=20s --tail=-1 | grep SeverityText | sort | uniq -c
```

Only the text Info remains. Submit the lab with `astrona submit`.
