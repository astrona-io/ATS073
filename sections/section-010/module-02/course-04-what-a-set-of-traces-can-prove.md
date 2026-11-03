---
draft: true
exam_objectives:
  - Telemetry Data
---
# What A Set Of Traces Can Prove

A trace view is persuasive. It shows a tree of spans with durations, and it looks like a complete record of one request. But a trace is a recording that depends on instrumentation, on propagation and on sampling. This part lists what can be missing from a trace, and which conclusions are safe from a set of traces.

## What can be missing inside one trace

A trace can be incomplete in four ways:

- **A missing hop.** A service that is not instrumented, or that does not pass the span context on, creates no span and breaks the chain. The next instrumented service starts a new trace with a new trace ID.
- **A missing parent.** The parent span was dropped by a sampler, lost by an exporter queue that overflowed, or not yet received. The backend shows the child as an orphan.
- **A late span.** A tail sampler decides after `decision_wait`. A span that arrives after the decision cannot change it, and the trace is stored without that span or not at all.
- **A wrong order.** Spans carry timestamps from the clock of the machine that created them. When two machines disagree by 50 milliseconds, a child can appear to start before its parent.

A gap inside a trace is therefore evidence about the collection path first. Before blaming the slow service, check that all hops propagate context and that all spans arrived.

## What a set of sampled traces can show

Sampling changes which questions the traces can answer.

- A trace is good evidence of what one request did. A kept trace shows the real sequence and the real durations of its spans.
- The count of kept traces is not the count of requests. With a 10 percent sampler the true number is about ten times larger, and the estimate is rough when the sample is small.
- The share of kept traces that failed is not the failure rate when a policy keeps all errors. A metric that counts every request, computed before sampling, gives the rate.
- A rare event can be absent from a sample. The absence of a trace that contains an error does not show that no request failed.

The rule is to match the question to the signal. Use metrics for totals and rates, and traces for the path and the timing of individual requests. When a trace and a metric disagree, check the sampling configuration first.

## Check what the playground can and cannot show

<!-- astrona:playground:renew -->

Count the spans that the Collector has received in the last 60 seconds:

```sh
kubectl -n observability logs deploy/otel-collector --since=60s --tail=-1 | grep -c 'Span #'
```

Write the number down, then scale the generator that sends traces with children to zero:

```sh
kubectl -n starfleet scale deployment shuttle-load --replicas=0
```

Wait 60 seconds and count again. The number falls, because the spans of `shuttle` stop, but the service itself still exists. The absence of spans shows that nothing is being sent. It does not show that no request reached the service. Restore the generator:

```sh
kubectl -n starfleet scale deployment shuttle-load --replicas=1
```

Now find a trace with more than one span and check that the child span starts after its parent starts and ends before its parent ends:

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1 | grep -E 'Trace ID|Parent ID|Start time|End time' | head -20
```

In this playground, all spans come from one program on one clock, so the order is consistent. Think about what would change if the parent and the child came from two machines.

## What to take from this

A trace proves what happened to one recorded request, if every hop propagated its context and no span was lost. A set of sampled traces does not prove totals, rates or the absence of an event. Decide the question first, then pick the signal and state the sampling that stands behind the answer.

## Common pitfalls

> [!WARNING]
> Do not count sampled traces and report the number as the number of requests. Do not conclude that a service is healthy because no trace with an error is visible. Do not trust the order of spans from different machines without knowing how their clocks are kept in step.
