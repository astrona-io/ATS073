# Solution

A head sampler decides when a trace starts, before the outcome is known, so it drops failed traces at the same rate as successful ones. A tail sampler decides after it has collected the spans of a trace, so a policy on the status code can keep every trace with an error. The Collector reads its configuration once at start, so the fix is a changed ConfigMap and a restart.

## Step 1: read the current configuration

```sh
kubectl -n observability get configmap otel-collector-config -o jsonpath='{.data.collector\.yaml}'
```

You see the processor `probabilistic_sampler` with `sampling_percentage: 10` in the `traces` pipeline.

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
    processors:
      tail_sampling:
        decision_wait: 5s
        policies:
          - name: keep-errors
            type: status_code
            status_code:
              status_codes: [ERROR]
          - name: sample-the-rest
            type: probabilistic
            probabilistic:
              sampling_percentage: 10
    exporters:
      debug:
        verbosity: detailed
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [tail_sampling]
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

Wait 60 seconds, then count the spans of each status:

```sh
kubectl -n observability logs deploy/otel-collector --since=60s --tail=-1 | grep -c 'Status code *: Error'
kubectl -n observability logs deploy/otel-collector --since=60s --tail=-1 | grep -c 'Status code *: Ok'
```

The error count is now close to one span per second, and the `Ok` count is far below the rate that the generator sends. Submit the lab with `astrona submit`. If one check fails, wait 60 seconds and submit again, because the checks read the last 120 seconds of output.
