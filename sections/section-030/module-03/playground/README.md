# Zero-Code Instrumentation, Propagators And Baggage - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-073-playground-030-03
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A single-node kind cluster (Kubernetes 1.35) with an OpenTelemetry Collector and two Python services under `opentelemetry-instrument`. The client calls the billing server every second and sends the baggage key `customer.tier`. Both use `tracecontext,baggage`, so the traces are connected. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-073-playground-030-03
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime, preloaded images, starting manifests) |
| `manifests/observability.yaml` | The Collector with a traces pipeline and the `debug` exporter |
| `manifests/starfleet.yaml` | The Deployments `shuttle-client` and `shuttle-billing`, the Service `shuttle-billing` and the ConfigMap `billing-apps` with both programs |
| `docs/overview.md` | What the environment contains and ideas to try |
