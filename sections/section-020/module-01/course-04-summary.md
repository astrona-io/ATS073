---
draft: true
exam_objectives:
  - Semantic Conventions
---
# Summary

A semantic convention is a shared contract on the name, type, meaning, allowed values and unit of a telemetry field. Each attribute has a requirement level, and the conventions have stability levels. A stable name is protected from breaking changes, and a deprecated name remains in old instrumentation, so telemetry from different libraries can use different names for the same fact. A custom attribute needs its own namespace and must not reuse a standard name for another meaning.

Resource attributes describe the producer and are stored once. Span, data point and log record attributes describe one item. A value that changes per operation does not belong on the resource, and a metric attribute needs a small, known set of values. Unbounded identifiers belong on spans and logs.

The `attributes` processor in a Collector copies, adds, replaces, hashes and removes attributes of spans, logs and data points, and the `resource` processor changes the resource. The actions run in the listed order, and a copy from a missing key does nothing. A Collector rule repairs data at the edge, while a value that must never leave the producer is best prevented in the instrumentation.

Key facts:

- A renamed attribute is copied first and the old key is deleted after it.
- A `from_attribute` copy keeps the value type, so an integer status code stays an integer.
- A resource attribute set by one processor is not visible to a consumer that filters on span attributes.
- The `hash` action does not protect values that can be guessed from a small set of candidates.

<!-- astrona:playground:destroy -->
