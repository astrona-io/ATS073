---
draft: true
exam_objectives:
  - Instrumentation
---
# Section 030: Instrumentation

This section teaches you how a program produces telemetry: which part of OpenTelemetry the code calls, which part decides where the data goes, and how environment variables configure it without a code change. You will fix the environment of instrumented Python programs in a cluster.

**Exam objective covered:** Instrumentation

---

## What You Will Master

- Explain the roles of the API, the SDK and an exporter, and why library code depends on the API only.
- Distinguish manual from automatic instrumentation, and name what each is good at.
- Configure a program with the `OTEL_*` environment variables: service name, resource attributes, exporter protocol, endpoint, sampler and SDK switch.
- Find why a program sends no useful telemetry from the Deployment environment and the Collector log.
- Choose measurements that are useful, small and free of sensitive values.
- Get a tracer and a meter and explain the instrumentation scope.
- Create spans with attributes and kind.
- Record events and exceptions and set the span status.
- Choose and create metric instruments in code.

---

## The Learning Path

### 1. API Calls, Automatic Instrumentation And Measurement Design
*   **Module Reader:** **Module 1: API Calls, Automatic Instrumentation And Measurement Design**
*   **Hands-on Playground:** `sections/section-030/module-01/playground` - kind cluster with a Collector in `observability` and a Python program in `starfleet` that runs under `opentelemetry-instrument`. Nothing to submit.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-030/module-01/playground
    ```
*   **Lab:** `sections/section-030/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-030/module-01/labs/lab-01
    astrona submit -c .
    ```

### 2. Manual Instrumentation With The API
*   **Module Reader:** **Module 2: Manual Instrumentation With The API**
*   **Hands-on Playground:** `sections/section-030/module-02/playground` - kind cluster for this module. Nothing to submit.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-030/module-02/playground
    ```
*   **Lab:** `sections/section-030/module-02/labs/lab-01` (UNTESTED). Fix the kind, the error recording and a missing histogram in a program that uses the API.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-030/module-02/labs/lab-01
    astrona submit -c .
    ```

### Section Capstone Challenge
*   **Comprehensive Challenge:** Instrumentation Capstone - `sections/section-030/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-030/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Three programs run the same code and each has a different cause for missing telemetry. Fix their environments, wait for the new pods and record the cause for each in a ConfigMap.

### Knowledge Check
*   **Quiz:** 9 questions in `sections/section-030/quiz.yaml`. The pass score is 70 percent.
