---
draft: true
exam_objectives:
  - Telemetry Data
---
# Section 010: Telemetry Data

This section teaches you what the three OpenTelemetry signals record, how a piece of telemetry says which thing produced it, and what the data can and cannot prove. You will read the output of an OpenTelemetry Collector, then change its pipelines and its resource attributes in a running cluster.

**Exam objective covered:** Telemetry Data

---

## What You Will Master

- Describe the fields of a metric data point, a span and a log record, and name the question each signal answers best.
- Explain resource identity and instrumentation scope, and how a trace identifier links a log record to a span.
- Read the `debug` exporter output of a Collector and find the signal, the resource attributes and the items.
- Add a pipeline for a missing signal and set resource attributes with the `resource` processor.
- Explain how sampling, cardinality and collection gaps limit what telemetry proves.

---

## The Learning Path

### 1. Telemetry Signals, Resource Identity And Evidence Limits
*   **Module Reader:** **Module 1: Telemetry Signals, Resource Identity And Evidence Limits**
*   **Hands-on Playground:** `sections/section-010/module-01/playground` - kind cluster with an OpenTelemetry Collector in `observability` and two `telemetrygen` load generators in `starfleet`. Nothing to submit.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-010/module-01/playground
    ```
*   **Lab:** `sections/section-010/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-010/module-01/labs/lab-01
    astrona submit -c .
    ```

### Section Capstone Challenge
*   **Comprehensive Challenge:** Telemetry Data Capstone - `sections/section-010/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-010/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Add the missing `metrics` pipeline, upsert resource attributes in all three pipelines, sample only the traces and record the evidence in a ConfigMap. The grader checks live cluster state and the Collector log.

### Knowledge Check
*   **Quiz:** 8 questions in `sections/section-010/quiz.yaml`. The pass score is 70 percent.
