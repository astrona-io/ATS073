---
draft: true
exam_objectives:
  - Telemetry Data
---
# Summary

A trace is a tree of spans that share one trace ID. Each span has its own span ID and the span ID of its parent, and a span without a parent is the root. The span context also carries trace flags, whose lowest bit is the sampled flag, and an optional trace state. Inside one program the SDK finds the parent from the current context. Between programs the caller must send the span context and the receiver must read it.

The span kind states the role of the operation: server, client, producer, consumer or internal. The span status is unset by default, error when the operation failed and ok only when someone decided so. An event records a moment inside one span, and an exception is an event that does not set the status by itself. A link relates a span to a span of another trace without making it a child.

Head sampling decides when the trace starts and cannot know the outcome. Tail sampling decides after the spans are collected and can keep every trace with an error, but it needs memory and all spans of one trace in the same Collector. A set of sampled traces shows what individual requests did. It does not give totals, rates or proof that an event never happened.

Key facts:

- Only the trace ID is shared by all spans of a request.
- A successful span normally has the status unset, not ok.
- A head sampler placed before a tail sampler drops errors before the tail sampler sees them.
- A gap in a trace is first evidence about propagation and collection.

<!-- astrona:playground:destroy -->
