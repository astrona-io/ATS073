---
estimated_duration: 30m
---

# Lab: Add Pipelines And Resource Identity

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The Collector starts with a traces pipeline only and no resource identity, while the generator sends traces, metrics and logs. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-010/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-073-lab-010-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-collector-available.sh` | The Collector Deployment is available with its original image |
| `validate-pipelines-configured.sh` | Traces, metrics and logs pipelines exist and each uses the resource processor |
| `validate-signals-flowing.sh` | The Collector log shows traces, metrics and logs from the running Collector pod |
| `validate-resource-identity-present.sh` | Every signal carries deployment.environment.name=production and service.namespace=starfleet, and service.name stays bridge |
| `validate-generator-unchanged.sh` | The bridge-load Deployment still has its three containers and its original image |

The checks read the collector configuration and the debug exporter output of the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns.
