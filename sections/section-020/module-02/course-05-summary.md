---
draft: true
exam_objectives:
  - Semantic Conventions
---
# Summary

Attribute names are lowercase and dotted, with a namespace, and the type, unit and meaning of each name are part of the contract. Span names and metric attribute values stay low in cardinality, and metric names carry fixed units. Each attribute has a requirement level: required, conditionally required, recommended or opt-in. Application data goes under a namespace that belongs to the team, never under a standard one and never under `otel`.

The HTTP convention fixes `http.request.method`, `http.response.status_code`, `http.route` and `error.type`, the span name made of the method and the route template, and different status rules for the server side and the client side. The database convention names the product, the database, the operation, the collection and the query text, and it asks for sanitized query text. The messaging convention names the system, the operation type and the destination, and uses producer and consumer kinds. Older names such as `http.method` and `db.statement` are replaced by newer ones, and the version of a library decides which names it emits.

Kubernetes and cloud attributes describe where a program runs and belong on the resource. A value that changes per operation belongs on the item. A Collector can add, rename, copy and sanitize attributes, but it cannot recreate a value that the program never recorded.

Key facts:

- A span name with a changing value breaks grouping.
- A 404 is an error on an HTTP client span and not on a server span.
- A query text with literal values is high cardinality and can hold personal data.
- The service identity is `service.name`, and pod attributes name the instance.

<!-- astrona:playground:destroy -->
