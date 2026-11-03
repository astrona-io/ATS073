---
draft: true
exam_objectives:
  - Telemetry Data
---
# Summary

The metrics data model has four data point kinds: sum, gauge, histogram and exponential histogram. A counter produces a monotonic sum, an up-down counter a sum that is not monotonic, and a histogram a distribution. A sum or a histogram is either cumulative or delta. Cumulative points hold the total since a start time and survive a lost point. Delta points hold the change since the previous point and need every point. A fall in a cumulative value with a new start time is a reset. Prometheus expects cumulative values, and the Collector can convert between the two.

A log record has a timestamp, an observed timestamp, trace and span IDs, a severity text, a severity number from 1 to 24, a body, attributes, a resource and a scope. The number puts every logging library on one scale: 1 to 4 trace, 5 to 8 debug, 9 to 12 info, 13 to 16 warn, 17 to 20 error and 21 to 24 fatal. A log bridge adds the trace and span IDs to the records of an existing logging library.

A span event lives inside its span and is lost with an unsampled trace. An event as a log record is its own record and does not need a span. Profiles are the fourth signal and show which code uses a resource. The signal is still in development.

A signal is chosen by the question. The `filter` processor drops logs by an OTTL condition, such as `severity_number < SEVERITY_NUMBER_INFO`, and applies only to the pipelines that list it.

Key facts:

- Cumulative points keep the same start time, and delta points do not repeat earlier changes.
- Filter on `severity_number`, not on the text of the level.
- A dropped record is gone for every backend.
- A processor works only in the pipelines that list it.

<!-- astrona:playground:destroy -->
