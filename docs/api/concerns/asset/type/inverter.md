---
title: Asset::Type::Inverter
description: Attribute accessors for Inverter asset type.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::Type::Inverter <Badge type="warning" text="Concern" />

Attribute accessors for Inverter asset type.
#
# Provides convenient accessor methods for Inverter-specific attributes
# stored in the attributes_data JSONB column. These methods are automatically
# available on Asset instances when asset_type.name == "Inverter" via
# the Type::Dispatch concern.
#
# @example Accessing Inverter attributes
#   inverter = Asset.find_by(name: "Inverter 1")
#   inverter.ac_power_output    # => value from attributes_data["acPowerOutput"]
#   inverter.dc_power_input     # => value from attributes_data["dcPowerInput"]
#   inverter.efficiency         # => value from attributes_data["efficiency"]
#
class Asset
  module Type

::: info File Location
**Source:** `app/models/asset/type/inverter/attributes.rb`
:::

::: tip Rails Framework
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
