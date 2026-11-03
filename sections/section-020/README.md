---
draft: true
exam_objectives:
  - Semantic Conventions
---
# Section 020: Semantic Conventions

This section teaches you how OpenTelemetry gives attribute names, values and units one shared meaning. You will decide where an attribute belongs and change attributes in a Collector without breaking the people who read the data.

**Exam objective covered:** Semantic Conventions

---

## What You Will Master

- Explain a semantic convention as a contract on names, types, units and requirement levels, and describe stability and deprecation.
- Distinguish resource attributes from span, log and data point attributes, and place an attribute on the right one.
- Explain why a value that is different for every customer is a poor metric attribute and a privacy risk.
- Rename, copy and delete attributes with the `attributes` processor, and explain why the order of the actions matters.
- Apply the naming rules, namespaces and requirement levels.
- Use the HTTP, RPC, database and messaging conventions.
- Place Kubernetes and cloud attributes on the resource and keep custom attributes in a team namespace.
- Rename and sanitize attributes with the transform processor.
- List the sources of resource attributes and how they are merged.
- Configure resource detectors in the Collector and explain the override setting.
- Explain what a schema URL states and who translates between versions.
- Use stability levels and `OTEL_SEMCONV_STABILITY_OPT_IN` to migrate attribute names.

---

## The Learning Path

### 1. Semantic Conventions, Attribute Meaning And Stability
*   **Module Reader:** **Module 1: Semantic Conventions, Attribute Meaning And Stability**
*   **Hands-on Playground:** `sections/section-020/module-01/playground` - kind cluster with a Collector in `observability` and a load generator in `starfleet` that sends spans with older attribute names. Nothing to submit.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/module-01/playground
    ```
*   **Lab:** `sections/section-020/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/module-01/labs/lab-01
    astrona submit -c .
    ```

### 2. Semantic Conventions By Signal And Domain
*   **Module Reader:** **Module 2: Semantic Conventions By Signal And Domain**
*   **Hands-on Playground:** `sections/section-020/module-02/playground` - kind cluster for this module. Nothing to submit.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/module-02/playground
    ```
*   **Lab:** `sections/section-020/module-02/labs/lab-01` (UNTESTED). Rename database attributes and remove literal values from query text with the transform processor.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/module-02/labs/lab-01
    astrona submit -c .
    ```

### 3. Resource Detection, Schema URLs And Stability
*   **Module Reader:** **Module 3: Resource Detection, Schema URLs And Stability**
*   **Hands-on Playground:** `sections/section-020/module-03/playground` - kind cluster for this module. Nothing to submit.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/module-03/playground
    ```
*   **Lab:** `sections/section-020/module-03/labs/lab-01` (UNTESTED). Add the resourcedetection processor and an environment name to a Collector.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/module-03/labs/lab-01
    astrona submit -c .
    ```

### Section Capstone Challenge
*   **Comprehensive Challenge:** Semantic Conventions Capstone - `sections/section-020/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Review the spans, logs and metrics of three services, rename the old attribute names, remove personal and unbounded attributes, set the deployment environment on the resource and record the review in a ConfigMap.

### Knowledge Check
*   **Quiz:** 8 questions in `sections/section-020/quiz.yaml`. The pass score is 70 percent.
