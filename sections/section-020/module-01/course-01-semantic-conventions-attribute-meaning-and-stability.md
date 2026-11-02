---
draft: true
exam_objectives:
- Semantic Conventions
---
# Semantic Conventions, Attribute Meaning And Stability

Semantic conventions define shared meanings for telemetry fields. Without a common contract, one library might label a request method as verb while another uses a different key or value interpretation. Consumers would need special rules for every producer. OpenTelemetry conventions reduce that ambiguity by describing attributes, signal structures and expected meanings for particular technologies and operations.

The location of an attribute matters. A resource attribute identifies the entity producing telemetry, such as the service name or deployment environment. A span attribute describes an operation, such as the route or response outcome. A metric attribute identifies a measurement dimension. The same descriptive word can become misleading if attached at the wrong scope. A single request identifier should not define the identity of the whole service resource.

Consider a service instrumenting HTTP requests. A normalized route pattern is useful for grouping operations by endpoint behavior. The raw path can contain customer identifiers or arbitrary values. Recording every raw path as a metric dimension can produce a new series for each value and expose information that was never intended as telemetry. Shared naming does not remove that cardinality or privacy consequence.

Attribute values should be truthful about the producer's knowledge. A server instrumentation layer may know the matched route only after framework routing completes. Before that point, it should not invent a route from an arbitrary incoming path and present it as the canonical template. This distinction matters to dashboards and alerts because a false grouping can make unrelated traffic appear to share one endpoint contract.

Conventions also have version and stability boundaries. Some definitions are stable, while others can change as a technology's model develops. Instrumentation libraries may support migration behavior or release-specific opt-in settings. A team should identify which convention generation its producers emit and which one its consumers expect. Updating a package can affect query meaning even when the application behavior remains unchanged.

For example, a dashboard built around an older attribute name can lose data after an instrumentation upgrade. The application may still serve requests and the exporter may still deliver telemetry. The failing contract is between emitted schema and consumer expectations. A controlled migration can update dashboards, normalize data where supported or temporarily accommodate both representations. Blindly declaring the exporter broken misses the actual boundary.

Conventions are not a permission system. A key intended for an endpoint or identity can still carry a confidential value. Instrumentation should minimize sensitive data and consider where telemetry will be exported and retained. Redacting a value downstream is less protective than avoiding unnecessary collection at the source, especially if intermediate systems already receive the original value.

Cardinality deserves separate review for each signal. A trace attribute can be valuable for investigating an individual operation while the same value would be unsuitable as a metric dimension. Logs can contain rich event detail but need access and retention controls. The usefulness of a convention depends on how the signal is aggregated and consumed, not only whether the key is spelled correctly.

Good authoring names the scope, intended values and compatibility assumptions of each field. An example should explain why a service identity is stable, why a route is normalized and why a user token is excluded. That reasoning lets students assess unfamiliar instrumentation instead of memorizing a list of keys without understanding their consequences.

## Common pitfalls

> [!WARNING]
> Standard keys do not make arbitrary values safe or low-cardinality. Distinguish resource identity from individual operation data and review convention stability during upgrades. A consumer-schema mismatch can hide delivered telemetry without implying that the application or exporter stopped working.
