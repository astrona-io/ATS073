---
draft: true
exam_objectives:
  - Analysis and Outcomes
---
# Service Indicators, Objectives, Agreements And Budgets

This module explains how telemetry becomes a decision. It defines a service level indicator, an objective and an agreement, and it calculates an error budget from counters. It then covers latency indicators from histograms and the way a dashboard shows population, units and gaps, so that a reader does not mistake a missing series for a measured zero. The hands-on steps query a Prometheus server in a cluster.

## Learning Goals

- Distinguish a service level indicator (SLI), a service level objective (SLO) and a service level agreement (SLA).
- Define the good events, the valid events and the window of an indicator, and calculate the SLI from counters.
- Calculate an error budget and a burn rate, and account for low traffic, exclusions and incomplete observation.
- Calculate a latency SLI from cumulative histogram buckets and check that a scrape target is up.
- Choose panels for rate, errors, duration and saturation, and read a panel with its time range, resolution, units, grouping and denominator.
- Tell a display gap from a measured zero.

## Before You Start

You should know what a counter and a histogram are, and what a label on a metric is. The hands-on steps use a playground: a kind cluster with `kubectl` and a Prometheus server in the namespace `observability`. Prometheus scrapes a small web server that serves fixed counters, so every query returns the same values. Technical terms are defined where they first appear.

## Reading Order

1. SLIs, SLOs And SLAs: Defining Good And Valid Events
2. Error Budgets And Burn Rate
3. Latency Indicators And Scrape Health
4. Dashboards That Explain Population, Units And Gaps
5. Summary

<!-- astrona:playground -->
