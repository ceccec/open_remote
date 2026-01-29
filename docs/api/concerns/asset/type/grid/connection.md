---
title: Asset::Type::Grid::Connection
description: Attribute accessors for GridConnectionPoint asset type.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::Type::Grid::Connection <Badge type="warning" text="Concern" />

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

::: info File Location
**Source:** `app/models/asset/type/grid/connection/point/attributes.rb`
:::

::: tip Rails Framework
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
