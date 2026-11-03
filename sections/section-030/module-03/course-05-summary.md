---
draft: true
exam_objectives:
  - Instrumentation
---
# Summary

Zero-code instrumentation loads an agent or a wrapper at start and patches libraries, so spans for HTTP and database calls appear with no source change. The settings are environment variables such as `OTEL_SERVICE_NAME`, `OTEL_EXPORTER_OTLP_ENDPOINT` and `OTEL_PROPAGATORS`. In Kubernetes the OpenTelemetry Operator injects the agent when a pod has an inject annotation. An agent cannot create business spans.

A propagator injects context into outgoing requests and extracts it from incoming ones. The W3C `traceparent` header has a version, a trace ID, a parent span ID and flags. Both sides need a common format, and the default is `tracecontext,baggage`. Broken propagation gives a server span with no parent and a separate trace, without an error.

Baggage carries key-value pairs across services but does not appear in telemetry unless code copies it to an attribute. It must never hold secrets. Samplers decide at the root: `parentbased_traceidratio` keeps one decision for the whole trace, and tail sampling in a Collector can add decisions based on the result.

Key facts:

- A server span with no parent where a caller exists points to broken propagation.
- `OTEL_PROPAGATORS=none` stops propagation.
- Baggage is not a span attribute until it is copied.
- A parent-based sampler follows the sampled flag of the caller.

<!-- astrona:playground:destroy -->
