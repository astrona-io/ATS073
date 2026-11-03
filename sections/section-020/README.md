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

### Section Capstone Challenge
*   **Comprehensive Challenge:** Semantic Conventions Capstone - `sections/section-020/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-020/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Review the spans, logs and metrics of three services, rename the old attribute names, remove personal and unbounded attributes, set the deployment environment on the resource and record the review in a ConfigMap.

### Knowledge Check
*   **Quiz:** 8 questions in `sections/section-020/quiz.yaml`. The pass score is 70 percent.
