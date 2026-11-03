---
draft: true
exam_objectives:
  - Semantic Conventions
---
# Summary

A resource is built when the SDK starts from four sources: defaults, environment variables, code and detectors. `OTEL_SERVICE_NAME` wins over `service.name` in `OTEL_RESOURCE_ATTRIBUTES`. Without a name, the service is `unknown_service`. The instance ID must be unique for each instance, and the environment name is set by the operator.

The `resourcedetection` processor adds attributes from detectors such as `env` and `system`. The setting `override: false` keeps values that the program already sent. A Collector detects the facts of its own host, so the host is correct only when the Collector runs next to the program.

A schema URL on the resource and on the scope states the version of the names. The schema file lists the renames between versions, and a separate tool must apply them. A convention has a stability level: development, release candidate, stable or deprecated. A migration of names uses `OTEL_SEMCONV_STABILITY_OPT_IN` with the value `dup` to emit both spellings while the readers move.

Key facts:

- A per-request value does not belong on the resource.
- `override: false` keeps the value that the program sent.
- A schema URL labels data and does not change it.
- `http/dup` emits old and new HTTP names together.

<!-- astrona:playground:destroy -->
