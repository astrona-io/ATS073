---
draft: true
exam_objectives:
  - Instrumentation
---
# Zero-Code Instrumentation, Propagators And Baggage

Most services get their first telemetry without a code change: an agent or a wrapper command loads instrumentation libraries at start. A trace across two services works only when both sides agree on the format of the context that travels in the request. This module covers zero-code instrumentation, propagators, baggage and samplers, and ends with a lab where a broken trace is repaired by one setting.

## Learning Goals

- Start a program with zero-code instrumentation and configure it with environment variables.
- Explain how the OpenTelemetry Operator injects an agent into a pod.
- Describe the `traceparent` header and the role of a propagator.
- Choose values for `OTEL_PROPAGATORS` for W3C, B3 and mixed systems.
- Use baggage to carry a value across services and state its risks.
- Explain how a parent-based sampler keeps one decision for a whole trace.

## Before You Start

You should know what a trace, a span and a span kind are. The hands-on steps use a playground: a kind cluster with `kubectl`, an OpenTelemetry Collector, and two small Python services, a client and a billing server, that run under `opentelemetry-instrument`. The Collector prints every span with its `debug` exporter. Starting the services takes about a minute because the pods install their packages.

## Reading Order

1. Zero-Code Instrumentation
2. Context Propagation And Propagators
3. Baggage
4. Samplers And Parent-Based Decisions
5. Summary

<!-- astrona:playground -->
