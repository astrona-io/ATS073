---
draft: true
exam_objectives:
  - Telemetry Data
---
# Span Kind, Status, Events And Links

Two spans can have the same name and the same duration and still mean different things. One describes the service answering a request, and the other describes a service calling its dependency. A third records that the operation failed. This part explains the fields that carry that meaning: the span kind, the status, the events and the links.

## Span kind

The **span kind** says what role the span plays in a request. OpenTelemetry defines five values:

- `SERVER` covers the handling of an incoming synchronous request, for example an HTTP server handling `GET /orders`.
- `CLIENT` covers an outgoing synchronous request, for example the HTTP call from `bridge` to `shuttle` or a database query.
- `PRODUCER` covers the creation of a message that is processed later, for example publishing to a queue.
- `CONSUMER` covers the processing of a message that a producer created.
- `INTERNAL` covers an operation that stays inside the program, for example a function call. It is the default.

A backend uses the kind to draw a service map. A `CLIENT` span in one service and the `SERVER` span that it caused in another service together make one edge of the map. If every span has the kind `INTERNAL`, the traces still exist, but the service map and the latency between services cannot be built correctly. The kind also changes which attributes apply: the semantic conventions for HTTP define different attributes for a client span and a server span.

## Span status

The **status** says whether the operation succeeded. It has three values: `UNSET`, `OK` and `ERROR`.

`UNSET` is the default and means that nothing said otherwise. It is not a failure and it is not a success claim. `ERROR` means that the operation failed, and the status may carry a short message. `OK` is a deliberate final decision that the operation succeeded. Instrumentation libraries normally leave a successful span as `UNSET` and set `ERROR` on a failure. For an HTTP server span, the convention sets `ERROR` for a response status code of 500 or higher, and it does not set `ERROR` for a 404, because the server worked correctly when it said that the resource does not exist. For an HTTP client span, a code of 400 or higher is an error from the point of view of the caller.

The rule that follows is simple. Count failures by `ERROR`, not by the absence of `OK`. Most successful spans never carry `OK`, so a query for `OK` finds only the spans where someone set it explicitly.

## Events

A span **event** is a timestamped note inside a span. It has a name, a time and attributes. Use an event for something that happens at one moment while the operation runs, such as "cache miss", "retry started" or an exception. A span has one start time and one end time, so an event is the field that records what happened in between.

An exception is recorded as an event named `exception`. Its attributes `exception.type`, `exception.message` and `exception.stacktrace` hold the details. Recording an exception does not by itself set the status to `ERROR`. The program must set the status as well, because an exception can be handled and the operation can still succeed.

## Links

A **link** points from one span to another span, usually in another trace. A link carries the span context of the target and optional attributes. Links describe a relationship that is not parent and child. A batch consumer that processes ten messages in one span can link to the producer span of each message, because one parent cannot represent ten traces. Use a parent for "this operation happens inside that one". Use a link for "this operation is related to that one but is not inside it".

## Read kind and status in the playground

<!-- astrona:playground:renew -->

The container `traces-error` of `shuttle-load` sends spans with the status code `Error`, and `traces-ok` sends spans with the status code `Ok`. Count the spans of each status in the last 60 seconds:

```sh
kubectl -n observability logs deploy/otel-collector --since=60s --tail=-1 | grep -c 'Status code *: Error'
kubectl -n observability logs deploy/otel-collector --since=60s --tail=-1 | grep -c 'Status code *: Ok'
```

The numbers are the counts of spans, not of traces. Compare them with what the generators were told to send: 1 trace per second with 1 span from `traces-error` and 5 traces per second with 3 spans from `traces-ok`. The `Ok` count is much larger, which matches the rates. Now look at the kind that `telemetrygen` sets:

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1 | grep -E 'Kind' | sort | uniq -c
```

The generator sets the kind itself, and a real program sets it through its instrumentation. Notice that the kind is a field of the span, so a Collector can read it and a processor can act on it.

Decide which fields a dashboard would use to answer "how many requests failed" and "which service called which". The first answer comes from the status of server spans, and the second from the pairs of client and server spans.

## What to take from this

This part covered the fields that give a span its meaning. The kind states the role in the request, the status states success or failure with `UNSET` as the neutral default, events record moments inside one span, and links connect spans that are related without being parent and child. The open question is which traces to keep when there are too many to store, which is the subject of the next part.

## Common pitfalls

> [!WARNING]
> Do not search for `OK` to count successful requests, because most successful spans stay `UNSET`. Do not treat an `exception` event as a failed span: only the status says that the operation failed. Do not set every span to `INTERNAL`, because a backend then cannot connect a client span to the server span it caused.
