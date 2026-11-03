---
draft: true
exam_objectives:
  - Telemetry Data
---
# Summary

Metrics summarize measurements as data points with attributes. Traces follow one request as a tree of spans that share a trace ID. Logs record single events with a timestamp, a severity and a body. The three signals answer different questions and share one transport, OTLP, which a Collector receives.

A resource names the producer through resource attributes such as `service.name`, `service.namespace` and `deployment.environment.name`. An instrumentation scope names the code that created an item, and it is not the service identity. Signals are joined by a shared resource, by the trace ID and span ID on a log record, and by an exemplar on a metric data point when one exists.

A Collector has receivers, processors and exporters, and it uses a component only when a pipeline lists it. Each pipeline carries one signal type, and processors run in the listed order. A signal with no pipeline is not processed. A head sampler such as `probabilistic_sampler` keeps a share of traces and belongs in the `traces` pipeline only. High-cardinality attributes multiply metric series, and sensitive values are best prevented at the source.

Key facts:

- Missing telemetry is evidence about the collection path as well as the system, and it cannot prove that an operation never happened.
- A healthy sender does not prove that its data arrived at the end of the path.
- A change to the Collector ConfigMap takes effect only after the Collector restarts.
- A conclusion from telemetry needs a stated population, time window and collection assumption.

<!-- astrona:playground:destroy -->
