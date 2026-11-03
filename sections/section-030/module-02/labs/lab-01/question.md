# Question

Solve this question on: `terminal`

The program `shuttle-orders` in `starfleet` calls the OpenTelemetry API and runs under the `opentelemetry-instrument` launcher. Its code is the key `app.py` of the ConfigMap `orders-app`. The environment variables are correct and the spans and the counter reach the Collector `otel-collector` in `observability`, but the instrumentation in the code has three defects.

Change only the code in the ConfigMap `orders-app` and restart the Deployment. Do not change the Deployment, the Collector or the tracer name `starfleet.orders`.

1. The span `process-order` is the first span that handles an order. Give it the kind `SERVER`.
2. About one order in five is rejected because `reserve_stock` raises a `ValueError`, and the code catches it. Record the exception on the span `process-order` with `record_exception`, and set the status of that span to `ERROR` with the message of the exception.
3. Create a histogram `orders.duration` with the unit `s` and record the elapsed time of each loop with the attribute `order.outcome`, using the same values as the counter.
4. Restart the Deployment `shuttle-orders` so that the pod reads the new code. The pod installs its packages at start, so the first output needs about a minute.

`kubectl` already points at the cluster.
