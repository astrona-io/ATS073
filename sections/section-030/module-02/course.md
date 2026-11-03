---
draft: true
exam_objectives:
  - Instrumentation
---
# Manual Instrumentation With The API

This module explains how code creates telemetry by calling the OpenTelemetry API. It covers how a program gets a tracer and a meter, how it starts and ends spans, how it records attributes, events, exceptions and status, and how it creates metric instruments and records measurements. The examples are in Python. The hands-on steps read the output of a program that calls the API, and the lab fixes the instrumentation of a program in a running cluster.

## Learning Goals

- Explain why code calls the API and why an API call without an SDK does nothing.
- Start spans with the right kind and attributes, and end them reliably.
- Record events and exceptions, and set the span status on failure.
- Choose a metric instrument for a count, a value that goes up and down and a distribution, and attach attributes of bounded cardinality.
- Read the spans and metrics of an instrumented program in the output of a Collector.

## Before You Start

You should know what a span, a trace and a metric are, and that the API, the SDK and an exporter have separate jobs. The hands-on steps use a playground: a kind cluster with `kubectl`, a Collector in the namespace `observability` and a Python program in `starfleet`. The program installs its packages when it starts, so the cluster needs internet access. Technical terms are defined where they first appear.

## Reading Order

1. Tracers, Meters And Instrumentation Scope
2. Creating Spans, Attributes And Kind
3. Events, Exceptions And Span Status
4. Metric Instruments In Code
5. Summary

<!-- astrona:playground -->
