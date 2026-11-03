---
estimated_duration: 30m
---

# Lab: Analysis And Outcomes Capstone

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The learner repairs a scrape job, computes a latency SLI from histogram buckets and records a data gap as no data. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/capstone/labs/lab-01
astrona destroy ats-073-capstone-040
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-prometheus-intact.sh` | Prometheus is available with its image and still scrapes bridge |
| `validate-scout-scraped.sh` | Prometheus reports up == 1 for the job scout |
| `validate-probe-job-kept.sh` | The job probe is still configured and has no series |
| `validate-latency-sli-correct.sh` | requests_total, under_300ms and latency_sli match the histogram |
| `validate-verdict-and-gap-recorded.sh` | slo_target is 95, slo_met is correct and probe_status is no-data |

The checks read the collector configuration and the debug exporter output of the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns.
