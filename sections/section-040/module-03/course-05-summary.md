---
draft: true
exam_objectives:
  - Analysis and Outcomes
---
# Summary

An alerting rule has `alert`, `expr`, `for`, labels and annotations. An alert is inactive, pending while the expression is true for less than `for`, and firing after that. Labels route the alert and annotations help the reader. Rules on counters use `rate()`.

An SLO of 99.9 percent leaves an error budget of 0.001. The burn rate is the error ratio divided by the error budget, so an error ratio of 0.0045 is a burn rate of about 4.5. The share of budget used is the burn rate times the window divided by the period. A multiwindow alert needs both a long and a short window above the threshold: 14.4 for 1 hour and 5 minutes pages, and 1 for 3 days and 6 hours opens a ticket.

Page for symptoms that harm users now, and use tickets or dashboards for causes. Alertmanager groups, routes, inhibits and silences. A missing alert is found by checking, in order, the rule list, the expression, the state, the delivery and the routing. The `service` label ties the alert to metrics, traces and logs.

Key facts:

- Burn rate equals error ratio divided by 1 minus the SLO.
- `for` keeps short spikes from firing.
- Both windows must be above the threshold.
- Annotations should tell the reader what to do.

<!-- astrona:playground:destroy -->
