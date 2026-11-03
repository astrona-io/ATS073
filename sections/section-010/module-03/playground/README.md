# Metrics, Logs, Events And Profiles In Depth - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-073-playground-010-03
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A single-node kind cluster (Kubernetes 1.35) with an OpenTelemetry Collector and the Deployment `shuttle-load`, whose containers send traces, a sum, a gauge and logs at the levels Info, Debug and Error. The `debug` exporter prints everything to the Collector log. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-073-playground-010-03
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime, preloaded images, starting manifests) |
| `manifests/observability.yaml` | The Collector with traces, metrics and logs pipelines |
| `manifests/starfleet.yaml` | Generators for traces, metrics and logs at three levels |
| `docs/overview.md` | What the environment contains and ideas to try |
