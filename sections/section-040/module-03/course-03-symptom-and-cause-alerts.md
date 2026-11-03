---
draft: true
exam_objectives:
  - Analysis and Outcomes
---
# Symptom And Cause Alerts

An alert is useful when a person can act on it. Alerts that fire often and need no action teach people to ignore them. This part sets the rules for which alerts to write.

## Symptoms and causes

A **symptom** is what a user or a client sees: failed requests, slow responses, stale data. A **cause** is an internal condition that might lead to a symptom: high CPU, a full disk, a restart of a pod.

| Kind | Example | Fires when |
| --- | --- | --- |
| Symptom | Error ratio above the burn-rate threshold | Users are harmed now |
| Cause | Disk 85 percent full | Something may fail later |

Page a person for symptoms that are happening or certain to happen. A high CPU with no effect on users is not a reason to wake someone. Causes are better placed on a dashboard or in a ticket, with the exception of causes that will become a symptom within a known short time, such as a disk that will be full in four hours.

## Page or ticket

| Question | Page | Ticket |
| --- | --- | --- |
| Do users suffer now? | Yes | No |
| Must someone act within minutes? | Yes | No |
| Can it wait until the work day? | No | Yes |

The label `severity` carries the answer, and Alertmanager routes on it. In the lab, the fast burn has `severity: page` and the slow burn has `severity: ticket`.

## Qualities of a good alert

- It is **actionable**: the annotation says what to check first, and a `runbook_url` points to the steps.
- It is **specific**: the labels say which service and which environment.
- It is **stable**: the `for` duration and the windows prevent flapping.
- It has an **owner**: the label `team` routes it to the right group.

## Alert fatigue

If a rule fires and nobody acts, change it: raise the threshold, lengthen `for`, or turn it into a ticket or a dashboard panel. Review the alerts that fired last month and delete those that led to no action.

## Check it in the playground

<!-- astrona:playground:renew -->

Take the error ratio of the bridge and the rule from the previous part. Decide for each of these whether it should page, open a ticket, or only appear on a dashboard, and write the label and the first sentence of the annotation:

1. The 5xx ratio of the bridge has a burn rate of 15 for 5 minutes.
2. The 5xx ratio has a burn rate of 1.2 for two days.
3. The worker utilization ratio `bridge_worker_utilization_ratio` is 0.62.

Run the query for the third metric in Prometheus and compare it with the value you chose.

Alerts have a priority. The next part is about how the notifications are delivered.

## Common pitfalls

> [!WARNING]
> Do not page on a cause that has no effect on users. Do not write an alert without an annotation that tells the reader what to do. Do not copy one threshold to all services. Do not keep an alert that has fired many times without action.
