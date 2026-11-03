---
draft: true
exam_objectives:
  - Instrumentation
---
# API Calls, Automatic Instrumentation And Measurement Design

This module explains how a program produces telemetry: which part of OpenTelemetry the program code calls, which part decides where the data goes, and how environment variables configure all of it without a code change. It then covers how to choose what to measure so that the telemetry is useful, small and safe. The hands-on steps run an instrumented Python program in a cluster.

## Learning Goals

- Explain the roles of the API, the SDK and an exporter, and why library code depends on the API only.
- Distinguish manual instrumentation from automatic instrumentation, and name what each is good at.
- Configure an instrumented program with the `OTEL_*` environment variables: service name, resource attributes, exporter protocol, endpoint, sampler and SDK switch.
- Choose spans, instruments, units and attributes so that the result is useful, bounded and free of sensitive values.

## Before You Start

You should know what a span, a metric and a resource are, and what a Kubernetes Deployment and its environment variables are. You do not need to write Python. The hands-on steps use a playground: a kind cluster with `kubectl`, an OpenTelemetry Collector in the namespace `observability` and one instrumented program in `starfleet`. The cluster needs internet access, because the program installs its packages when its pod starts, and this takes about one minute.

## Reading Order

1. API, SDK And Exporter: Who Does What
2. Automatic Instrumentation And Environment Variables
3. Designing Useful Measurements
4. Summary

<!-- astrona:playground -->
