# Solution

The `env` detector reads the variable of the Collector process, and the `system` detector reads the host name and the operating system. The setting `override: false` keeps the values that the program sent.

## Step 1: read the current configuration

```sh
kubectl -n observability get configmap otel-collector-config -o jsonpath='{.data.collector\.yaml}'
```

The pipeline has no processors.

## Step 2: add the processor

Save this as `collector-config.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: otel-collector-config
  namespace: observability
data:
  collector.yaml: |
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
    processors:
      resourcedetection:
        detectors: [env, system]
        override: false
        system:
          hostname_sources: ["os"]
    exporters:
      debug:
        verbosity: detailed
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [resourcedetection]
          exporters: [debug]
```

Apply it:

```sh
kubectl apply -f collector-config.yaml
```

## Step 3: set the variable

Changing the environment of the Deployment starts a new pod, which also reads the new configuration:

```sh
kubectl -n observability set env deployment/otel-collector OTEL_RESOURCE_ATTRIBUTES=deployment.environment.name=staging
kubectl -n observability rollout status deployment/otel-collector
```

## Step 4: check the output

Wait about 30 seconds, then read the resource attributes:

```sh
kubectl -n observability logs deploy/otel-collector --since=20s --tail=-1 | grep -E 'host.name|os.type|deployment.environment.name|service.name'
```

You see the host name, `os.type`, `deployment.environment.name` with the value `staging` and `service.name` with the value `shuttle`. Submit the lab with `astrona submit`.
