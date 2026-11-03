---
draft: true
exam_objectives:
  - Telemetry Data
---
# Telemetry Signals, Resource Identity And Evidence Limits

This module explains what the three OpenTelemetry signals record, how a piece of telemetry says which thing produced it, and what the data can and cannot prove. It then changes an OpenTelemetry Collector in a running cluster and reads the result in the Collector log.

## Learning Goals

- Describe the fields of a metric data point, a span and a log record, and name the question each signal answers best.
- Explain resource identity and instrumentation scope, and how a trace identifier links a log record to a span.
- Read the `debug` exporter output of a Collector and find the signal, the resource attributes and the items.
- Add a pipeline and a `resource` processor to a Collector and explain what a missing pipeline, a sampler and a high-cardinality attribute do to the evidence.

## Before You Start

You should know what a Kubernetes pod and a ConfigMap are. The hands-on steps use a playground: a kind cluster with `kubectl`, an OpenTelemetry Collector in the namespace `observability` and two load generators in `starfleet`. Technical terms are defined where they first appear. Nothing in this module needs a backend such as a database or a dashboard.

## Reading Order

1. Metrics, Traces And Logs: What Each Signal Records
2. Resource Identity, Scope And Correlation
3. Collector Pipelines, Sampling And Evidence Limits
4. Summary

<!-- astrona:playground -->
