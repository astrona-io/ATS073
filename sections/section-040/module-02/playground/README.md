# RED, USE And The Four Golden Signals - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-073-playground-040-02
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A single-node kind cluster (Kubernetes 1.35) with Prometheus in `observability`, plus `bridge-metrics` and `shuttle-metrics`, nginx Deployments that each serve a fixed Prometheus text file at `/metrics`. The counters never change, so every query returns the same answer. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-073-playground-040-02
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime, preloaded images, starting manifests) |
| `manifests/observability.yaml` | Prometheus, its configuration and the static metrics server |
| `docs/overview.md` | What the environment contains and ideas to try |
