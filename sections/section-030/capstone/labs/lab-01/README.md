---
estimated_duration: 30m
---

# Lab: Instrumentation Capstone

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

Three programs share one instrumented code base and have three different delivery mistakes. The pods install packages when they start. Wait about two minutes after a change. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-030/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-030/capstone/labs/lab-01
astrona destroy ats-073-capstone-030
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-collector-available.sh` | The Collector Deployment is available with its original image |
| `validate-programs-unchanged.sh` | The three Deployments keep their image and code |
| `validate-scout-api-delivers.sh` | scout-api sends spans under its own service name |
| `validate-scout-worker-delivers.sh` | scout-worker sends spans |
| `validate-probe-batch-delivers.sh` | probe-batch sends spans |
| `validate-environment-set.sh` | All three services carry deployment.environment.name=production on the resource |
| `validate-review-recorded.sh` | The ConfigMap instrumentation-review names the cause for each program |

The checks read the collector configuration and the debug exporter output of the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns.
