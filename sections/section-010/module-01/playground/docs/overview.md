# Overview: Telemetry Signals And Resource Identity (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with an OpenTelemetry Collector and two load generators, and then waits. There is no task, no `astrona submit` and no pass or fail. Read telemetry, change the Collector, read it again, `astrona destroy`, start over.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it.
- The Collector, in the namespace `observability`: Deployment and Service `otel-collector` (ports 4317 for OTLP over gRPC and 4318 for OTLP over HTTP). Its configuration is the ConfigMap `otel-collector-config`. It has a traces, a metrics and a logs pipeline. Every pipeline receives OTLP and sends to the `debug` exporter, which prints each item to the Collector log.
- Two load generators in `starfleet`, both running `telemetrygen`:

  | Deployment | Signals | Service name |
  | --- | --- | --- |
  | `bridge-load` | traces, metrics, logs (one container per signal) | `bridge` |
  | `probe-load` | traces | `probe` |

## Read the telemetry

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1
```

Look for the blocks that start with `ResourceSpans`, `ResourceMetrics` and `ResourceLog`. Under `Resource attributes:` each block names the service that sent the items.

## Practice tasks

- Find out which resource attributes `telemetrygen` sets by default and which one you can change with its `--service` argument.
- Edit the ConfigMap `otel-collector-config`, remove the `logs` pipeline, restart the Collector with `kubectl -n observability rollout restart deploy/otel-collector`, and check that the logs of `bridge` stop. Check that the `bridge-load` logs container keeps running. Decide what a reader of a dashboard would see.
- Add a `resource` processor that sets `deployment.environment.name` to `production`, add it to the `traces` pipeline only, restart, and compare a trace block with a metric block.
- Add the `probabilistic_sampler` processor with `sampling_percentage: 10` to the `traces` pipeline and compare how many `ResourceSpans` blocks of `bridge` and `probe` you see in 30 seconds before and after.
- Scale `probe-load` to zero and explain why the absence of `probe` blocks does not prove that no `probe` request happened.
