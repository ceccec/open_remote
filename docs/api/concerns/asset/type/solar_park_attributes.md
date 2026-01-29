---
title: Asset::Type::SolarParkAttributes
description: Legacy module name for SolarPark attributes.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::Type::SolarParkAttributes <Badge type="warning" text="Concern" />

Legacy module name for SolarPark attributes.
#
# This module delegates to Asset::Type::Solar::Park::Attributes to avoid duplication.
# It exists for backward compatibility with code that extends Asset::Type::SolarParkAttributes.
#
class Asset
  module Type

::: info File Location
**Source:** `app/models/asset/type/solar_park_attributes.rb`
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
