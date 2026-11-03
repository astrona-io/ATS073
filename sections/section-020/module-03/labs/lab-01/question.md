# Question

Solve this question on: `terminal`

The Collector `otel-collector` in `observability` receives traces for the service `shuttle` from the Deployment `shuttle-load` in `starfleet`. The traces carry the service name and nothing about the host or the environment.

Change the ConfigMap `otel-collector-config` and the Deployment `otel-collector`:

1. Add a `resourcedetection` processor with the detectors `env` and `system`, and with `override: false`. Configure the `system` detector with `hostname_sources: ["os"]`.
2. List the processor in the `traces` pipeline. Write the processor list in flow style, for example `processors: [name]`.
3. Set the environment variable `OTEL_RESOURCE_ATTRIBUTES` on the Collector container to `deployment.environment.name=staging`.
4. Make the Collector read the new configuration and the variable.

Do not change the Deployment `shuttle-load`. Keep the `otlp` receiver and the `debug` exporter with verbosity `detailed`. `kubectl` already points at the cluster.
