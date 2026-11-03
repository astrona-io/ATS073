---
estimated_duration: 30m
---

# Lab: Keep Error Traces With Tail Sampling

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The Collector starts with a 10 percent head sampler, so most error traces are lost. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-010/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-010/module-02/labs/lab-01
astrona destroy ats-073-lab-010-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-collector-available.sh` | The Collector Deployment is available with its original image |
| `validate-tail-sampling-configured.sh` | The traces pipeline uses tail_sampling with an ERROR policy and a probabilistic policy, and no head sampler |
| `validate-other-pipelines-intact.sh` | The otlp receiver, the debug exporter and the traces pipeline wiring are intact |
| `validate-errors-kept.sh` | The running Collector exports a large share of error spans |
| `validate-success-traces-reduced.sh` | Successful traces are sampled down |
| `validate-generator-unchanged.sh` | The shuttle-load Deployment still has its two containers and its original image |

The checks read the collector configuration and the debug exporter output of the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns.
