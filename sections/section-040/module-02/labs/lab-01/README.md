---
estimated_duration: 30m
---

# Lab: Record RED Signals As Prometheus Rules

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

Prometheus scrapes fixed counters for `bridge` and a fixed histogram for `shuttle`, and it has no rule file. The learner adds three recording rules and makes Prometheus load them. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/module-02/labs/lab-01
astrona destroy ats-073-lab-040-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-environment-intact.sh` | Prometheus is available and reports up for the jobs bridge and shuttle |
| `validate-sources-unchanged.sh` | The fixed metric files and the scrape jobs are unchanged |
| `validate-rules-loaded.sh` | Prometheus has loaded the three recording rules |
| `validate-request-total-correct.sh` | bridge:http_requests:total equals 119240 |
| `validate-error-ratio-correct.sh` | bridge:http_error_ratio:ratio is about 0.004528 |
| `validate-latency-ratio-correct.sh` | The shuttle ratio is 0.92 |

The checks query the Prometheus HTTP API in the live cluster. The expected values come from the fixed metric files.
