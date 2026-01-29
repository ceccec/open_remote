---
title: Asset::Type::Solar::Park
description: Attribute accessors for SolarPark asset type.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::Type::Solar::Park <Badge type="warning" text="Concern" />

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

::: info File Location
**Source:** `app/models/asset/type/solar/park/attributes.rb`
:::

::: tip Rails Framework
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
