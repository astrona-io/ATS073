---
draft: true
exam_objectives:
  - Telemetry Data
---
# Traces In Depth: Spans, Context And Sampling Decisions

This module goes deeper into the trace signal. It explains how the identifiers of a span link spans into one trace, what the span kind, the status, the events and the links add, how a sampling decision keeps or drops a trace, and what a set of traces can and cannot prove. The hands-on steps read the spans that three generators send to an OpenTelemetry Collector, and the lab replaces a head sampler with a tail sampler.

## Learning Goals

- Describe the trace ID, the span ID, the parent span ID and the trace flags of a span, and read them in the `debug` exporter output.
- Choose the span kind that fits an operation, and explain when a span status is unset, ok or error.
- Explain what span events and span links record and when each one is the right field.
- Compare head sampling with tail sampling and configure the `tail_sampling` processor to keep every trace that contains an error.
- State what a set of sampled traces proves and what it does not prove.

## Before You Start

You should know that a trace is a tree of spans and that an OpenTelemetry Collector receives, processes and exports telemetry. The hands-on steps use a playground: a kind cluster with `kubectl`, a Collector in the namespace `observability` and load generators in `starfleet`. Technical terms are defined where they first appear.

## Reading Order

1. Span Context And The Parent-Child Structure
2. Span Kind, Status, Events And Links
3. Head Sampling And Tail Sampling
4. What A Set Of Traces Can Prove
5. Summary

<!-- astrona:playground -->
