# Overview: Semantic Conventions By Signal And Domain (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with an OpenTelemetry Collector and two generators, and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it.
- The Collector in `observability`: Deployment and Service `otel-collector`, configuration in the ConfigMap `otel-collector-config`. One traces pipeline sends to the `debug` exporter, which prints every span to the Collector log. The pipeline has no processors.
- The generator `scout-load` in `starfleet`, running `telemetrygen`. It sends spans for the service `scout` with these span attributes: `http.method` (`GET`), `http.status_code` (`200`) and `user.email`. The first two are older attribute names. The newer names are `http.request.method` and `http.response.status_code`.
- The generator `harbor-db-load` in `starfleet`, running `telemetrygen`. It sends spans for the service `harbor` with the older database attribute names `db.system` (`postgresql`), `db.name` (`orders`) and `db.statement` (`SELECT * FROM orders WHERE id = 42`). The newer names are `db.system.name`, `db.namespace` and `db.query.text`.

## Read the spans

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1
```

Under `Resource attributes:` you see `service.name`. Under `Attributes:` of each span you see the three attributes with their types, for example `Str(GET)` and `Int(200)`.

## Practice tasks

- Find the type of `http.status_code` in the output. Explain why a consumer that expects a string cannot compare it with `"200"`.
- Add an `attributes` processor that copies `http.method` to `http.request.method` with the action `upsert` and then deletes `http.method`. Add it to the pipeline, restart the Collector and read the output again.
- Move the delete action in front of the upsert action and restart. Observe what happens to the new attribute and explain the order rule.
- Delete `user.email` in the Collector, then explain why the sender and every component before the Collector still handled the value.
- Add a `resource` processor that sets `deployment.environment.name`, and decide whether `http.request.method` or `deployment.environment.name` belongs on the resource.
- Add a `transform` processor with OTTL statements that copy the three `db.*` attributes to the new names, replace the number in `db.query.text` with `?` and delete the old names. Compare the spans of `harbor` before and after.
- Add a `resource` processor that sets `k8s.cluster.name` and a custom attribute `starfleet.team`, and find both under `Resource attributes:`.
