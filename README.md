# Fundamentals of Observability (ATS073)

OpenTelemetry Certified Associate (OTCA): Fundamentals of Observability, worth 18% of the official curriculum. This course is part of ATP015.

Concept lessons explain each official objective through mechanisms, diagrams and worked examples. Every module has a playground (a clean kind cluster to explore), a graded lab and a summary. Every section ends with a capstone lab and a knowledge check. A final knowledge check closes the course.

## Course Outline

| Section | Objective | Modules | Tools used in the labs |
| --- | --- | --- | --- |
| 010 | Telemetry Data | 2 + capstone | OpenTelemetry Collector, `telemetrygen`, `debug` exporter, `tail_sampling` processor |
| 020 | Semantic Conventions | 2 + capstone | Collector `attributes` and `transform` processors |
| 030 | Instrumentation | 2 + capstone | `opentelemetry-instrument`, `OTEL_*` environment variables, OpenTelemetry Python API |
| 040 | Analysis and Outcomes | 2 + capstone | Prometheus, PromQL, recording rules |

See [the curriculum map](CURRICULUM.md) for module outcomes. The manifest `astrona.yaml` registers readings, labs and quizzes in teaching order.

## Authoring Status

Readings are drafts for review. The playgrounds and labs are built untested: only static checks were run (`astrona validate -c`, `bash -n`, YAML parsing). Every lab README says UNTESTED. Technical sections and the ATP015 registration remain draft until the maintainer approves publication.

## Run A Lab

```sh
astrona run -c sections/section-010/module-01/labs/lab-01
astrona submit -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-073-lab-010-01
```

Playgrounds are started the same way with `astrona run -c <playground dir>`.

## Sources And Contributions

Author references are recorded in [SOURCES.md](SOURCES.md). Report corrections through this repository's issues. The material uses the repository license.
