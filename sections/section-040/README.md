---
draft: true
exam_objectives:
  - Analysis and Outcomes
---
# Section 040: Analysis and Outcomes

This section teaches you how telemetry becomes a decision. You will define service level indicators and objectives, calculate an error budget from counters, build a latency indicator from a histogram and read dashboards without mistaking a missing series for a measured zero. You will query a Prometheus server in a cluster.

**Exam objective covered:** Analysis and Outcomes

---

## What You Will Master

- Distinguish a service level indicator (SLI), a service level objective (SLO) and a service level agreement (SLA).
- Define good events, valid events and the window, and calculate an SLI from counters.
- Calculate an error budget and a burn rate, and account for low traffic, exclusions and incomplete observation.
- Build a latency SLI from the cumulative buckets of a histogram.
- Check scrape health with `up` and `absent`, and tell a display gap from a measured zero.
- Choose panels for rate, errors, duration and saturation, and keep time range, units, grouping and denominator visible.
- Describe the RED method and the USE method.
- Name the four golden signals and choose the method that fits a component.
- Write PromQL for rate, errors, latency and utilization.
- Save a query as a recording rule and load it into Prometheus.
- Write an alerting rule with `for`, labels and annotations and describe the alert states.
- Compute a burn rate and the share of budget used, and choose multiwindow thresholds.
- Decide whether a symptom or a cause alert pages a person or opens a ticket.
- Explain Alertmanager routing and find why an alert did not arrive.

---

## The Learning Path

### 1. Service Indicators, Objectives, Agreements And Budgets
*   **Module Reader:** **Module 1: Service Indicators, Objectives, Agreements And Budgets**
*   **Hands-on Playground:** `sections/section-040/module-01/playground` - kind cluster with Prometheus in `observability` scraping fixed counters and a histogram from a static metrics server. Nothing to submit.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/module-01/playground
    ```
*   **Lab:** `sections/section-040/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/module-01/labs/lab-01
    astrona submit -c .
    ```

### 2. RED, USE And The Four Golden Signals
*   **Module Reader:** **Module 2: RED, USE And The Four Golden Signals**
*   **Hands-on Playground:** `sections/section-040/module-02/playground` - kind cluster for this module. Nothing to submit.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/module-02/playground
    ```
*   **Lab:** `sections/section-040/module-02/labs/lab-01` (UNTESTED). Record the request total, an error ratio and a latency ratio as Prometheus recording rules.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/module-02/labs/lab-01
    astrona submit -c .
    ```

### 3. Alerting And Burn-Rate
*   **Module Reader:** **Module 3: Alerting And Burn-Rate**
*   **Hands-on Playground:** `sections/section-040/module-03/playground` - kind cluster for this module. Nothing to submit.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/module-03/playground
    ```
*   **Lab:** `sections/section-040/module-03/labs/lab-01` (UNTESTED). Write burn-rate alerting rules in Prometheus and make one of them fire.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/module-03/labs/lab-01
    astrona submit -c .
    ```

### Section Capstone Challenge
*   **Comprehensive Challenge:** Analysis and Outcomes Capstone - `sections/section-040/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS073.git -c sections/section-040/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Fix a scrape job that points at the wrong port, keep a job that has no data, compute a latency SLI from a histogram and record the report in a ConfigMap.

### Knowledge Check
*   **Quiz:** 10 questions in `sections/section-040/quiz.yaml`. The pass score is 70 percent.
