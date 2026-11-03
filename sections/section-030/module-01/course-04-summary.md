---
draft: true
exam_objectives:
  - Instrumentation
---
# Summary

Program code calls the OpenTelemetry API to record spans, metrics and logs. The SDK implements the API and holds the resource, the sampler, the processors and the exporters. An exporter sends the data out, usually over OTLP to a Collector. Without an SDK, API calls do nothing, so libraries depend on the API only and the application owner decides where telemetry goes.

Manual instrumentation records what only the application knows, and automatic instrumentation wraps known libraries and gives breadth. In Python, the launcher `opentelemetry-instrument` builds the SDK from `OTEL_*` environment variables. `OTEL_SERVICE_NAME` and `OTEL_RESOURCE_ATTRIBUTES` identify the service. `OTEL_EXPORTER_OTLP_PROTOCOL` and `OTEL_EXPORTER_OTLP_ENDPOINT` choose the transport and the address, and they must agree: `http/protobuf` uses port 4318 and `grpc` uses port 4317. `OTEL_TRACES_SAMPLER` decides which traces are recorded, and `OTEL_SDK_DISABLED` turns everything off.

A wrong value in the environment fails without an error in the Collector. A sender that cannot connect writes the error to its own log, a missing service name produces the placeholder `unknown_service`, and a sampler that rejects every trace stops spans while metrics continue.

Good measurement design puts spans at operation boundaries and avoids duplicates between manual and automatic spans. It uses a counter for events and a histogram for durations, writes units in their own field and keeps names free of identifiers. It limits metric attributes to a small known set of values, puts unbounded values on spans and logs, and keeps sensitive values out of telemetry.

Key facts:

- The instrumentation scope name comes from the name that code gives its tracer or meter.
- A parent-based sampler follows the decision of the parent span for traces that arrive from another service.
- A metric keeps flowing when the trace sampler is `always_off`.
- A trace breaks into two when a service does not forward the `traceparent` header.

<!-- astrona:playground:destroy -->
