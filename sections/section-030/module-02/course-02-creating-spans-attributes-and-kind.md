---
draft: true
exam_objectives:
  - Instrumentation
---
# Creating Spans, Attributes And Kind

A span records one operation, and the code decides where the operation starts and ends. Wrong boundaries give traces that are hard to read: spans that never end, spans that cover too much, or spans with the wrong kind. This part shows how to start a span, how the current context makes spans nest, and how to set attributes and the kind.

## Start a span with a context manager

The common way to start a span in Python is `start_as_current_span` used as a context manager:

```python
with tracer.start_as_current_span("process-order", kind=SpanKind.SERVER) as span:
    span.set_attribute("order.items", items)
    reserve_stock(items)
```

Three things happen. The tracer creates the span and makes it the **current span** in the context. The code in the block runs. When the block ends, the span ends, even when the code raises an exception. A span must end to be exported. A span that never ends is never sent.

Inside `reserve_stock`, another call to `start_as_current_span` creates a child. The new span takes the current span as its parent, so no code passes the parent by hand. When the inner block ends, the current span goes back to the outer one.

The function `start_span` creates a span without making it current and without ending it. The code must call `span.end()` itself. Use it when the start and the end are in different places, for example in a callback, and always end the span in a `finally` block.

## Span names

The name states the operation in a short form with low cardinality. `process-order` is a good name. `process-order-42` is not, because every order creates a new name. Put the order number in an attribute. For HTTP and database spans, the semantic conventions describe the name.

## Attributes

An **attribute** is a key and a value. The value is a string, a boolean, an integer, a float or an array of one of these types. Set attributes with `span.set_attribute(key, value)`, or pass a dictionary with the `attributes` argument when the span starts:

```python
with tracer.start_as_current_span("process-order", attributes={"order.items": items}):
    ...
```

The difference matters for sampling. A sampler runs when the span starts and sees only the attributes passed at that moment. If a sampling rule depends on an attribute, pass it at the start. Set the others later, when you know them.

Limits protect the program. The SDK limits the number of attributes per span (128 by default) and the length of a value, and it drops the extra data without an error. Keep values small and useful, and never put secrets or personal data in them.

## Span kind

The `kind` argument states the role of the span: `SpanKind.SERVER` for an incoming request, `CLIENT` for an outgoing call, `PRODUCER` and `CONSUMER` for messages, and `INTERNAL` for work inside the program. If the argument is left out, the kind is `INTERNAL`. The kind of the first span in a service that receives requests should be `SERVER`. The web framework instrumentation does this automatically. In hand-written code, the author must set it.

## A good boundary

Create a span for an operation that someone may want to time or to find in a trace: a request, a call to another service, a database query, a piece of work that can fail. Do not create a span for each loop iteration or for a call that takes microseconds, because the data costs more than it explains. Prefer an attribute or an event on the existing span.

## Read the spans in the playground

<!-- astrona:playground:renew -->

The program in the playground starts a span `process-order` with the kind `SERVER` and a child span `reserve-stock`. Read the spans:

```sh
kubectl -n observability logs deploy/otel-collector --since=60s --tail=-1 | grep -E 'Name  |Kind|Parent ID|order.items' | head -30
```

Find the `process-order` span and check its kind. Find `reserve-stock` and check that its `Parent ID` is the span ID of `process-order`. Then look at the attribute `order.items` on both spans. The program sets it on each span with `set_attribute`.

Print the code of the program to see how the boundaries are written:

```sh
kubectl -n starfleet get configmap orders-app -o jsonpath='{.data.app\.py}'
```

Find the `with` block that starts `process-order` and the function `reserve_stock` that starts the child. Notice that no line passes the parent. The context does that.

## What to take from this

A span starts with `start_as_current_span`, ends when the block ends and becomes the parent of any span started inside it. The name stays low in cardinality, the changing values go into attributes, and the kind states the role. Attributes that a sampler needs belong in the call that starts the span. Next comes what code does when the operation fails.

## Common pitfalls

> [!WARNING]
> Do not start a span with `start_span` and forget to end it, because it is never exported. Do not put an identifier in the span name. Do not set the kind to `INTERNAL` for the first span that handles an incoming request, because the service map then loses the edge.
