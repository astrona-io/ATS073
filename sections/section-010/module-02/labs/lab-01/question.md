# Question

Solve this question on: `terminal`

The service `shuttle` in `starfleet` sends about 5 successful traces and 1 failed trace per second to the Collector `otel-collector` in `observability`. The Collector keeps only 10 percent of the traces with the head sampler `probabilistic_sampler`. About 9 of 10 failed traces are lost, and the team cannot investigate the failures.

Change only the Collector. Do not change the load generator `shuttle-load`.

1. Remove the `probabilistic_sampler` processor from the `traces` pipeline.
2. Add the `tail_sampling` processor with `decision_wait: 5s` and two policies. The first policy is of type `status_code` and keeps the status code `ERROR`. The second policy is of type `probabilistic` and keeps 10 percent of the other traces.
3. List `tail_sampling` in the processors of the `traces` pipeline. Write the pipeline in the order `receivers`, `processors`, `exporters`, and write the lists in flow style, for example `processors: [tail_sampling]`.
4. Restart the Collector so that it reads the new configuration. After about a minute, the `debug` exporter output of the new pod must show a large share of spans with the status code `Error` and fewer spans with the status code `Ok`.

The configuration is the key `collector.yaml` of the ConfigMap `otel-collector-config` in the namespace `observability`. `kubectl` already points at the cluster.
