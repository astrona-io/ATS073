# Question

Solve this question on: `terminal`

The Deployment `shuttle-client` in `starfleet` calls the Service `shuttle-billing` every second. Both run under zero-code instrumentation and send spans to the Collector `otel-collector` in `observability`, which prints them in its log.

The server spans do not belong to the traces of the client spans: the server spans have no parent and have different trace IDs. The client also sends the baggage key `customer.tier`, and the server spans should show it as the attribute `customer.tier` with the value `gold`.

Find the cause and repair it:

1. Find the setting on the Deployment `shuttle-billing` that stops the context from being read.
2. Set it so that the server reads the W3C trace context and the baggage.
3. Make the server run with the new setting.

Do not change the Deployment `shuttle-client`, the ConfigMap `billing-apps` or the Collector. `kubectl` already points at the cluster.
