---
draft: true
exam_objectives:
  - Semantic Conventions
---
# Kubernetes, Cloud And Custom Attributes

The attributes of an HTTP request describe one operation. Other attributes describe the place where the program runs: the cluster, the pod, the cloud region. These belong on the resource, because they are the same for every item that the program emits. This part lists the resource conventions for Kubernetes and cloud platforms and shows how to add your own attributes without breaking the standard ones.

## Resource attributes for Kubernetes

A program that runs in Kubernetes can state where it runs with these attributes:

- `k8s.cluster.name`: the name of the cluster.
- `k8s.namespace.name`: the namespace of the pod.
- `k8s.pod.name` and `k8s.pod.uid`: the name and the unique identifier of the pod.
- `k8s.deployment.name`, `k8s.statefulset.name` and `k8s.daemonset.name`: the workload that owns the pod.
- `k8s.node.name`: the node that runs the pod.
- `container.name` and `container.image.name`: the container and its image.

These values change when a pod is replaced, so a pod name is not a good identity for a service. The service identity is `service.name`, and the pod attributes tell which instance sent the data. The `k8sattributes` processor of the Collector can add these attributes by looking up the pod that sent the data in the Kubernetes API. It needs permission to read pods, which a role binding in the cluster grants.

## Resource attributes for cloud and host

Cloud attributes name the provider and the place:

- `cloud.provider`: for example `aws`, `gcp` or `azure`.
- `cloud.platform`, `cloud.region` and `cloud.availability_zone`.
- `cloud.account.id`.
- `host.name`, `host.id` and `host.arch` for a machine.

A **resource detector** collects these values from the environment, for example from the cloud metadata service. The detectors can run in the SDK or in the Collector with the `resourcedetection` processor. A resource attribute applies to everything the process emits, so it is stored once per batch and not once per item.

## Where an attribute belongs

Use one rule to decide the place. If the value is the same for the whole lifetime of the process, it is a resource attribute. If it can change from one operation to the next, it is an attribute of the span, the log record or the metric data point. `k8s.namespace.name` is a resource attribute. `http.request.method` is a span attribute, because one process serves many methods.

A mistake in either direction has a cost. A per-request value on the resource creates a new resource for every request and a new series for every value. A per-process value on every span repeats the same bytes and makes the data larger.

## Custom attributes

When no convention fits, create an attribute in your own namespace and keep to the naming rules. For example, `starfleet.order.id` for an order number and `starfleet.order.items` for an item count. Check the existing conventions first, because a convention may already name the fact. Keep a short list of your own names, with their type, unit and meaning, so that other teams use them the same way. Treat a custom attribute with an unbounded value like any other: keep it off metrics.

## Add and check resource attributes in the playground

<!-- astrona:playground:renew -->

The Collector `resource` processor adds attributes to the resource of every item. Save this as `collector-config.yaml`:

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
      resource:
        attributes:
          - key: k8s.cluster.name
            value: playground
            action: upsert
          - key: starfleet.team
            value: bridge-crew
            action: upsert
    exporters:
      debug:
        verbosity: detailed
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [resource]
          exporters: [debug]
```

Apply it and restart the Collector:

```sh
kubectl apply -f collector-config.yaml
kubectl -n observability rollout restart deployment/otel-collector
kubectl -n observability rollout status deployment/otel-collector
```

Then read the resource attributes of the spans:

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1 | grep -A6 'Resource attributes'
```

Both new attributes appear under `Resource attributes:` next to `service.name`. Notice that `starfleet.team` is in a namespace of its own and `k8s.cluster.name` follows the convention. Decide why a value such as the name of a pod would be a poor value for a hand-written resource attribute: the processor sets one fixed value, and the pod name changes with every replacement.

## What to take from this

Kubernetes and cloud attributes describe the place where the program runs, so they belong on the resource and are best added by the SDK or by a Collector processor that looks the values up. A value that changes per operation belongs on the item. Your own attributes live in your own namespace, are documented and stay off metrics when their values are unbounded.

## Common pitfalls

> [!WARNING]
> Do not use a pod name as the identity of a service. Do not set a per-request value as a resource attribute. Do not put custom attributes in the namespaces `http`, `db`, `k8s` or `otel`.
