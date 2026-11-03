# Question

Solve this question on: `terminal`

Prometheus in `observability` scrapes the jobs `bridge` and `shuttle` every 5 seconds. The counters are fixed. The SLO of the bridge is 99.9 percent, so the error budget is `0.001`. Of the 119240 requests of the service `bridge`, 540 have a 5xx code, which is an error ratio of about 0.0045.

Add a rule file to the ConfigMap `prometheus-config` as the key `alerts.yml`, list `/etc/prometheus/alerts.yml` under `rule_files` in `prometheus.yml`, and make Prometheus load it. Define two alerts, both with `for: 10s`:

1. `BridgeSlowBurn`: fires when the sum of `http_requests_total` for `service="bridge"` with a code that starts with `5`, divided by the sum of all `http_requests_total` for `service="bridge"`, is above `3 * 0.001`. Give it the label `severity: ticket` and an annotation `summary` with a text.
2. `BridgeFastBurn`: the same ratio above `14.4 * 0.001`. Give it the label `severity: page` and an annotation `summary` with a text.

Use the plain ratio of the totals, because the counters never change. Do not change the scrape jobs, the metric files or the Prometheus Deployment. `kubectl` already points at the cluster. Only one of the two alerts is expected to fire.
