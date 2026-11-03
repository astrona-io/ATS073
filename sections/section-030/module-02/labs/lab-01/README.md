---
estimated_duration: 30m
---

# Lab: Fix Manual Instrumentation In Code

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The program `shuttle-orders` calls the OpenTelemetry API, but its spans have the wrong kind, a rejected order is not recorded on the span, and the duration histogram is missing. The pod installs packages when it starts. Wait about two minutes after a change. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-030/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-030/module-02/labs/lab-01
astrona destroy ats-073-lab-030-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-collector-available.sh` | The Collector Deployment is available with its original image |
| `validate-program-unchanged.sh` | The Deployment keeps its image, its launcher and the tracer scope |
| `validate-server-kind.sh` | process-order spans have the kind Server |
| `validate-failure-recorded.sh` | A process-order span has the status Error and an exception event |
| `validate-histogram-arrives.sh` | The metric orders.duration arrives as a histogram with the unit s and the attribute order.outcome |

The checks read the debug exporter output of the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns. The pod installs its packages with pip at start, so the first output needs about a minute.
