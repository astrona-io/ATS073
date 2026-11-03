---
estimated_duration: 30m
---

# Lab: Configure The SDK With Environment Variables

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The program `shuttle-orders` is instrumented, but its exporter points at the wrong port and its telemetry has no service name. The pods install packages when they start. Wait about two minutes after a change. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-030/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-030/module-01/labs/lab-01
astrona destroy ats-073-lab-030-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-collector-available.sh` | The Collector Deployment is available with its original image |
| `validate-program-unchanged.sh` | shuttle-orders keeps its image and the orders-app code |
| `validate-spans-arrive-named.sh` | Spans arrive with service.name shuttle-orders and the span name process-order |
| `validate-metrics-arrive.sh` | The counter orders.processed arrives for shuttle-orders |
| `validate-resource-attributes-set.sh` | The resource carries deployment.environment.name=production and service.version=1.4.0 |

The checks read the collector configuration and the debug exporter output of the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns.
