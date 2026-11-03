# Question

Solve this question on: `terminal`

The service `bridge` in `starfleet` sends traces, metrics and logs to the OpenTelemetry Collector `otel-collector` in `observability`. The Collector has only a traces pipeline, so the metrics and logs of `bridge` are never processed and never reach the `debug` exporter. The telemetry that does arrive has no deployment environment.

Fix the Collector and do not change the load generator `bridge-load`.

1. Add a `metrics` pipeline and a `logs` pipeline. Each receives from the `otlp` receiver and exports to the `debug` exporter.
2. Add a `resource` processor that sets the resource attribute `deployment.environment.name` to `production` and the resource attribute `service.namespace` to `starfleet`, with the action `upsert`. List the processor in all three pipelines.
3. Write each pipeline in the order `receivers`, `processors`, `exporters`, and write each list in flow style, for example `processors: [resource]`.
4. Restart the Collector so that it reads the new configuration. The `debug` exporter output of the new pod must show all three signals, each with the two new resource attributes and with the `service.name` `bridge`.

The configuration is the key `collector.yaml` of the ConfigMap `otel-collector-config` in the namespace `observability`. `kubectl` already points at the cluster.
