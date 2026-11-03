---
draft: true
exam_objectives:
  - Telemetry Data
---
# Metrics, Logs, Events And Profiles In Depth

Module 1 of this section named the three main signals. This module goes one level down. It covers the kinds of metric data points and the two ways a counter can be reported over time, the fields of a log record and its severity scale, the difference between a span event and a log-based event, and the fourth signal, profiles. It ends with a Collector change that filters log records by severity.

## Learning Goals

- Name the instruments and the data point kinds of the metrics data model.
- Explain cumulative and delta aggregation temporality and what a reset means.
- List the fields of a log record and map severity numbers to severity levels.
- Tell a span event from an event stored as a log record.
- Describe what a profile records and the state of the profiles signal.
- Filter log records by severity in a Collector pipeline.

## Before You Start

You should know what a metric, a span and a log record are, and what a Collector pipeline is. The hands-on steps use a playground: a kind cluster with `kubectl`, an OpenTelemetry Collector and load generators that send traces, metrics and logs. The Collector prints every item with its `debug` exporter. Technical terms are defined where they first appear.

## Reading Order

1. Metric Instruments, Data Points And Temporality
2. Log Records, Severity And Correlation
3. Events And Profiles
4. Choosing A Signal And Filtering Logs In The Collector
5. Summary

<!-- astrona:playground -->
