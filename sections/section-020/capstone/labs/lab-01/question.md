# Question

Solve this question on: `terminal`

Three services in `starfleet` send telemetry to the Collector `otel-collector` in `observability`: `scout` sends spans, `shuttle` sends logs and `probe` sends metrics. A review of the three signals found four problems. Fix them in the Collector. Do not change the generators.

1. Spans of `scout` use `http.method` and `http.status_code`. Rename them to `http.request.method` and `http.response.status_code`. The status code must stay an integer.
2. Spans of `scout` and log records of `shuttle` carry the personal attribute `user.email`. Remove it from both.
3. Metric data points of `probe` carry the attribute `customer.id`, a value that is different for every customer. Remove it from the metrics.
4. No signal says in which environment it ran. Set the resource attribute `deployment.environment.name` to `production` on all three signals, and keep each `service.name`.
5. Restart the Collector and check its `debug` exporter output.
6. Record your review in a ConfigMap `semconv-review` in `starfleet` with the keys `renamed` (each old and new name, for example `a=b,c=d`), `removed` (the removed attributes, comma separated) and `resource-attribute` (the attribute you set on the resource).

`kubectl` already points at the cluster.
