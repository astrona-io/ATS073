# Question

Solve this question on: `terminal`

The service `bridge` serves the route `/orders`. Prometheus in `observability` scrapes its counter `http_requests_total` with the labels `service`, `route` and `code`. The counters are fixed, so every query returns the same values.

The team has this availability objective for `/orders`:

- Population: requests with `route="/orders"`.
- Valid events: all of them except requests with a `4xx` code (client errors are not counted).
- Good events: requests with a `2xx` or `3xx` code. Requests with a `5xx` code are valid and not good.
- Objective (SLO): 99.5 percent good events.

Query Prometheus and record the result in a ConfigMap `slo-report` in `starfleet` with these keys. Write numbers only, without units or a percent sign:

- `valid_events` and `good_events`: the counts.
- `sli`: good events divided by valid events, as a percentage with two decimals.
- `slo_target`: `99.5`.
- `slo_met`: `yes` or `no`.
- `allowed_bad_events`: the number of bad events the objective allows for the valid events.
- `budget_consumed_percent`: the bad events as a percentage of the allowed bad events, with two decimals.
- `budget_remaining_events`: allowed bad events minus the bad events (negative when the budget is spent).

Do not change Prometheus or the metrics server. `kubectl` already points at the cluster.
