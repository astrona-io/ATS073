---
draft: true
exam_objectives:
- Instrumentation
---
# API Calls, Automatic Instrumentation And Measurement Design

Instrumentation is the code or mechanism that turns application activity into telemetry. Manual instrumentation uses an API at places where the application can explain meaningful work. Automatic instrumentation attaches supported hooks to frameworks, libraries or runtimes. Both approaches are useful, but they answer different coverage needs and require compatible configuration.

An API defines what an instrumented library can call. An SDK supplies the implementation that records, processes and exports the resulting data. This separation allows a reusable library to depend on telemetry interfaces without choosing an organization's exporter or sampling policy. If no appropriate SDK implementation is installed and configured, API calls do not by themselves establish a working telemetry pipeline.

Automatic instrumentation can provide operations such as incoming HTTP requests, outgoing client calls or database activity where the language and library support them. Coverage depends on the actual runtime, dependency versions and initialization sequence. An unsupported client library does not become instrumented merely because an agent is enabled. A hook initialized too late can miss behavior that happened before it attached.

Manual instrumentation adds application meaning. A checkout service may need a span around inventory reservation or a counter for a business rejection reason. Those boundaries are not necessarily visible to generic HTTP instrumentation. The application author should choose names and outcomes that remain useful across releases rather than copying internal implementation details into every telemetry field.

Consider a request that calls a database twice. Automatic client instrumentation may already record both database operations. Adding manual spans around the whole reservation decision can provide useful business context. Adding duplicate spans around the exact same low-level calls can instead make the trace harder to read and inflate volume. The goal is complementary meaning, not the largest possible number of spans.

Instrumentation should preserve active context when work crosses function and task boundaries. A manually created child span needs the correct parent context to belong to the intended request. Recording an independent span after losing context can make related work appear unrelated. The exporter cannot always reconstruct that relationship later because the causal identifier was never attached at the source.

Measurement design also needs consistent populations. A request-duration instrument should define whether it includes failed requests, cancellations and retries. A business outcome counter should avoid conflating one user operation with several internal attempts. Otherwise a dashboard can show apparently precise values whose denominator differs from the question being asked.

Privacy and cost belong to the design. Request payloads, tokens and unrestricted customer identifiers should not be collected simply because a hook can access them. Attributes need useful bounded dimensions where they become metric labels. Span events and log bodies need appropriate access and retention controls. Source-side minimization reduces the data sent through every later component.

Initialization and shutdown affect delivery. The SDK should be configured before the relevant application work begins. Buffered exporters need appropriate flush or shutdown behavior when the process ends. A short-lived process can perform work and exit before queued telemetry is delivered. That is a lifecycle issue rather than proof that the API call never executed.

Useful review follows one operation from its instrumentation boundary through context, SDK processing and export. It identifies what is observed, what is excluded and which automatic hooks overlap with manual code. This produces evidence students can reason about without claiming that enabling instrumentation magically explains every business failure.

## Common pitfalls

> [!WARNING]
> Enabling automatic instrumentation is not proof of complete coverage. Avoid duplicate boundaries, sensitive payload capture and inconsistent measurement populations. The API, SDK initialization, context and exporter lifecycle all contribute to whether a useful observation reaches analysis.
