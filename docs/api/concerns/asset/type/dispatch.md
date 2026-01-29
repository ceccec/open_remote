---
title: Asset::Type::Dispatch
description: Dynamic type module dispatch for Asset model.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::Type::Dispatch <Badge type="warning" text="Concern" />

Dynamic type module dispatch for Asset model.
#
# Automatically extends Asset instances with type-specific attribute accessors
# based on their asset_type. This allows assets to have type-specific methods
# (e.g., `power_output` for SolarArray) without requiring explicit inheritance.
#
# The module is extended after finding or initializing an asset, ensuring
# type-specific methods are available immediately.
#
# @example Type-specific methods
#   solar_array = Asset.find_by(name: "Array 1")
#   solar_array.power_output  # Available because asset_type.name == "SolarArray"
#   solar_array.array_capacity # Also available for SolarArray
#
class Asset
  module Type

::: info File Location
**Source:** `app/models/asset/type/dispatch.rb`
:::

::: tip Rails Framework

This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.

**Rails Framework References:**
- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior
- **ActiveSupport**: [ActiveSupport](https://api.rubyonrails.org/classes/ActiveSupport.html) - Utility classes and Ruby extensions

:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
