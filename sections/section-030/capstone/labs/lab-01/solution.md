# Solution

Read the environment of each Deployment first. The three causes are in the variables.

```sh
for name in scout-api scout-worker probe-batch; do
  echo "$name"
  kubectl -n starfleet get deployment "$name" -o jsonpath='{.spec.template.spec.containers[0].env}'
  echo
done
```

`scout-api` sets the protocol `http/protobuf` but points at port 4317, the gRPC port, and has no `OTEL_SERVICE_NAME`. `scout-worker` sets `OTEL_SDK_DISABLED=true`, which turns the SDK off, so the API calls do nothing. `probe-batch` sets `OTEL_TRACES_SAMPLER=always_off`, which drops every trace before it reaches the exporter.

## Step 1: fix the variables

```sh
kubectl -n starfleet set env deployment/scout-api \
  OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector.observability:4318 \
  OTEL_SERVICE_NAME=scout-api \
  OTEL_RESOURCE_ATTRIBUTES=deployment.environment.name=production
kubectl -n starfleet set env deployment/scout-worker OTEL_SDK_DISABLED- \
  OTEL_RESOURCE_ATTRIBUTES=deployment.environment.name=production
kubectl -n starfleet set env deployment/probe-batch OTEL_TRACES_SAMPLER=always_on \
  OTEL_RESOURCE_ATTRIBUTES=deployment.environment.name=production
```

The trailing `-` after `OTEL_SDK_DISABLED` removes the variable. Setting it to `false` also works. Another valid sampler value is `parentbased_always_on`.

## Step 2: wait and check

```sh
for name in scout-api scout-worker probe-batch; do
  kubectl -n starfleet rollout status "deployment/$name"
done
kubectl -n observability logs deploy/otel-collector --since=120s --tail=-1
```

Each service name appears with its spans and with `deployment.environment.name: Str(production)`.

## Step 3: record the causes

Save this as `instrumentation-review.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: instrumentation-review
  namespace: starfleet
data:
  scout-api: "wrong-endpoint-port"
  scout-worker: "sdk-disabled"
  probe-batch: "sampler-always-off"
```

```sh
kubectl apply -f instrumentation-review.yaml
```

Submit with `astrona submit`.
