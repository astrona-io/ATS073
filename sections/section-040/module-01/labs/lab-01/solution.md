# Solution

Prometheus holds the raw counters. The objective is a definition: a population of valid events and a subset of good events. First get the counts per code, and then do the arithmetic.

## Step 1: read the counters

```sh
kubectl -n observability exec deploy/prometheus -- wget -qO- 'http://localhost:9090/api/v1/query?query=sum%20by%20(code)%20(http_requests_total%7Broute%3D%22%2Forders%22%7D)'
```

The result lists one value per code for `/orders`: 200, 201, 301, 404, 429, 500 and 503. The `4xx` codes (404 and 429) are not valid events. The codes 200, 201 and 301 are good. The codes 500 and 503 are valid and bad.

## Step 2: compute the SLI

- Good events: 91200 + 4300 + 500 = 96000.
- Bad events: 310 + 190 = 500.
- Valid events: 96000 + 500 = 96500.
- SLI: 96000 / 96500 * 100 = 99.48 percent (rounded to two decimals).

The SLI is below the target of 99.5 percent, so the objective is not met.

## Step 3: compute the budget

- Allowed bad events: 96500 * 0.5 / 100 = 482.5.
- Budget consumed: 500 / 482.5 * 100 = 103.63 percent.
- Budget remaining: 482.5 - 500 = -17.5 events.

## Step 4: record the report

Save this as `slo-report.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: slo-report
  namespace: starfleet
data:
  valid_events: "96500"
  good_events: "96000"
  sli: "99.48"
  slo_target: "99.5"
  slo_met: "no"
  allowed_bad_events: "482.5"
  budget_consumed_percent: "103.63"
  budget_remaining_events: "-17.5"
```

```sh
kubectl apply -f slo-report.yaml
```

Submit with `astrona submit`. The checks recompute the values from the metrics ConfigMap.
