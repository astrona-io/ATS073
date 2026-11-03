---
estimated_duration: 30m
---

# Lab: Calculate An SLI And An Error Budget

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

Prometheus scrapes fixed request counters for `bridge`; the learner computes an SLI, an error budget and a verdict. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/module-01/labs/lab-01
astrona destroy ats-073-lab-040-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-environment-intact.sh` | Prometheus is available and reports up for the job bridge |
| `validate-populations-correct.sh` | valid_events and good_events match the defined populations |
| `validate-sli-correct.sh` | sli is the good fraction in percent with two decimals |
| `validate-budget-correct.sh` | The allowed bad events, the consumed percentage and the remaining events are correct |
| `validate-verdict-correct.sh` | slo_target is 99.5 and slo_met states the verdict |

The checks read the collector configuration and the debug exporter output of the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns.
