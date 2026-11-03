# Overview: API Calls And Automatic Instrumentation (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with a Collector and one instrumented program, and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it. The cluster needs internet access, because a pod runs `pip install` when it starts.
- The Collector in `observability`: Deployment and Service `otel-collector` (OTLP over gRPC on 4317 and over HTTP on 4318). Its traces and metrics pipelines send to the `debug` exporter, which prints every item to the Collector log.
- The Deployment `shuttle-orders` in `starfleet`. Its program is the ConfigMap `orders-app` (`app.py`). The program calls the OpenTelemetry API: it starts a span `process-order` with a child span `reserve-stock`, sets the span attribute `order.items`, and adds 1 to the counter `orders.processed` every second.
- The program contains no code that sets up an SDK or an exporter. The launcher `opentelemetry-instrument` does that from environment variables: `OTEL_SERVICE_NAME`, `OTEL_RESOURCE_ATTRIBUTES`, `OTEL_EXPORTER_OTLP_PROTOCOL`, `OTEL_EXPORTER_OTLP_ENDPOINT` and `OTEL_METRIC_EXPORT_INTERVAL`.

## Read the telemetry

```sh
kubectl -n observability logs deploy/otel-collector --since=60s --tail=-1
```

The pod needs about one minute to install its packages before the first items appear. Look for the span names, the metric name and the resource attributes.

## Practice tasks

- Print the environment of the pod with `kubectl -n starfleet get deployment shuttle-orders -o jsonpath='{.spec.template.spec.containers[0].env}'` and match each variable to a line of the Collector output.
- Change `OTEL_SERVICE_NAME` with `kubectl -n starfleet set env deployment/shuttle-orders OTEL_SERVICE_NAME=shuttle-billing` and find the new name in the output.
- Set `OTEL_TRACES_SAMPLER` to `always_off`, wait for the new pod and observe which signal stops and which continues.
- Set `OTEL_EXPORTER_OTLP_ENDPOINT` to the gRPC port 4317 while the protocol stays `http/protobuf`, and observe the Collector output.
- Set `OTEL_SDK_DISABLED` to `true` and decide what the program still does and what it no longer produces.
