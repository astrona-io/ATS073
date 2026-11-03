---
draft: true
exam_objectives:
  - Analysis and Outcomes
---
# Summary

The RED method describes a request-driven service with three measurements: the rate of requests, the share of requests that fail, and the duration of requests. A counter of requests with a response code label and a histogram of durations are enough to produce all three. The method does not describe the machine under the service.

The USE method describes a resource with three measurements: utilization, saturation and errors. Utilization is the share of capacity in use. Saturation is the work that waits, and it needs its own metric, such as a queue length. A missing metric is a result of the method: it shows a question that nobody can answer during an incident. An empty query result is not a measured zero.

The four golden signals are latency, traffic, errors and saturation. RED covers the first three, and USE covers saturation. A complete picture uses RED for the service and USE for the resources below it. Alerts should point at symptoms that users feel, and causes belong on dashboards or in lower-priority warnings. A batch job needs its own measurements, such as the age of the last success.

PromQL uses `rate` on counters and sums before dividing, so that the ratio is the ratio of the whole. A recording rule saves a query as a new series under a name of the form `level:metric:operations`. The rule file must be listed under `rule_files`, the interval is `evaluation_interval`, and a running Prometheus reads a changed file only after a restart, a reload request or a `SIGHUP` signal.

Key facts:

- RED fits services, USE fits resources, and the golden signals fit user-facing systems.
- Saturation needs a queue or waiting-time metric: utilization alone does not show it.
- `rate` needs a counter that grows, and it returns 0 for a fixed counter.
- A recording rule file has no effect until `rule_files` lists it.

<!-- astrona:playground:destroy -->
