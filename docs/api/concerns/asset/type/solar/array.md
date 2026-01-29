---
title: Asset::Type::Solar::Array
description: Attribute accessors for SolarArray asset type.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::Type::Solar::Array <Badge type="warning" text="Concern" />

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

::: info File Location
**Source:** `app/models/asset/type/solar/array/attributes.rb`
:::

::: tip Rails Framework
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
