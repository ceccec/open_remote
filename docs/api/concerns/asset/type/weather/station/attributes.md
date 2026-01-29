---
title: Asset::Type::Weather::Station::Attributes
description: Attribute accessors for WeatherStation asset type.
lastUpdated: 2026-01-29T01:42:54Z
tags:
  - concern
  - api
  - module
---

# Asset::Type::Weather::Station::Attributes <Badge type="warning" text="Concern" />

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
    module Weather
      module Station

::: info File Location
**Source:** `app/models/asset/type/weather/station/attributes.rb`
:::

::: tip Rails Framework
:::

## Instance Methods

<Badge type="info" text="9 instance methods" />

::: details View all 9 instance methods

- `temperature` -> `Numeric` - Get the current temperature in Celsius.
- `humidity` -> `Numeric` - Get the relative humidity as a percentage (0-100).
- `pressure` -> `Numeric` - Get the atmospheric pressure in hectopascals (hPa).
- `wind_speed` -> `Numeric` - Get the wind speed in meters per second.
- `wind_direction` -> `Numeric` - Get the wind direction in degrees (0-360, where 0 is North).
- `solar_irradiance` -> `Numeric` - Get the solar irradiance in watts per square meter.
- `cloud_cover` -> `Numeric` - Get the cloud cover as a percentage (0-100).
- `visibility` -> `Numeric` - Get the visibility in meters.
- `location` -> `String` - Get the geographic location.
:::

::: info Test Examples
Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).
:::

---

<Badge type="info" text="Navigation" /> [← Back to Index](/docs/api/)
