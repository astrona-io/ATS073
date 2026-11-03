# Solution

Three things were wrong: a signal had no pipeline, nothing added resource identity, and nothing limited trace volume. Fix the Collector configuration first, and then write down what the fix changes.

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
      resource:
        attributes:
          - key: deployment.environment.name
            value: production
            action: upsert
          - key: service.namespace
            value: starfleet
            action: upsert
      probabilistic_sampler:
        sampling_percentage: 25
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [probabilistic_sampler, resource]
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

Apply it and restart the Collector:

```sh
kubectl apply -f collector-config.yaml
kubectl -n observability rollout restart deployment/otel-collector
kubectl -n observability rollout status deployment/otel-collector
```

The sampler sits before the `resource` processor in the traces pipeline. A processor runs in the order of the list, and dropping a trace early means the `resource` processor does no work for it.

## Step 2: check the output

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1
```

Look for `ResourceMetrics` blocks. They did not exist before. Every block lists `deployment.environment.name` and `service.namespace`. Compare the number of `ResourceSpans` blocks with the earlier run: the `probe` and `bridge` traces are sampled, while metrics and logs are not.

## Step 3: record the evidence

Save this as `telemetry-evidence.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: telemetry-evidence
  namespace: starfleet
data:
  signals: "traces,metrics,logs"
  missing-signal: "metrics"
  sampled-signal: "traces"
  sampling-percentage: "25"
```

```sh
kubectl apply -f telemetry-evidence.yaml
```

Submit the lab with `astrona submit`. The record states that the metrics were missing before this change and that only about a quarter of the traces are kept now. A reader of the data can use both facts when they interpret a gap or a count.
