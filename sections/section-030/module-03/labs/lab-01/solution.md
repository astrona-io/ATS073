# Solution

The server cannot extract the trace context when its propagator list is `none`. The client injects a correct `traceparent` header, and the server ignores it.

## Step 1: confirm the symptom

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1 | grep -E 'Trace ID|Parent ID|Kind'
```

The spans with the kind Server have an empty parent ID, and their trace IDs differ from those of the spans with the kind Client.

## Step 2: read the server variables

```sh
kubectl -n starfleet get deployment shuttle-billing -o jsonpath='{.spec.template.spec.containers[0].env}'
```

`OTEL_PROPAGATORS` has the value `none`.

## Step 3: set the default list

```sh
kubectl -n starfleet set env deployment/shuttle-billing OTEL_PROPAGATORS=tracecontext,baggage
kubectl -n starfleet rollout status deployment/shuttle-billing --timeout=300s
```

The change creates a new pod. It installs its packages first, so it needs about a minute.

## Step 4: check the result

Wait about 30 seconds, then read the log again:

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1 | grep -E 'Trace ID|Parent ID|Kind|customer.tier'
```

The server spans now have a parent ID, share a trace ID with the client spans, and show `customer.tier: Str(gold)`. Submit the lab with `astrona submit`.
