# Curriculum Coverage

Exam: OpenTelemetry Certified Associate (OTCA). Domain: Fundamentals of Observability (18%).

Verified against the [official objectives](https://training.linuxfoundation.org/certification/opentelemetry-certified-associate-otca/) on 2026-10-11. Module titles and questions are original teaching material, not official exam questions.

| Section | Official objective | Modules | Status |
| --- | --- | --- | --- |
| 010 | Telemetry Data | 2 + capstone | Built; labs untested |
| 020 | Semantic Conventions | 2 + capstone | Built; labs untested |
| 030 | Instrumentation | 2 + capstone | Built; labs untested |
| 040 | Analysis and Outcomes | 2 + capstone | Built; labs untested |

| Section / module | Module | Teaching lessons | Measurable outcomes |
| --- | --- | --- | --- |
| 010 / 01 | Telemetry Signals, Resource Identity And Evidence Limits | 3 | Describe the fields of a metric data point, a span and a log record.; Explain resource identity, instrumentation scope and trace correlation.; Read Collector `debug` exporter output and add a missing pipeline and resource attributes.; Explain how sampling and collection gaps limit what telemetry proves. |
| 010 / 02 | Traces In Depth: Spans, Context And Sampling Decisions | 4 | Explain span context and the parent-child structure.; Choose span kind, status, events and links.; Configure tail sampling in a Collector.; State what sampled traces can and cannot prove. |
| 020 / 01 | Semantic Conventions, Attribute Meaning And Stability | 3 | Explain a semantic convention as a contract on names, types, units and requirement levels.; Place an attribute on the resource or on the operation.; Rename, copy and delete attributes in a Collector and explain why the order matters.; Reason about stability, cardinality and privacy of attributes. |
| 020 / 02 | Semantic Conventions By Signal And Domain | 4 | Apply naming rules and requirement levels.; Use the HTTP, database, messaging, Kubernetes and cloud conventions.; Rename and sanitize attributes with the transform processor.; Keep custom attributes in a team namespace. |
| 030 / 01 | API Calls, Automatic Instrumentation And Measurement Design | 3 | Explain the roles of the API, the SDK and an exporter.; Distinguish manual from automatic instrumentation.; Configure a program with the `OTEL_*` environment variables.; Choose measurements that are useful, small and free of sensitive values. |
| 030 / 02 | Manual Instrumentation With The API | 4 | Get a tracer and a meter and explain the instrumentation scope.; Create spans with attributes and kind.; Record exceptions and set the span status.; Create and use metric instruments. |
| 040 / 01 | Service Indicators, Objectives, Agreements And Budgets | 4 | Distinguish an SLI, an SLO and an SLA and define good and valid events.; Calculate an error budget and a burn rate.; Build a latency SLI from a histogram and check scrape health.; Explain how dashboards show population, units and gaps, and tell a gap from a measured zero. |
| 040 / 02 | RED, USE And The Four Golden Signals | 4 | Describe RED, USE and the golden signals.; Choose the method that fits a component.; Write PromQL for each signal.; Add and load Prometheus recording rules. |

AUTHORING.yaml records measurable goals and adaptation sources. Every objective keeps its section ID. All technical readings remain draft. The labs and playgrounds have static checks only and have not been run.
