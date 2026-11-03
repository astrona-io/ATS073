---
estimated_duration: 30m
---

# Lab: Semantic Conventions Capstone

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

Three services need current names, no personal data, a bounded metric dimension and the environment on the resource. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/capstone/labs/lab-01
astrona destroy ats-073-capstone-020
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-collector-available.sh` | The Collector Deployment is available with its original image |
| `validate-traces-normalized.sh` | Spans use the current HTTP names and carry no user.email |
| `validate-logs-clean.sh` | Log records carry no user.email |
| `validate-metrics-bounded.sh` | Metric data points carry no customer.id |
| `validate-environment-on-resource.sh` | Every signal carries deployment.environment.name=production on the resource and keeps its service.name |
| `validate-review-recorded.sh` | The ConfigMap semconv-review records what you renamed, removed and which key is a resource attribute |
| `validate-generators-unchanged.sh` | The three generators are unchanged |

The checks read the collector configuration and the debug exporter output of the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns.
