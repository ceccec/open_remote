---
title: Asset::Type::Weather
description: Attribute accessors for WeatherStation asset type.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::Type::Weather <Badge type="warning" text="Concern" />

Attribute accessors for WeatherStation asset type.
#
# Provides convenient accessor methods for WeatherStation-specific attributes
# stored in the attributes_data JSONB column. These methods are automatically
# available on Asset instances when asset_type.name == "WeatherStation" via
# the Type::Dispatch concern.
#
# @example Accessing WeatherStation attributes
#   station = Asset.find_by(name: "Weather Station 1")
#   station.temperature      # => value from attributes_data["temperature"]
#   station.wind_speed       # => value from attributes_data["windSpeed"]
#   station.solar_irradiance # => value from attributes_data["solarIrradiance"]
#
class Asset
  module Type

::: info File Location
**Source:** `app/models/asset/type/weather/station/attributes.rb`
:::

::: tip Rails Framework
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
