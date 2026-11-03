---
estimated_duration: 30m
---

# Lab: Align Attributes With Semantic Conventions

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The generator `scout-load` sends old HTTP attribute names and a personal attribute; the Collector must normalize them. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/module-01/labs/lab-01
astrona destroy ats-073-lab-020-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-collector-available.sh` | The Collector Deployment is available with its original image |
| `validate-new-names-present.sh` | Spans carry http.request.method=GET and http.response.status_code=200 with the integer type |
| `validate-old-names-absent.sh` | Spans no longer carry http.method or http.status_code |
| `validate-personal-data-removed.sh` | Spans do not carry user.email |
| `validate-identity-kept.sh` | service.name stays scout and the generator is unchanged |

The checks read the collector configuration and the debug exporter output of the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns.
