---
draft: true
exam_objectives:
  - Analysis and Outcomes
---
# RED, USE And The Four Golden Signals

An indicator needs a choice of what to measure. This module covers three standard sets of measurements: the RED method for request-driven services, the USE method for resources, and the four golden signals. It shows which method fits which component, how to write each measurement in PromQL, and how to store a measurement as a recording rule so that dashboards and alerts read one agreed definition. The hands-on steps query a Prometheus server in a cluster.

## Learning Goals

- Describe the RED method: rate, errors and duration of requests.
- Describe the USE method: utilization, saturation and errors of a resource.
- Name the four golden signals: latency, traffic, errors and saturation.
- Choose the method that fits a service, a resource or a user-facing endpoint.
- Write PromQL for rate, error ratio, latency ratio and utilization.
- Define a recording rule, name it by convention, and load it into Prometheus.

## Before You Start

You should know what a counter, a gauge and a histogram are, and how to run a PromQL query. The hands-on steps use a playground: a kind cluster with `kubectl` and a Prometheus server in the namespace `observability`. Prometheus scrapes two small web servers that serve fixed values, so every query returns the same result. Technical terms are defined where they first appear.

## Reading Order

1. The RED Method For Services
2. The USE Method For Resources
3. The Four Golden Signals And Choosing A Method
4. PromQL For Each Signal And Recording Rules
5. Summary

<!-- astrona:playground -->
