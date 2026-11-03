---
draft: true
exam_objectives:
  - Analysis and Outcomes
---
# Summary

A service level indicator is the ratio of good events to valid events over a window. A service level objective is the target for that ratio, and a service level agreement is a contract with a consequence, usually looser than the objective. The result depends on the definition of the populations: which events are valid, which are good, and which are excluded. Two definitions give two numbers from the same data.

The error budget is the failure that the objective allows: the allowed bad events equal the valid events multiplied by one minus the target. Budget consumed is the bad events divided by the allowed bad events, and a remaining budget below zero means that the objective was missed. The burn rate is the error ratio divided by the allowed error ratio, and it is the basis of fast and slow alerts. Low traffic, exclusions and incomplete observation each make the arithmetic less reliable.

A Prometheus histogram stores cumulative buckets, a count and a sum. A latency indicator divides the bucket at the threshold by the count, and the threshold must be a bucket bound. Percentiles from `histogram_quantile` are estimates that cannot be averaged. Every indicator depends on scrape health: a failed scrape sets `up` to 0 and leaves a gap in the series, and a gap is not a measured zero.

A dashboard answers the questions of rate, errors, duration and saturation, and it states the time range, the resolution, the unit, the grouping and the denominator. An overall ratio is the sum of counts divided by the sum of counts, and not an average of ratios. A display that fills a gap with zero hides a broken measurement, and an alert rule on `absent` or `up` is the check that covers it.

Key facts:

- A client error is excluded from the valid events only when the definition says so.
- Burn rate 1 spends the whole budget exactly at the end of the window.
- The bucket `le="+Inf"` equals the count of the histogram.
- A query for a series that does not exist returns an empty result, and `absent` turns that into a value of 1.

<!-- astrona:playground:destroy -->
