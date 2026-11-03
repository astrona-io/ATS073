# Question

Solve this question on: `terminal`

The services `bridge` (traces, metrics and logs) and `probe` (traces) in `starfleet` send telemetry to the Collector `otel-collector` in `observability`. A review found that the Collector has no metrics pipeline, so the metrics of `bridge` have never been stored. The trace volume is also too high, and no telemetry carries its deployment environment.

Fix the Collector and record what you found. Do not change the load generators.

1. Add the missing `metrics` pipeline. Each pipeline receives from the `otlp` receiver and exports to the `debug` exporter.
2. Add a `resource` processor that upserts `deployment.environment.name` as `production` and `service.namespace` as `starfleet`. List it in all three pipelines.
3. Keep 25 percent of the traces with the `probabilistic_sampler` processor (`sampling_percentage: 25`). List it only in the `traces` pipeline, never in `metrics` or `logs`.
4. Write each pipeline in the order `receivers`, `processors`, `exporters` and each list in flow style, for example `processors: [probabilistic_sampler, resource]`.
5. Restart the Collector and check the `debug` exporter output of the new pod.
6. Record the evidence in a ConfigMap `telemetry-evidence` in `starfleet` with the keys `signals` (the three signals, comma separated), `missing-signal` (the signal that had no pipeline), `sampled-signal` (the signal you sample) and `sampling-percentage` (the percentage you configured).

`kubectl` already points at the cluster.
