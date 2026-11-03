# Overview: Metrics, Logs, Events And Profiles In Depth (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with a Collector and load generators, and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it.
- The Collector in `observability`: Deployment and Service `otel-collector` (OTLP over gRPC on 4317 and over HTTP on 4318). Its pipelines `traces`, `metrics` and `logs` send to the `debug` exporter with verbosity `detailed`.
- The Deployment `shuttle-load` in `starfleet` with these containers: `logs-info` (Info, number 9), `logs-debug` (Debug, number 5), `logs-error` (Error, number 17), `metrics-sum` (a sum), `metrics-gauge` (a gauge named `fuel.level`) and `traces`.

## Read the telemetry

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1
```

## Practice tasks

- Find the data point kind, the temporality and the monotonic flag of the sum.
- Match each severity text to its severity number and to the table of levels.
- Add a `filter` processor to the `logs` pipeline that drops records below Warn (`SEVERITY_NUMBER_WARN`), restart the Collector and see which texts remain.
- Add a second filter in the `metrics` pipeline that drops the metric named `fuel.level`, using the condition `metric.name == "fuel.level"` under `metrics` and `metric`.
- Change the order of two processors in a pipeline and decide whether the output can change.