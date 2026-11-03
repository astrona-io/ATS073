---
estimated_duration: 30m
---

# Lab: Write Burn-Rate Alerts For The Bridge

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

Prometheus has no rule file. The learner adds two burn-rate alerts for the bridge, loads them, and checks that the slow burn fires and the fast burn does not. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/module-03/labs/lab-01
astrona destroy ats-073-lab-040-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-prometheus-intact.sh` | Prometheus is intact and scrapes bridge and shuttle |
| `validate-sources-unchanged.sh` | The fixed metric files and the scrape jobs are unchanged |
| `validate-alert-rules-loaded.sh` | Prometheus has loaded BridgeSlowBurn and BridgeFastBurn with severity labels and a summary |
| `validate-slow-burn-firing.sh` | BridgeSlowBurn is firing |
| `validate-fast-burn-quiet.sh` | BridgeFastBurn is not firing |

The checks read the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns.
