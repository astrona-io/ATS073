# Overview: Zero-Code Instrumentation, Propagators And Baggage (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with a Collector and two instrumented services, and then waits. There is no task, no `astrona submit` and no pass or fail. The pods install their Python packages when they start, so they need about a minute to be ready.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it.
- The Collector in `observability` with a traces pipeline to the `debug` exporter with verbosity `detailed`.
- The Deployment `shuttle-billing` in `starfleet`: a Flask server on port 8080 behind the Service `shuttle-billing`. It copies the baggage key `customer.tier` to a span attribute.
- The Deployment `shuttle-client`: a loop that calls the server every second and sets the baggage `customer.tier=gold`.
- Both run under `opentelemetry-instrument` with `OTEL_PROPAGATORS=tracecontext,baggage`.

## Read the spans

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1 | grep -E 'Trace ID|Parent ID|Kind|customer.tier'
```

## Practice tasks

- Set `OTEL_PROPAGATORS=none` on the server with `kubectl -n starfleet set env deployment/shuttle-billing OTEL_PROPAGATORS=none` and compare the parent IDs of the server spans.
- Set the server to `tracecontext` only and find the value of `customer.tier`.
- Set `OTEL_TRACES_SAMPLER=parentbased_traceidratio` and `OTEL_TRACES_SAMPLER_ARG=0.5` on the client and compare the number of spans.
- Set `OTEL_PROPAGATORS=b3` on the client only and observe the result on the server.