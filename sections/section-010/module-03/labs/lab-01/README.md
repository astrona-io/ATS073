---
estimated_duration: 25m
---

# Lab: Filter Debug Logs In The Collector

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The Collector passes Debug logs to the exporter together with the Info logs. The learner drops the Debug records with a `filter` processor. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-010/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-010/module-03/labs/lab-01
astrona destroy ats-073-lab-010-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-collector-available.sh` | The Collector Deployment is available with its original image |
| `validate-filter-configured.sh` | The logs pipeline lists a filter processor that tests the severity |
| `validate-pipelines-intact.sh` | The receiver, the exporter and the traces pipeline are intact |
| `validate-debug-logs-dropped.sh` | The running Collector exports no Debug log records |
| `validate-info-logs-kept.sh` | Info log records are still exported |
| `validate-generator-unchanged.sh` | The shuttle-logs Deployment still has its two containers and its original image |

The checks read the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns.
