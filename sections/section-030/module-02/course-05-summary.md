---
draft: true
exam_objectives:
  - Instrumentation
---
# Summary

Code that creates telemetry calls the OpenTelemetry API. It gets a tracer or a meter from the global provider by name and version, and the pair is the instrumentation scope, which names the code that produced the data and is separate from the service. The SDK turns the calls into data. Without an SDK the API is a no-op and produces nothing, and no error says so.

A span starts with `start_as_current_span`, ends with the block, and becomes the parent of spans started inside it. Its name has low cardinality, the changing values are attributes, and the kind states the role of the operation. Attributes that a sampler needs go into the call that starts the span. An event records a moment inside a span. `record_exception` adds the exception as an event, and `set_status` marks the span as failed. An exception caught inside the block hides from the context manager, so the code must record it and set the status.

A Counter counts events, an UpDownCounter follows a value that moves both ways, a Histogram records a distribution and a Gauge records a value at a moment. Asynchronous instruments report a value that a callback reads. Instruments are created once. Attributes on measurements have a small, bounded set of values, and durations use seconds.

Key facts:

- A span that never ends is never exported.
- The status is `UNSET` for success, `ERROR` for failure, and `OK` only by decision.
- An unbounded attribute on a metric creates unbounded series.
- The scope and the service are different identities.

<!-- astrona:playground:destroy -->
