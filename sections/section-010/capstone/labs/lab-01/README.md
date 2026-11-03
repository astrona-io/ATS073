---
estimated_duration: 30m
---

# Lab: Telemetry Data Capstone

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The Collector drops the metrics of `bridge` and adds no resource identity; the learner repairs the pipelines, samples traces only and records evidence. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-010/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-010/capstone/labs/lab-01
astrona destroy ats-073-capstone-010
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-collector-available.sh` | The Collector Deployment is available with its original image |
| `validate-pipelines-complete.sh` | Traces, metrics and logs pipelines exist and use the resource processor |
| `validate-sampler-on-traces-only.sh` | probabilistic_sampler at 25 percent runs in the traces pipeline and in no other pipeline |
| `validate-signals-flowing.sh` | Spans, metrics and log records reach the debug exporter of the running pod |
| `validate-resource-identity-present.sh` | Every signal carries deployment.environment.name=production and service.namespace=starfleet |
| `validate-evidence-recorded.sh` | The ConfigMap telemetry-evidence records the signals, the missing signal, the sampled signal and the percentage |
| `validate-generators-unchanged.sh` | Both load generators are unchanged |

The checks read the collector configuration and the debug exporter output of the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns.
