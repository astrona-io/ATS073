---
draft: true
exam_objectives:
  - Semantic Conventions
---
# Database And Messaging Conventions

A database call and a message on a queue are two common places where a request leaves a service. Both carry data that is easy to get wrong: a query text can hold personal values, and a destination name can have unbounded values. This part lists the attributes of the database and messaging conventions and the rules that keep their names and values safe to store.

## Database client spans

A database call is a span with the kind `CLIENT`. The current database convention uses these main attributes:

- `db.system.name`: the product, for example `postgresql`, `mysql` or `redis`.
- `db.namespace`: the database that the call uses, for example `orders`.
- `db.operation.name`: the operation, for example `SELECT` or `INSERT`.
- `db.collection.name`: the table or collection, for example `orders`.
- `db.query.text`: the text of the query.
- `server.address` and `server.port`: where the database server is.
- `error.type`: set when the call failed.

Older instrumentation used `db.system`, `db.name` and `db.statement` for the first, second and fifth item. The new names replace them. As with HTTP, the names depend on the version of the library, and the environment variable `OTEL_SEMCONV_STABILITY_OPT_IN` can switch a library to emit the new names, the old names or both.

The span name is built from the operation and the target, for example `SELECT orders`. When the operation is not known, the span name falls back to the collection or the database name. It is not the query text, because the text has too many distinct values.

## The query text

`db.query.text` needs care. A query that contains parameter values, such as `SELECT * FROM orders WHERE id = 42`, holds data that may be personal or secret and creates a new text for every id. The convention says that instrumentation should **sanitize** the text: replace the literal values with a placeholder, for example `SELECT * FROM orders WHERE id = ?`. A query that already uses parameters, such as `WHERE id = $1`, is safe to record as it is, because the values are sent separately.

A Collector can sanitize text for programs that do not. The `transform` processor runs OpenTelemetry Transformation Language (OTTL) statements. The function `replace_pattern` replaces the part of a value that matches a regular expression. A statement like the following replaces a number after an equals sign:

```yaml
- replace_pattern(attributes["db.query.text"], "= [0-9]+", "= ?")
```

A regular expression cannot understand all SQL. It removes the values that it matches and misses the others. The safe place to prevent sensitive values is still the instrumentation.

## Messaging

A message system has two sides. The producer creates a message and the consumer processes it. The convention uses these attributes:

- `messaging.system`: the product, for example `kafka` or `rabbitmq`.
- `messaging.operation.type`: `create`, `send`, `receive`, `process` or `settle`.
- `messaging.destination.name`: the queue, topic or exchange.
- `messaging.message.id`: the identifier of one message. It has unbounded values and is not for metrics.

A producer span has the kind `PRODUCER` and a consumer span has the kind `CONSUMER`. The trace context travels inside the message headers, so a consumer can continue the trace of the producer. A batch consumer that handles many messages in one span uses span links to the producers, because one span cannot have many parents. The messaging conventions are still in development, so a library can emit older names.

## Read database spans in the playground

<!-- astrona:playground:renew -->

The generator `harbor-db-load` sends spans for the service `harbor` that use the older database names. Read them:

```sh
kubectl -n observability logs deploy/otel-collector --since=30s --tail=-1 | grep -E '^ +-> db\.'
```

You see `db.system`, `db.name` and `db.statement` with their values. Check three things. First, the names are the older ones. Second, `db.statement` holds the literal value 42. Third, the same text, with another id, would appear as a new value for every request.

To prepare the Collector change that the lab asks for, find the name of each attribute in the new convention. Match `db.system` to `db.system.name`, `db.name` to `db.namespace` and `db.statement` to `db.query.text`. Then decide which OTTL functions you need: `set` to copy a value to a new key, `replace_pattern` to sanitize it and `delete_key` to remove the old key.

## What to take from this

The database convention names the product, the database, the operation, the collection and the query text, and it asks for the query text to be sanitized. The messaging convention names the system, the operation type and the destination, and it uses producer and consumer span kinds. In both cases the high-cardinality values belong in span attributes and never in metric attributes or span names. The next part covers the attributes that describe where the telemetry comes from.

## Common pitfalls

> [!WARNING]
> Do not record literal values from a query in `db.query.text`. Do not use the message ID or the full query text as a metric attribute. Do not assume that a regular expression in a Collector removes every sensitive value.
