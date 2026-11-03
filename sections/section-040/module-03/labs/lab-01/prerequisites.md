# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 2 GiB of free memory.
- `kubectl`.
- You know how to edit a ConfigMap and restart a Deployment.
- You know the PromQL operators `sum`, `/` and `>`.
- You know what an error budget and a burn rate are.

The lab starts a single-node kind cluster (Kubernetes 1.35).
