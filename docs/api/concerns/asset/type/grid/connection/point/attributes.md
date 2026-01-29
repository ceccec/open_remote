---
title: Asset::Type::Grid::Connection::Point::Attributes
description: Attribute accessors for GridConnectionPoint asset type.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::Type::Grid::Connection::Point::Attributes <Badge type="warning" text="Concern" />

Attribute accessors for GridConnectionPoint asset type.
#
# Provides convenient accessor methods for GridConnectionPoint-specific attributes
# stored in the attributes_data JSONB column. These methods are automatically
# available on Asset instances when asset_type.name == "GridConnectionPoint" via
# the Type::Dispatch concern.
#
# @example Accessing GridConnectionPoint attributes
#   gcp = Asset.find_by(name: "Grid Connection Point 1")
#   gcp.connection_capacity # => value from attributes_data["connectionCapacity"]
#   gcp.active_power        # => value from attributes_data["activePower"]
#   gcp.energy_exported     # => value from attributes_data["energyExported"]
#
class Asset
  module Type
    module Grid
      module Connection
        module Point

::: info File Location
**Source:** `app/models/asset/type/grid/connection/point/attributes.rb`
:::

::: tip Rails Framework
:::

## Instance Methods

<Badge type="info" text="9 instance methods" />

::: details View all 9 instance methods

- `connection_capacity` -> `Numeric` - Get the connection capacity in watts.
- `active_power` -> `Numeric` - Get the active power (real power) in watts.
- `reactive_power` -> `Numeric` - Get the reactive power in volt-amperes reactive (VAR).
- `voltage` -> `Numeric` - Get the voltage in volts.
- `frequency` -> `Numeric` - Get the frequency in hertz.
- `energy_exported` -> `Numeric` - Get the total energy exported to the grid in watt-hours.
- `energy_imported` -> `Numeric` - Get the total energy imported from the grid in watt-hours.
- `connection_status` -> `String` - Get the connection status (e.g., "connected", "disconnected", "fault").
- `location` -> `String` - Get the geographic location.
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
