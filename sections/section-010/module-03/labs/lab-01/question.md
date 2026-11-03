# Question

Solve this question on: `terminal`

The Collector `otel-collector` in `observability` receives logs from the Deployment `shuttle-logs` in `starfleet`. Two sources write logs: one at the level Info with severity number 9 and one at the level Debug with severity number 5. The Collector passes both to its `debug` exporter, and the debug lines fill the log.

Change only the ConfigMap `otel-collector-config` and restart the Deployment `otel-collector`:

1. Add a `filter` processor that drops every log record with a severity number below 9 (the OTTL constant `SEVERITY_NUMBER_INFO`).
2. List the processor in the `logs` pipeline only. Write the processor list in flow style, for example `processors: [name]`.
3. Keep the `otlp` receiver, the `debug` exporter with verbosity `detailed` and the `traces` pipeline as they are.
4. Restart the Deployment `otel-collector` so that it reads the new configuration.

Do not change the Deployment `shuttle-logs`. `kubectl` already points at the cluster.
