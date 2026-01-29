---
title: Asset::Type::Energy
description: Attribute accessors for EnergyMeter asset type.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::Type::Energy <Badge type="warning" text="Concern" />

Attribute accessors for EnergyMeter asset type.
#
# Provides convenient accessor methods for EnergyMeter-specific attributes
# stored in the attributes_data JSONB column. These methods are automatically
# available on Asset instances when asset_type.name == "EnergyMeter" via
# the Type::Dispatch concern.
#
# @example Accessing EnergyMeter attributes
#   meter = Asset.find_by(name: "Energy Meter 1")
#   meter.active_power    # => value from attributes_data["activePower"]
#   meter.energy_import   # => value from attributes_data["energyImport"]
#   meter.power_factor    # => value from attributes_data["powerFactor"]
#
class Asset
  module Type

::: info File Location
**Source:** `app/models/asset/type/energy/meter/attributes.rb`
:::

::: tip Rails Framework
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
