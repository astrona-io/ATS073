---
draft: true
exam_objectives:
  - Telemetry Data
---
# Head Sampling And Tail Sampling

A busy service can create thousands of traces per second. Storing all of them costs money, and most of them look the same. Sampling keeps a part of the traces and drops the rest. This part explains the two places where the decision can be made, what each one can and cannot know, and how to configure a tail sampler in an OpenTelemetry Collector.

## Why sampling is needed

Every span costs CPU in the program, network bandwidth, Collector memory and storage in the backend. Sampling lowers all four costs. It also lowers the amount of evidence, so the goal is to drop the traces that nobody will read and keep the ones that someone will. Traces of fast, successful requests are the ones that are safest to drop. Traces of failed or slow requests are the ones to keep.

## Head sampling

**Head sampling** decides at the start of a trace, when the root span is created. At that moment the program does not yet know how long the request will take or whether it will fail. The decision can use only what is known at the start: the trace ID, the span name and the attributes that were set when the span began.

The SDK makes this decision with a **sampler**. The samplers defined by the specification are `always_on`, `always_off`, `traceidratio` and the `parentbased_` versions of them. A ratio sampler turns the trace ID into a number and keeps the trace when the number is below the ratio. Because the number comes from the trace ID, every service that uses the same ratio makes the same decision for the same trace. A parent-based sampler follows the sampled flag of the parent when there is one, so a trace is kept or dropped as a whole.

Head sampling is cheap, because a dropped trace never leaves the program. Its weakness is that it is blind: a ratio of 10 percent drops 90 percent of the failed traces as well.

## Tail sampling

**Tail sampling** decides after the spans of a trace have been collected. It can read the whole trace, so it can keep every trace that contains an error, every trace slower than a limit, or every trace that touches a chosen service. The `tail_sampling` processor of the Collector contrib distribution does this.

The processor works in four steps. It receives spans and groups them by trace ID. It waits for `decision_wait` after the first span of a trace arrives. It evaluates the policies against the spans collected so far. It then forwards the whole trace or drops it. When several policies are configured, the trace is kept when any policy says to keep it.

A configuration that keeps every trace with an error and 10 percent of the other traces looks like this:

```yaml
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
```

Tail sampling has two costs. It holds every span in memory until the decision, so memory grows with the span rate and `decision_wait`. It also needs all spans of one trace in the same Collector instance. When several Collector replicas receive the spans of one trace, each replica sees only a part and decides on it alone. The usual fix is a first tier that routes spans by trace ID to a second tier that does the sampling, which the `loadbalancing` exporter supports.

## Compare the two in the playground

<!-- astrona:playground:renew -->

First measure the share of error spans without sampling. The playground Collector has no sampler, so count the spans of each status for 60 seconds:

```sh
kubectl -n observability logs deploy/otel-collector --since=60s --tail=-1 | grep -c 'Status code *: Error'
kubectl -n observability logs deploy/otel-collector --since=60s --tail=-1 | grep -c 'Status code *: Ok'
```

Save this as `collector-head-sampling.yaml`. It adds a head sampler that keeps 20 percent of the traces:

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
      probabilistic_sampler:
        sampling_percentage: 20
    exporters:
      debug:
        verbosity: detailed
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [probabilistic_sampler]
          exporters: [debug]
```

Apply it and restart the Collector:

```sh
kubectl apply -f collector-head-sampling.yaml
kubectl -n observability rollout restart deployment/otel-collector
kubectl -n observability rollout status deployment/otel-collector
```

Wait 60 seconds and count again with the same two commands. The error count falls together with the success count, because the sampler does not look at the status. Now replace the processor. Save this as `collector-tail-sampling.yaml`:

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

Apply it, restart and wait for 60 seconds:

```sh
kubectl apply -f collector-tail-sampling.yaml
kubectl -n observability rollout restart deployment/otel-collector
kubectl -n observability rollout status deployment/otel-collector
```

Count again. The error spans of `shuttle` now appear at close to the full rate of 1 per second, while the success spans are reduced. The metrics and logs pipelines are gone in this file, so the Collector processes only traces. Restore them later by adding the two pipelines again.

## What to take from this

Head sampling decides early and cheaply but without knowledge of the outcome. Tail sampling decides late with the whole trace in view, at the price of memory and the need to collect every span of a trace in one place. A policy that keeps errors protects the evidence that matters most, and the share of kept traces then no longer equals the share of real traffic. The next part explains what a reader can still conclude from sampled traces.

## Common pitfalls

> [!WARNING]
> Do not put a head sampler in front of a tail sampler and expect all errors to survive, because the head sampler drops them first. Do not run the `tail_sampling` processor in several Collector replicas that receive different spans of the same trace. Do not read the share of errors in kept traces as the real error rate when the policy keeps all errors.
