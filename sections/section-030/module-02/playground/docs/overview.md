# Overview: Manual Instrumentation With The API (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with a Collector and one manually instrumented program, and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it. The cluster needs internet access, because a pod runs `pip install` when it starts.
- The Collector in `observability`: Deployment and Service `otel-collector` (OTLP over gRPC on 4317 and over HTTP on 4318). Its traces and metrics pipelines send to the `debug` exporter, which prints every item to the Collector log.
- The Deployment `shuttle-orders` in `starfleet`. Its program is the ConfigMap `orders-app` (`app.py`). The program calls the OpenTelemetry API. It starts a server span `process-order` with a child span `reserve-stock`, sets the attribute `order.items`, and rejects orders with more than four items. A rejected order records an `exception` event and sets the status to Error. It also adds to the counter `orders.processed`, changes the up-down counter `orders.in_progress`, and records the histogram `orders.duration` with the unit `s`.
- The program contains no code that sets up an SDK or an exporter. The launcher `opentelemetry-instrument` does that from environment variables: `OTEL_SERVICE_NAME`, `OTEL_RESOURCE_ATTRIBUTES`, `OTEL_EXPORTER_OTLP_PROTOCOL`, `OTEL_EXPORTER_OTLP_ENDPOINT` and `OTEL_METRIC_EXPORT_INTERVAL`.

## Read the telemetry

```sh
kubectl -n observability logs deploy/otel-collector --since=60s --tail=-1
```

The pod needs about one minute to install its packages before the first items appear. Look for the span names, the metric name and the resource attributes.

## Practice tasks

- Find the `Kind` of `process-order` and of `reserve-stock` in the Collector output and compare them.
- Find a span with the status `Error` and read its `exception` event: the attributes `exception.type`, `exception.message` and `exception.stacktrace`.
- Find the metric `orders.duration` and read its bucket counts. Compare the counts with the counter `orders.processed`.
- Edit the ConfigMap `orders-app`: change `time.sleep(0.05)` to `time.sleep(0.3)`, restart the Deployment with `kubectl -n starfleet rollout restart deployment/shuttle-orders` and watch the histogram buckets move.
- Change the rejection limit from `items > 4` to `items > 3` and compare how often the status Error appears.
