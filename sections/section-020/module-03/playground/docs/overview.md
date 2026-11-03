# Overview: Resource Detection, Schema URLs And Stability (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with a Collector and one trace generator, and then waits. There is no task, no `astrona submit` and no pass or fail.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it.
- The Collector in `observability`: Deployment and Service `otel-collector`. The traces pipeline sends to the `debug` exporter with verbosity `detailed`. The container has the variable `OTEL_RESOURCE_ATTRIBUTES=deployment.environment.name=playground`.
- The Deployment `shuttle-load` in `starfleet`, a `telemetrygen` container that sends traces for the service `shuttle`.

## Read the telemetry

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1
```

## Practice tasks

- Add the `resourcedetection` processor with the detectors `env` and `system` to the traces pipeline and find the new resource attributes.
- Set `override: true` and add `service.name=detected` to `OTEL_RESOURCE_ATTRIBUTES` with `kubectl -n observability set env deployment/otel-collector OTEL_RESOURCE_ATTRIBUTES=service.name=detected`. Observe which service name wins, then set `override: false` and compare.
- Find the schema URL lines in the output and note which are empty.
- Add the `docker` detector to the list and read the Collector log for an error.