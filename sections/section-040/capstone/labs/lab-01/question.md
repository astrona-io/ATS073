# Question

Solve this question on: `terminal`

Prometheus in `observability` has three scrape jobs: `bridge`, `scout` and `probe`. The team needs a latency indicator for `scout`, but Prometheus has no data for it. The dashboard for `probe` is also empty, and nobody knows why.

The latency objective: 95 percent of the requests of `scout` finish in 300 milliseconds or less. The service `scout` exposes the histogram `http_request_duration_seconds`.

1. Find why Prometheus has no data for the job `scout` and fix it. The Service `scout-metrics` in `observability` listens on port 8080. Edit the ConfigMap `prometheus-config`, restart the Deployment `prometheus`, and check that `up{job="scout"}` is 1.
2. Do not delete the job `probe`. It has no target Service, so it stays down and has no request series. Do not invent data for it.
3. Compute the latency SLI from the histogram: the number of requests that finished in 0.3 seconds or less (the cumulative bucket `le="0.3"`) divided by the total number of requests (`http_request_duration_seconds_count`).
4. Record the result in a ConfigMap `latency-report` in `starfleet` with these keys. Write numbers only, without units or a percent sign:
   - `requests_total` and `under_300ms`: the two counts.
   - `latency_sli`: the percentage, with two decimals.
   - `slo_target`: `95`.
   - `slo_met`: `yes` or `no`.
   - `probe_status`: `no-data` when the probe has no series, and `zero` when it measured zero.

`kubectl` already points at the cluster.
