---
title: Asset::Type::Solar::Park::Attributes
description: Attribute accessors for SolarPark asset type.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::Type::Solar::Park::Attributes <Badge type="warning" text="Concern" />

Attribute accessors for SolarPark asset type.
#
# Provides convenient accessor methods for SolarPark-specific attributes
# stored in the attributes_data JSONB column. These methods are automatically
# available on Asset instances when asset_type.name == "SolarPark" via
# the Type::Dispatch concern.
#
# @example Accessing SolarPark attributes
#   park = Asset.find_by(name: "Solar Park 1")
#   park.total_capacity        # => value from attributes_data["totalCapacity"]
#   park.total_power_output    # => value from attributes_data["totalPowerOutput"]
#   park.update_performance_ratio! # Calculate and save performance ratio
#
class Asset
  module Type
    module Solar
      module Park

::: info File Location
**Source:** `app/models/asset/type/solar/park/attributes.rb`
:::

::: tip Rails Framework
:::

## Instance Methods

<Badge type="info" text="8 instance methods" />

::: details View all 8 instance methods

- `total_capacity` -> `Numeric` - Get the total installed capacity in watts.
- `total_power_output` -> `Numeric` - Get the current total power output in watts.
- `total_energy_generated` -> `Numeric` - Get the total energy generated since installation in watt-hours.
- `daily_energy_generated` -> `Numeric` - Get the daily energy generated in watt-hours.
- `forecasted_generation` -> `Numeric` - Get the forecasted energy generation in watt-hours.
- `performance_ratio` -> `Numeric` - Get the performance ratio (actual output / capacity).
- `location` -> `String` - Get the geographic location.
- `update_performance_ratio!` -> `void` - Calculate and update the performance ratio based on current power output.
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
