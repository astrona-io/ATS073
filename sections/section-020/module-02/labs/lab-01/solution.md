# Solution

The `transform` processor runs OpenTelemetry Transformation Language (OTTL) statements on every span. The statements run in the order in which they are listed, so the copies must come before the deletes, and the sanitizing must come after the copy that creates `db.query.text`. The Collector reads its configuration once at start, so the fix is a changed ConfigMap and a restart.

## Step 1: read the current output

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1 | grep -E '^ +-> db\.'
```

You see `db.system`, `db.name` and `db.statement`, and the statement holds `id = 42`.

## Step 2: replace the configuration

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
      transform:
        error_mode: ignore
        trace_statements:
          - context: span
            statements:
              - set(attributes["db.system.name"], attributes["db.system"])
              - set(attributes["db.namespace"], attributes["db.name"])
              - set(attributes["db.query.text"], attributes["db.statement"])
              - replace_pattern(attributes["db.query.text"], "= [0-9]+", "= ?")
              - delete_key(attributes, "db.system")
              - delete_key(attributes, "db.name")
              - delete_key(attributes, "db.statement")
    exporters:
      debug:
        verbosity: detailed
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [transform]
          exporters: [debug]
```

Apply it:

```sh
kubectl apply -f collector-config.yaml
```

## Step 3: restart the Collector

```sh
kubectl -n observability rollout restart deployment/otel-collector
kubectl -n observability rollout status deployment/otel-collector
```

## Step 4: check the output

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1 | grep -E '^ +-> db\.'
```

Each span now has `db.system.name`, `db.namespace` and `db.query.text` with the text `SELECT * FROM orders WHERE id = ?`, and the old names are gone. Submit the lab with `astrona submit`. If one check fails, wait 30 seconds and submit again, because the checks read the last 120 seconds of output.
