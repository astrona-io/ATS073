# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 2 GiB of free memory.
- `kubectl`.
- You know how to read a ConfigMap and a Deployment, and how to read pod logs with `kubectl logs`.
- The lab pods install the OpenTelemetry Python packages with `pip` when they start, so the cluster needs access to the Python package index. A new pod needs about one minute before it sends telemetry.

The lab starts a single-node kind cluster (Kubernetes 1.35).
