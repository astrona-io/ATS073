---
estimated_duration: 30m
---

# Lab: Sanitize Database Spans With The Transform Processor

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The generator `harbor-db-load` sends old database attribute names and a literal id in the query text; the Collector must rename and sanitize them. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/module-02/labs/lab-01
astrona destroy ats-073-lab-020-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-collector-available.sh` | The Collector Deployment is available with its original image |
| `validate-transform-used.sh` | The traces pipeline lists the transform processor with a replace_pattern statement |
| `validate-new-names-present.sh` | Spans carry db.system.name, db.namespace and db.query.text |
| `validate-old-names-absent.sh` | Spans no longer carry db.system, db.name or db.statement |
| `validate-query-sanitized.sh` | The query text shows id = ? and never id = 42 |
| `validate-identity-kept.sh` | service.name stays harbor and the generator is unchanged |

The checks read the collector configuration and the debug exporter output of the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns.
