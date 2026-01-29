##
# Attribute accessors for WeatherStation asset type.
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
        module Attributes
          ##
          # Get the current temperature in Celsius.
          #
          # @return [Numeric, nil] temperature from attributes_data["temperature"]
          def temperature
            (attributes_data || {})["temperature"]
          end

          ##
          # Get the relative humidity as a percentage (0-100).
          #
          # @return [Numeric, nil] humidity from attributes_data["humidity"]
          def humidity
            (attributes_data || {})["humidity"]
          end

          ##
          # Get the atmospheric pressure in hectopascals (hPa).
          #
          # @return [Numeric, nil] pressure from attributes_data["pressure"]
          def pressure
            (attributes_data || {})["pressure"]
          end

          ##
          # Get the wind speed in meters per second.
          #
          # @return [Numeric, nil] wind speed from attributes_data["windSpeed"]
          def wind_speed
            (attributes_data || {})["windSpeed"]
          end

          ##
          # Get the wind direction in degrees (0-360, where 0 is North).
          #
          # @return [Numeric, nil] wind direction from attributes_data["windDirection"]
          def wind_direction
            (attributes_data || {})["windDirection"]
          end

          ##
          # Get the solar irradiance in watts per square meter.
          #
          # @return [Numeric, nil] irradiance from attributes_data["solarIrradiance"]
          def solar_irradiance
            (attributes_data || {})["solarIrradiance"]
          end

          ##
          # Get the cloud cover as a percentage (0-100).
          #
          # @return [Numeric, nil] cloud cover from attributes_data["cloudCover"]
          def cloud_cover
            (attributes_data || {})["cloudCover"]
          end

          ##
          # Get the visibility in meters.
          #
          # @return [Numeric, nil] visibility from attributes_data["visibility"]
          def visibility
            (attributes_data || {})["visibility"]
          end

          ##
          # Get the geographic location.
          #
          # @return [String, Hash, nil] location from attributes_data["location"]
          def location
            (attributes_data || {})["location"]
          end
        end
      end
    end
  end
end
