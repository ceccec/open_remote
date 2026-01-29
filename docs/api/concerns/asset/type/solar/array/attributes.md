---
title: Asset::Type::Solar::Array::Attributes
description: Attribute accessors for SolarArray asset type.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::Type::Solar::Array::Attributes <Badge type="warning" text="Concern" />

Attribute accessors for SolarArray asset type.
#
# Provides convenient accessor methods for SolarArray-specific attributes
# stored in the attributes_data JSONB column. These methods are automatically
# available on Asset instances when asset_type.name == "SolarArray" via
# the Type::Dispatch concern.
#
# @example Accessing SolarArray attributes
#   array = Asset.find_by(name: "Solar Array 1")
#   array.power_output      # => value from attributes_data["powerOutput"]
#   array.array_capacity    # => value from attributes_data["arrayCapacity"]
#   array.panel_count      # => value from attributes_data["panelCount"]
#
class Asset
  module Type
    module Solar
      module Array

::: info File Location
**Source:** `app/models/asset/type/solar/array/attributes.rb`
:::

::: tip Rails Framework
:::

## Instance Methods

<Badge type="info" text="10 instance methods" />

::: details View all 10 instance methods

- `array_capacity` -> `Numeric` - Get the array capacity in watts.
- `power_output` -> `Numeric` - Get the current power output in watts.
- `dc_voltage` -> `Numeric` - Get the DC voltage in volts.
- `dc_current` -> `Numeric` - Get the DC current in amperes.
- `panel_count` -> `Integer` - Get the number of solar panels in the array.
- `panel_orientation` -> `String` - Get the panel orientation (e.g., "South", "East", "West").
- `panel_tilt` -> `Numeric` - Get the panel tilt angle in degrees.
- `temperature` -> `Numeric` - Get the current temperature in Celsius.
- `status` -> `String` - Get the operational status (e.g., "active", "maintenance").
- `location` -> `String` - Get the geographic location.
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
