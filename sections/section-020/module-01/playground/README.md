# Semantic Conventions And Attribute Meaning - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-073-playground-020-01
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A single-node kind cluster (Kubernetes 1.35) with an OpenTelemetry Collector and the generator `scout-load`. The generator sends spans for the service `scout` with the old attribute names `http.method` and `http.status_code` and with the personal attribute `user.email`. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-073-playground-020-01
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime, preloaded images, starting manifests) |
| `manifests/observability.yaml` | Namespace, Collector configuration, Deployment and Service (a traces pipeline with no processors) |
| `manifests/starfleet.yaml` | The generator |
| `docs/overview.md` | What the environment contains and ideas to try |
