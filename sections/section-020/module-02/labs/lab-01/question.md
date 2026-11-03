# Question

Solve this question on: `terminal`

The service `harbor` in `starfleet` sends database spans to the Collector `otel-collector` in `observability`. Its instrumentation uses older attribute names, and the query text contains the literal value of an id. The dashboard team needs the current database convention names. The security team does not allow literal query values to leave the Collector.

Change only the Collector. Do not change the generator `harbor-db-load`.

1. Add a `transform` processor that works on spans. Copy `db.system` to `db.system.name`, `db.name` to `db.namespace` and `db.statement` to `db.query.text`.
2. Sanitize `db.query.text`: replace the number after `= ` with `?`, so that `SELECT * FROM orders WHERE id = 42` becomes `SELECT * FROM orders WHERE id = ?`.
3. Delete the old attributes `db.system`, `db.name` and `db.statement` after the copies, so that each fact has one name.
4. Keep the resource attribute `service.name` with the value `harbor`.
5. Add the processor to the `traces` pipeline in flow style, restart the Collector and check the `debug` exporter output of the new pod.

The configuration is the key `collector.yaml` of the ConfigMap `otel-collector-config` in the namespace `observability`. `kubectl` already points at the cluster.
