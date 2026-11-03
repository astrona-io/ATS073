---
draft: true
exam_objectives:
  - Semantic Conventions
---
# Semantic Conventions By Signal And Domain

This module applies semantic conventions to real telemetry. It explains the naming rules for attributes, spans and metrics, then walks through the conventions for HTTP, remote procedure calls, databases, messaging, Kubernetes and cloud platforms, and shows how to name your own attributes without clashing with the standard ones. The hands-on steps read spans from a database client in a Collector, and the lab renames old database attributes with the `transform` processor.

## Learning Goals

- Apply the naming rules for attribute names, span names, metric names and units.
- Name the main attributes of the HTTP, database, messaging and RPC conventions and say which are required.
- Explain requirement levels and the stability levels of a convention.
- Place Kubernetes and cloud attributes on the resource and operation attributes on the span.
- Rename and sanitize attributes with the `transform` processor and OpenTelemetry Transformation Language (OTTL) statements.

## Before You Start

You should know that an attribute is a key-value pair on a span, a metric data point, a log record or a resource, and that an OpenTelemetry Collector processes telemetry in pipelines. The hands-on steps use a playground: a kind cluster with `kubectl`, a Collector in the namespace `observability` and load generators in `starfleet`. Technical terms are defined where they first appear.

## Reading Order

1. Naming Rules, Namespaces And Requirement Levels
2. HTTP And RPC Conventions
3. Database And Messaging Conventions
4. Kubernetes, Cloud And Custom Attributes
5. Summary

<!-- astrona:playground -->
