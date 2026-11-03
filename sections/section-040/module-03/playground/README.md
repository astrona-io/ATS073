# Alerting And Burn-Rate - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-073-playground-040-03
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A single-node kind cluster (Kubernetes 1.35) with a Prometheus server and two services that expose fixed counters. Prometheus has no rule file. The bridge has 540 responses with a 5xx code out of 119240. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-073-playground-040-03
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime, preloaded images, starting manifests) |
| `manifests/observability.yaml` | Prometheus with the config in the ConfigMap `prometheus-config`, and the services `bridge-metrics` and `shuttle-metrics` with fixed counters |
| `docs/overview.md` | What the environment contains and ideas to try |
