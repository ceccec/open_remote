---
title: Asset::Type::Energy::Meter::Attributes
description: Attribute accessors for EnergyMeter asset type.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::Type::Energy::Meter::Attributes <Badge type="warning" text="Concern" />

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
    module Energy
      module Meter

::: info File Location
**Source:** `app/models/asset/type/energy/meter/attributes.rb`
:::

::: tip Rails Framework
:::

## Instance Methods

<Badge type="info" text="9 instance methods" />

::: details View all 9 instance methods

- `active_power` -> `Numeric` - Get the active power (real power) in watts.
- `reactive_power` -> `Numeric` - Get the reactive power in volt-amperes reactive (VAR).
- `apparent_power` -> `Numeric` - Get the apparent power in volt-amperes (VA).
- `energy_import` -> `Numeric` - Get the total energy imported in watt-hours.
- `energy_export` -> `Numeric` - Get the total energy exported in watt-hours.
- `voltage` -> `Numeric` - Get the voltage in volts.
- `current` -> `Numeric` - Get the current in amperes.
- `power_factor` -> `Numeric` - Get the power factor (ratio of active to apparent power).
- `frequency` -> `Numeric` - Get the frequency in hertz.
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
