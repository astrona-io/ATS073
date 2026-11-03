---
draft: true
exam_objectives:
  - Analysis and Outcomes
---
# Alerting And Burn-Rate

A dashboard waits for a person to look at it, and an alert goes to the person. This module covers the parts of an alerting rule, the arithmetic of an error budget and a burn rate, the choice between alerts on symptoms and on causes, and the way Alertmanager routes a notification. It ends with a lab where two burn-rate alerts are written and one of them must fire.

## Learning Goals

- Write a Prometheus alerting rule with `expr`, `for`, labels and annotations.
- Describe the states inactive, pending and firing.
- Compute an error budget and a burn rate from a service level objective.
- Explain multiwindow, multi-burn-rate alerts and choose thresholds.
- Decide whether an alert should page a person or open a ticket.
- Explain how Alertmanager groups, routes and inhibits notifications, and find why an alert did not arrive.

## Before You Start

You should know what a Prometheus recording rule and a PromQL ratio are, and what a service level objective is. The hands-on steps use a playground: a kind cluster with `kubectl` and a Prometheus server that scrapes two services with fixed counters. The bridge service has a known share of 5xx responses. Technical terms are defined where they first appear.

## Reading Order

1. The Anatomy Of An Alerting Rule
2. Error Budgets And Burn Rate
3. Symptom And Cause Alerts
4. Alertmanager Routing And Troubleshooting With Correlated Signals
5. Summary

<!-- astrona:playground -->
