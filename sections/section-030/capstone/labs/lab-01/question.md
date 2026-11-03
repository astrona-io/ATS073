# Question

Solve this question on: `terminal`

Three programs in `starfleet` run the same instrumented code under `opentelemetry-instrument`: `scout-api`, `scout-worker` and `probe-batch`. Each should send spans to the Collector `otel-collector` in `observability` under its own service name, with the resource attribute `deployment.environment.name=production`. None of them does, and each has a different cause.

Fix the environment of the three Deployments. Do not edit the code, the images or the Collector.

1. `scout-api` must send spans with the service name `scout-api`.
2. `scout-worker` must send spans with the service name `scout-worker`.
3. `probe-batch` must send spans with the service name `probe-batch`, and the SDK must record every trace.
4. All three must set the resource attribute `deployment.environment.name=production`.
5. Wait for the new pods (each needs about one minute to install its packages) and check the Collector output.
6. Record the cause for each program in a ConfigMap `instrumentation-review` in `starfleet`. Use one key per Deployment and one of these values: `wrong-endpoint-port`, `sdk-disabled` or `sampler-always-off`.

`kubectl` already points at the cluster.
