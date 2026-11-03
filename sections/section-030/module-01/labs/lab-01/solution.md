# Solution

The program only calls the API. The launcher `opentelemetry-instrument` builds the SDK and the exporters from environment variables when the process starts. A wrong variable therefore breaks delivery without any change to the program.

## Step 1: read the environment

```sh
kubectl -n starfleet get deployment shuttle-orders -o jsonpath='{.spec.template.spec.containers[0].env}'
```

`OTEL_EXPORTER_OTLP_PROTOCOL` is `http/protobuf`, and `OTEL_EXPORTER_OTLP_ENDPOINT` ends in `:4317`. The Collector receives OTLP over HTTP on 4318 and over gRPC on 4317, so an HTTP request to 4317 fails. No service name is set, so the SDK uses an `unknown_service` name.

## Step 2: set the variables

```sh
kubectl -n starfleet set env deployment/shuttle-orders \
  OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector.observability:4318 \
  OTEL_SERVICE_NAME=shuttle-orders \
  OTEL_RESOURCE_ATTRIBUTES=deployment.environment.name=production,service.version=1.4.0
kubectl -n starfleet rollout status deployment/shuttle-orders
```

Changing the environment creates a new pod. The pod installs the packages with `pip` and then starts the program.

## Step 3: check the Collector output

Wait about a minute, then run:

```sh
kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1
```

A `ResourceSpans` block lists `service.name: Str(shuttle-orders)`, `deployment.environment.name: Str(production)` and `service.version: Str(1.4.0)`, with spans named `process-order` and `reserve-stock`. A `ResourceMetrics` block shows the metric `orders.processed`. The other valid fix is the gRPC pair: protocol `grpc` with the endpoint on port 4317.

Submit with `astrona submit`.
