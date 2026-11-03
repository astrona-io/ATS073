# Question

Solve this question on: `terminal`

Prometheus in `observability` scrapes the jobs `bridge` and `shuttle` every 5 seconds. The counters are fixed, so every query returns the same values. Prometheus has no rule file. The team wants three recording rules so that dashboards and alerts read one agreed definition.

Add a rule file to the ConfigMap `prometheus-config` as the key `rules.yml`, list it under `rule_files` in `prometheus.yml`, and make Prometheus load it. Record these three series. All three names follow the form `level:metric:operations`:

1. `bridge:http_requests:total`: the sum of `http_requests_total` for `service="bridge"`.
2. `bridge:http_error_ratio:ratio`: the sum of `http_requests_total` for `service="bridge"` with a code that starts with `5`, divided by the sum of all `http_requests_total` for `service="bridge"`.
3. `shuttle:http_request_duration_seconds:under_300ms_ratio`: the sum of `http_request_duration_seconds_bucket` for `service="shuttle"` with `le="0.3"`, divided by the sum of `http_request_duration_seconds_count` for `service="shuttle"`.

Do not change the scrape jobs, the metric files or the Prometheus Deployment. `kubectl` already points at the cluster. The rules are evaluated every 5 seconds, so the series appear shortly after Prometheus starts.
