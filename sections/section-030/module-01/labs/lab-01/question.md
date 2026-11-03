# Question

Solve this question on: `terminal`

The program `shuttle-orders` in `starfleet` calls the OpenTelemetry API for spans and a counter, and runs under the `opentelemetry-instrument` launcher. Nothing reaches the Collector `otel-collector` in `observability` under a useful name: the exporter protocol is `http/protobuf`, but the endpoint names the gRPC port, and the program has no service name.

Fix the environment of the Deployment. Do not edit the program, the image or the Collector.

1. Make the OTLP endpoint match the protocol `http/protobuf`: the Service `otel-collector` in `observability`, port 4318, with the scheme `http://`.
2. Set the service name to `shuttle-orders`.
3. Set the resource attributes `deployment.environment.name=production` and `service.version=1.4.0`.
4. Wait for the new pod (it installs its packages with `pip` and needs about one minute) and check the Collector output. Spans named `process-order` and the metric `orders.processed` must appear with the service name `shuttle-orders` and both resource attributes.

`kubectl` already points at the cluster.
