# Solution

Each defect is a missing call in the code. The kind defaults to `INTERNAL` when it is not passed. An exception that the code catches inside the span block is hidden from the context manager, so the code must record it and set the status. A metric exists only when code creates an instrument and records into it. The pod reads the code once at start, so the fix is a changed ConfigMap and a restart.

## Step 1: read the current code

```sh
kubectl -n starfleet get configmap orders-app -o jsonpath='{.data.app\.py}'
```

You see `start_as_current_span("process-order")` without a kind, an `except ValueError` that only sets `outcome`, and no histogram.

## Step 2: replace the code

Save this as `orders-app.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: orders-app
  namespace: starfleet
data:
  app.py: |
    import os
    import random
    import time

    from opentelemetry import metrics, trace
    from opentelemetry.trace import SpanKind, Status, StatusCode

    tracer = trace.get_tracer("starfleet.orders", "1.4.0")
    meter = metrics.get_meter("starfleet.orders", "1.4.0")
    processed = meter.create_counter("orders.processed", unit="{order}", description="Orders processed")
    duration = meter.create_histogram("orders.duration", unit="s", description="Time to process an order")


    def reserve_stock(items):
        with tracer.start_as_current_span("reserve-stock") as span:
            span.set_attribute("order.items", items)
            if items > 4:
                raise ValueError("not enough stock")
            time.sleep(0.05)


    while True:
        items = random.randint(1, 5)
        started = time.monotonic()
        with tracer.start_as_current_span("process-order", kind=SpanKind.SERVER) as span:
            span.set_attribute("order.items", items)
            try:
                reserve_stock(items)
                outcome = "accepted"
            except ValueError as error:
                span.record_exception(error)
                span.set_status(Status(StatusCode.ERROR, str(error)))
                outcome = "rejected"
        processed.add(1, {"order.outcome": outcome})
        duration.record(time.monotonic() - started, {"order.outcome": outcome})
        time.sleep(1)
```

Apply it:

```sh
kubectl apply -f orders-app.yaml
```

## Step 3: restart the Deployment

```sh
kubectl -n starfleet rollout restart deployment/shuttle-orders
kubectl -n starfleet rollout status deployment/shuttle-orders
```

## Step 4: check the output

Wait about two minutes, then read the Collector output:

```sh
kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1 | grep -E 'Kind|Status code|-> Name: (exception|orders)'
```

You see `Kind` `Server` for `process-order`, spans with the status `Error`, the event `exception` and the metric `orders.duration`. Submit the lab with `astrona submit`. About one order in five is rejected, so if the check for the failure fails, wait a minute and submit again.
