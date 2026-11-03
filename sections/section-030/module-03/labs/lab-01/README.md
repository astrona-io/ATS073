---
estimated_duration: 30m
---

# Lab: Repair A Broken Trace Between Two Services

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The billing server has its propagators turned off, so every server span starts a new trace. The learner finds the cause and restores propagation with the default format. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-030/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-030/module-03/labs/lab-01
astrona destroy ats-073-lab-030-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-collector-available.sh` | The Collector Deployment is available with its original image |
| `validate-propagators-set.sh` | The server propagators include tracecontext and baggage |
| `validate-trace-connected.sh` | A server span shares its trace ID with a client span and has a parent |
| `validate-baggage-arrives.sh` | The server spans carry customer.tier gold |
| `validate-workloads-unchanged.sh` | The client and the server keep their images and the client keeps its propagators |

The checks read the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns.
