#!/usr/bin/env bash
# Check: the evidence ConfigMap is complete and matches the configuration
set -uo pipefail

fail=0
config="$(kubectl -n observability get configmap otel-collector-config -o jsonpath='{.data.collector\.yaml}' 2>/dev/null)"
flat="$(printf '%s' "$config" | tr -d ' \n')"
# True when pipeline $1 lists $2 inside its processors list (flow style).
pipeline_has_processor() {
  printf '%s' "$flat" | grep -Eq "$1:receivers:\[[^]]*\],processors:\[[^]]*$2[^]]*\]"
}

get_key() { kubectl -n starfleet get configmap telemetry-evidence -o "jsonpath={.data.$1}" 2>/dev/null; }
if ! kubectl -n starfleet get configmap telemetry-evidence >/dev/null 2>&1; then
  echo "FAIL: ConfigMap telemetry-evidence does not exist in starfleet"
  exit 1
fi
signals="$(get_key signals)"
for signal in traces metrics logs; do
  case ",$signals," in
    *",$signal,"*) ;;
    *) echo "FAIL: key signals must list $signal (comma separated)"; fail=1 ;;
  esac
done
if [ "$(get_key missing-signal)" != "metrics" ]; then
  echo "FAIL: key missing-signal must name the signal that had no pipeline (metrics)"
  fail=1
fi
if [ "$(get_key sampled-signal)" != "traces" ]; then
  echo "FAIL: key sampled-signal must name the signal that is sampled (traces)"
  fail=1
fi
configured="$(printf '%s' "$flat" | sed -n 's/.*probabilistic_sampler:sampling_percentage:\([0-9.]*\).*/\1/p')"
if [ -z "$configured" ] || [ "$(get_key sampling-percentage)" != "$configured" ]; then
  echo "FAIL: key sampling-percentage must equal the percentage in the Collector configuration ('$configured')"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the evidence record matches the configuration"
fi
exit "$fail"
