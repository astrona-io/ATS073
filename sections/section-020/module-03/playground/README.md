# Resource Detection, Schema URLs And Stability - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-073-playground-020-03
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A single-node kind cluster (Kubernetes 1.35) with an OpenTelemetry Collector and a trace generator. The Collector Deployment sets `OTEL_RESOURCE_ATTRIBUTES` to `deployment.environment.name=playground`, and no processor uses it at the start. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-073-playground-020-03
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime, preloaded images, starting manifests) |
| `manifests/observability.yaml` | The Collector, its configuration and the environment variable `OTEL_RESOURCE_ATTRIBUTES` |
| `manifests/starfleet.yaml` | A trace generator for the service `shuttle` |
| `docs/overview.md` | What the environment contains and ideas to try |
