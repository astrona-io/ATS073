# Traces In Depth - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-073-playground-010-02
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A single-node kind cluster (Kubernetes 1.35) with an OpenTelemetry Collector in `observability` and three `telemetrygen` load generators in `starfleet`: `bridge-load` (traces, metrics and logs for `bridge`), `probe-load` (traces for `probe`) and `shuttle-load` (successful traces with two child spans and failed traces, both for `shuttle`). Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-073-playground-010-02
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime, preloaded images, starting manifests) |
| `manifests/observability.yaml` | Namespace, Collector configuration, Deployment and Service |
| `manifests/starfleet.yaml` | The three load generators |
| `docs/overview.md` | What the environment contains and ideas to try |
