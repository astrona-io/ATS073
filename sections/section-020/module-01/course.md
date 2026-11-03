---
draft: true
exam_objectives:
  - Semantic Conventions
---
# Semantic Conventions, Attribute Meaning And Stability

This module explains how OpenTelemetry gives attribute names, values and units one shared meaning, how to decide where an attribute belongs, and how to change attributes in a Collector without breaking the people who read the data. It uses a Collector in a running cluster and reads the result in its log.

## Learning Goals

- Explain a semantic convention as a contract on names, types, units and requirement levels, and describe what stability and deprecation mean for it.
- Distinguish resource attributes from span, log and data point attributes, and place an attribute on the right one.
- Rename, copy and delete attributes in a Collector with the `attributes` processor, and explain why the order of the actions matters.
- Reason about the cost and the privacy risk of attributes before they leave the Collector.

## Before You Start

You should know what a span, a resource and a Collector pipeline are. The hands-on steps use a playground: a kind cluster with `kubectl`, an OpenTelemetry Collector in the namespace `observability` and one load generator in `starfleet`. Technical terms are defined where they first appear.

## Reading Order

1. Semantic Conventions As A Shared Contract
2. Resource Attributes And Operation Attributes
3. Normalizing Attributes In The Collector
4. Summary

<!-- astrona:playground -->
