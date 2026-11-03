# Overview: Traces In Depth (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with an OpenTelemetry Collector and three trace generators, and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it.
- The Collector in `observability`: Deployment and Service `otel-collector`. Its configuration is the ConfigMap `otel-collector-config`. It has a traces, a metrics and a logs pipeline, and every pipeline sends to the `debug` exporter, which prints each item to the Collector log.
- Three load generators in `starfleet`, all running `telemetrygen`:

  | Deployment | Container | What it sends |
  | --- | --- | --- |
  | `bridge-load` | traces, metrics, logs | three signals for the service `bridge` |
  | `probe-load` | traces | traces for the service `probe` |
  | `shuttle-load` | traces-ok | traces with two child spans and the status code `Ok`, 5 per second, service `shuttle` |
  | `shuttle-load` | traces-error | traces with the status code `Error`, 1 per second, service `shuttle` |

## Read the spans

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1
```

Each span block lists the trace ID, the parent span ID, the name, the kind, the start and end time, the status code and the attributes.

## Practice tasks

- Find one trace of `shuttle` with three spans. Compare the trace ID of the three spans and write down which span has an empty parent span ID.
- Compare the `Status code` of the spans of `shuttle` and count how many of 100 spans are errors.
- Add the `probabilistic_sampler` processor with `sampling_percentage: 20` to the traces pipeline. Count the error spans before and after, and decide whether the error rate you see still matches the real error rate.
- Replace it with the `tail_sampling` processor with a policy of type `status_code` and the status code `ERROR`. Decide what happens to traces without errors.
- Scale `shuttle-load` to zero and explain what the absence of spans proves and what it does not prove.
