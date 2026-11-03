---
draft: true
exam_objectives:
  - Instrumentation
---
# Metric Instruments In Code

A span describes one operation. A metric describes many operations together: how many, how fast, how full. The API gives code a set of **instruments**, and the choice of instrument decides what the data means and how it is aggregated. This part lists the instruments, shows when to use each and explains the rules that keep metrics small and correct.

## Synchronous instruments

A synchronous instrument is called by your code at the moment the event happens. The API defines these:

- A **Counter** only increases. Use it to count events, such as orders processed. `counter.add(1, attributes)`.
- An **UpDownCounter** can increase and decrease. Use it for a value that goes up and down as things start and finish, such as orders in progress. `up_down_counter.add(1)` at the start and `add(-1)` at the end.
- A **Histogram** records the distribution of a value, such as a duration or a size. `histogram.record(0.12, attributes)`.
- A **Gauge** records the current value when you set it. It suits a value that is not additive, such as a temperature.

Create an instrument once, usually at module level, and call it many times:

```python
processed = meter.create_counter("orders.processed", unit="{order}", description="Orders processed")
in_progress = meter.create_up_down_counter("orders.in_progress", unit="{order}")
duration = meter.create_histogram("orders.duration", unit="s", description="Time to process an order")
```

## Asynchronous instruments

An **asynchronous instrument** (also called observable) does not get called when an event happens. The SDK calls a **callback** that you register, once for each collection cycle, and the callback reports the current value. Use it for a value that you read from somewhere else, such as the size of a queue or the memory use of the process. The observable counter, observable up-down counter and observable gauge exist for the three cases of a total that only grows, a total that can shrink and a value at one moment.

## Names, units and descriptions

The name uses lowercase dotted words. The unit follows the UCUM codes: `s` for seconds, `By` for bytes, and braces for a count of things, such as `{order}`. Use seconds for durations, because the conventions do. The description is free text for humans.

## Attributes and cardinality

Attributes on a measurement split it into series. `processed.add(1, {"order.outcome": "accepted"})` and `{"order.outcome": "rejected"}` create two series. Choose attributes with a small, bounded set of values, such as an outcome, a method or a route template. Do not use a customer ID, a user ID, an order number or a URL path. Each distinct value creates a new series, and the cost grows without limit.

## From instrument to data

The SDK aggregates the measurements. A Counter becomes a sum, a Histogram becomes a set of bucket counts with a sum and a count, and a Gauge becomes the last value. The SDK exports the aggregate at an interval, which is 60 seconds by default and which `OTEL_METRIC_EXPORT_INTERVAL` changes in milliseconds. A **view** is an SDK setting that renames an instrument, drops attributes, or changes the histogram buckets without changing the code that records.

## Read the metrics in the playground

<!-- astrona:playground:renew -->

The program creates a counter, an up-down counter and a histogram. The export interval is 5 seconds in the playground. Read the metric names and types:

```sh
kubectl -n observability logs deploy/otel-collector --since=60s --tail=-1 | grep -E -- '-> Name: orders|DataType'
```

Find `orders.processed`, `orders.in_progress` and `orders.duration`. Check the data type of each. Then find the attribute `order.outcome` on the data points of `orders.processed` and `orders.duration`, and confirm that it has two values.

Think about what the value of `orders.in_progress` shows. The program adds 1 when an order starts and subtracts 1 when it finishes, and the work takes a fraction of a second, so the sum is 0 whenever the exporter reads it. A value of 0 here is correct: no order was in progress at that moment.

Look at the histogram data point. Find the count, the sum and the bucket counts. The count is the number of orders in the interval. The sum divided by the count is the mean duration. You cannot read a single duration from it.

## What to take from this

The instrument decides the meaning of a metric: a counter for events, an up-down counter for a value that moves both ways, a histogram for a distribution and a gauge for a value at a moment. Asynchronous instruments report a value that the code reads on demand. Names, units and bounded attributes keep the data comparable and small. With spans, events and metrics created by code, the next question is how much of this a library can do without code changes.

## Common pitfalls

> [!WARNING]
> Do not create an instrument inside a loop or a request handler; create it once. Do not use a Counter for a value that can decrease. Do not use an unbounded value, such as a user ID, as a metric attribute. Do not record durations in milliseconds when the convention uses seconds.
