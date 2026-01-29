---
title: JsonSchemaUtil
description: Lightweight JSON Schema helper inspired by OpenRemote's JSONSchemaUtil.
lastUpdated: 2026-01-28T21:47:06Z
tags:
  - concern
  - api
  - module
---

# JsonSchemaUtil <Badge type="warning" text="Concern" />

Lightweight JSON Schema helper inspired by OpenRemote's `JSONSchemaUtil`.

This utility is intentionally focused on the small subset of behaviour
exercised by the local RSpec suite: title handling, primitive type remapping,
enum support, "additionalProperties" defaults, and simple required flags.

::: info File Location
**Source:** `app/services/json_schema_util.rb`
:::

::: tip Rails Framework
:::

## Class Methods

<Badge type="info" text="2 class methods" />

::: details View all 2 class methods

- `build_schema`(name: String, properties: Hash{Symbol=Hash}, title: String, additional_properties: Boolean) -> `Hash` - Build a JSON Schema document for a simple object type.
- `build_property_schema`(options: Hash) -> `Hash` - Map a single property definition into JSON Schema form.
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/api/)
