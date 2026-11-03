---
draft: true
exam_objectives:
  - Semantic Conventions
---
# Resource Detection, Schema URLs And Stability

A resource names the producer of telemetry. This module covers where its attributes come from, how detectors in an SDK and in the Collector fill them in, what a schema URL says about the version of the names, and how stability levels and opt-in settings control a change of names. It ends with a Collector change that adds detected host attributes and an environment name.

## Learning Goals

- List the sources of resource attributes and the order in which they are merged.
- Explain the default service name and the role of `service.instance.id`.
- Configure the `resourcedetection` processor with detectors and the `override` setting.
- Explain what a schema URL states and what a schema file contains.
- Distinguish stable from development conventions and use the opt-in setting for a name change.
- Decide which attributes a program sets and which a detector adds.

## Before You Start

You should know what a resource attribute is and how the Collector reads a configuration file. The hands-on steps use a playground: a kind cluster with `kubectl`, an OpenTelemetry Collector and a trace generator. The Collector prints every item with its `debug` exporter. Technical terms are defined where they first appear.

## Reading Order

1. Where Resource Attributes Come From
2. Resource Detectors In The SDK And The Collector
3. Schema URLs And Schema Translation
4. Stability Levels And Migrating Names
5. Summary

<!-- astrona:playground -->
