---
estimated_duration: 25m
---

# Lab: Add Detected Resource Attributes In The Collector

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The Collector adds no host or environment attributes. The learner adds the `resourcedetection` processor and sets the environment name through a variable of the Collector. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/module-03/labs/lab-01
astrona destroy ats-073-lab-020-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-collector-available.sh` | The Collector Deployment is available with its original image |
| `validate-detection-configured.sh` | The traces pipeline lists a resourcedetection processor with env, system and override false |
| `validate-environment-variable-set.sh` | The Collector container has OTEL_RESOURCE_ATTRIBUTES with the environment name staging |
| `validate-attributes-detected.sh` | The exported traces carry host.name, os.type and deployment.environment.name staging |
| `validate-service-name-kept.sh` | The traces keep the service name shuttle |
| `validate-generator-unchanged.sh` | The shuttle-load Deployment still has its original container and image |

The checks read the live cluster. Output of the debug exporter is not a stable format across collector releases, so the checks use loose patterns.
