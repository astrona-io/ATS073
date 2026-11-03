---
draft: true
exam_objectives:
  - Semantic Conventions
---
# Naming Rules, Namespaces And Requirement Levels

Two teams can describe the same HTTP request with `http.method` and `request_method`. A dashboard that expects one name finds nothing in the data of the other team. Semantic conventions remove this problem by fixing the names, the types and the meaning of common attributes. This part explains the rules behind those names, because every later convention follows them.

## Rules for attribute names

An attribute name is a string with a fixed shape:

- It is lowercase.
- It is made of **namespaces** separated by dots, for example `http.request.method`. A namespace groups related attributes, here everything about an HTTP request.
- Inside a namespace, words are separated by underscores, for example `http.response.status_code`.
- It is not changed by the backend. A name with a capital letter is a different name.

The names `http.request.method` and `http.response.status_code` follow the rules. A name such as `HTTP-Method` or `httpMethod` does not. The type is part of the contract as well. `http.response.status_code` is an integer, and a string `"200"` is a different value that a numeric comparison does not match.

The namespace `otel` is reserved for OpenTelemetry itself. Names that start with `otel.` describe the instrumentation, for example `otel.scope.name`. Do not use it for application data.

## Rules for span names

A span name says what the operation is, and it must have **low cardinality**: a small set of distinct values. The span name for an HTTP server request is the method and the route template, for example `GET /orders/{id}`. It is not the full path `GET /orders/42`, because that creates a new name for every order. A backend groups spans by name, so a name with a changing part makes the grouping useless. Put the changing value in an attribute instead.

## Rules for metric names and units

A metric name uses the same dotted lowercase shape. The convention for HTTP server duration is `http.server.request.duration`. The **unit** follows the UCUM codes: `s` for seconds, `By` for bytes and `{request}` for a count of requests. A metric whose name says duration and whose unit is `ms` breaks the convention, because the convention fixes the unit to seconds. The instrument type is fixed too: a duration is a histogram and the number of active requests is an up-down counter.

## Requirement levels

A convention does not demand every attribute on every item. Each attribute has a **requirement level**:

- **Required**: the instrumentation must set it.
- **Conditionally required**: it must be set when a stated condition holds, for example `http.route` when the framework knows the route.
- **Recommended**: it should be set unless it is expensive or unavailable.
- **Opt-in**: it is off by default, because it is costly or can hold sensitive data. The user must switch it on.

The level tells you what to expect from a library that follows the convention. A Required attribute that is missing is a defect in the library or in a processor that removed it. An Opt-in attribute that is missing is normal.

## Your own attribute names

An application has data that no convention covers, such as an order number. Put it under a namespace that belongs to you, for example `starfleet.order.id`. A name without a namespace, such as `order_id`, can clash with a future convention. A name inside a standard namespace, such as `http.order_id`, is worse, because a later version of the convention can define `http.order_id` with another meaning.

## Check names in the playground

<!-- astrona:playground:renew -->

The generator `scout-load` sends spans that use older names. Read the span attributes:

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1 | grep -E '^ +-> ' | sort | uniq -c | sort -rn | head -20
```

Each line shows one attribute name, its type and its value, with a count. Decide for each name whether it follows the lowercase dotted shape, whether it is in a standard namespace and whether the type is the one the convention fixes. In this output, `http.status_code` has the type `Int`, and the current convention name for the same fact is `http.response.status_code`.

Now find the sensitive name. A name such as `user.email` is in the namespace `user`, which is a standard namespace. A value in it is personal data. Part of reading a convention is deciding whether the data should be collected at all.

## What to take from this

A name is a lowercase, dotted string with a namespace, and its type, unit and meaning are part of the contract. Span names stay low in cardinality, metric names carry fixed units, and requirement levels say what a library must set. Your own attributes go under your own namespace. The next question is which names the conventions fix for the most common operation: a call over HTTP.

## Common pitfalls

> [!WARNING]
> Do not put a changing value such as an order number in a span name. Do not invent an attribute under a standard namespace. Do not change the type of an attribute: a status code as a string and a status code as an integer are not the same value to a backend.
