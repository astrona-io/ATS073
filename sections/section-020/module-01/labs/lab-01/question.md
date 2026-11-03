# Question

Solve this question on: `terminal`

The service `scout` in `starfleet` sends spans to the Collector `otel-collector` in `observability`. Its instrumentation still uses older attribute names, and one attribute carries a personal value. A dashboard team needs the current semantic convention names and the security team does not allow the personal value to leave the Collector.

Change only the Collector. Do not change the generator `scout-load`.

1. Make every span carry `http.request.method` with the value `GET` (a string) and `http.response.status_code` with the value `200` (an integer), copied from `http.method` and `http.status_code`.
2. Remove `http.method` and `http.status_code` from the spans, so that each fact has one name.
3. Remove the span attribute `user.email`.
4. Keep the resource attribute `service.name` with the value `scout`.
5. Add the new processor to the `traces` pipeline, restart the Collector, and check the `debug` exporter output of the new pod.

The configuration is the key `collector.yaml` of the ConfigMap `otel-collector-config` in the namespace `observability`. `kubectl` already points at the cluster.
