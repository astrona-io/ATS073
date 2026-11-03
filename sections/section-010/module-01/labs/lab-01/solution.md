# Solution

The Collector only runs the pipelines that its configuration lists. A signal without a pipeline is accepted by the `otlp` receiver and then dropped, because no pipeline forwards it. The fix has three parts: define the pipelines, add the processor and restart the pod, because the Collector reads its configuration once at start.

## Step 1: read the current configuration

```sh
kubectl -n observability get configmap otel-collector-config -o jsonpath='{.data.collector\.yaml}'
```

You see one pipeline, `traces`, with an empty `processors` list.

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
      resource:
        attributes:
          - key: deployment.environment.name
            value: production
            action: upsert
          - key: service.namespace
            value: starfleet
            action: upsert
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [resource]
          exporters: [debug]
        metrics:
          receivers: [otlp]
          processors: [resource]
          exporters: [debug]
        logs:
          receivers: [otlp]
          processors: [resource]
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

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1
```

Each `ResourceSpans`, `ResourceMetrics` and `ResourceLog` block now lists `deployment.environment.name`, `service.namespace` and `service.name` under `Resource attributes:`. Submit the lab with `astrona submit`. If one check fails, wait 30 seconds and submit again, because the checks read the last 120 seconds of output.
