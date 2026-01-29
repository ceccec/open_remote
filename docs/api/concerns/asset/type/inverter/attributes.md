---
title: Asset::Type::Inverter::Attributes
description: Attribute accessors for Inverter asset type.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::Type::Inverter::Attributes <Badge type="warning" text="Concern" />

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
    module Inverter

::: info File Location
**Source:** `app/models/asset/type/inverter/attributes.rb`
:::

::: tip Rails Framework
:::

## Instance Methods

<Badge type="info" text="10 instance methods" />

::: details View all 10 instance methods

- `inverter_capacity` -> `Numeric` - Get the inverter capacity in watts.
- `ac_power_output` -> `Numeric` - Get the AC power output in watts.
- `dc_power_input` -> `Numeric` - Get the DC power input in watts.
- `ac_voltage` -> `Numeric` - Get the AC voltage in volts.
- `ac_frequency` -> `Numeric` - Get the AC frequency in hertz.
- `efficiency` -> `Numeric` - Get the conversion efficiency as a decimal (0.0 to 1.0).
- `temperature` -> `Numeric` - Get the current temperature in Celsius.
- `uptime` -> `Integer` - Get the uptime in seconds.
- `status` -> `String` - Get the operational status (e.g., "active", "maintenance").
- `alarm_status` -> `String` - Get the alarm status (e.g., "normal", "warning", "critical").
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
