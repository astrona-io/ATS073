# Manual Instrumentation With The API - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-073-playground-030-02
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A single-node kind cluster (Kubernetes 1.35) with an OpenTelemetry Collector and `shuttle-orders`, a Python program that uses the OpenTelemetry API by hand: a server span with a child span, span attributes, an exception event, an error status, a counter, an up-down counter and a histogram. The `opentelemetry-instrument` launcher installs the SDK from environment variables. Pods install their packages with `pip` at start, so the cluster needs internet access. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-073-playground-030-02
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime, preloaded images, starting manifests) |
| `manifests/observability.yaml` | Collector with traces and metrics pipelines |
| `manifests/starfleet.yaml` | The program in a ConfigMap and its Deployment |
| `docs/overview.md` | What the environment contains and ideas to try |
