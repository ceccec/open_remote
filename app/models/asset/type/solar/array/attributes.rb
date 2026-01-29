##
# Attribute accessors for SolarArray asset type.
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
      module Array
        module Attributes
          ##
          # Get the array capacity in watts.
          #
          # @return [Numeric, nil] capacity value from attributes_data["arrayCapacity"]
          def array_capacity
            (attributes_data || {})["arrayCapacity"]
          end

          ##
          # Get the current power output in watts.
          #
          # @return [Numeric, nil] power output value from attributes_data["powerOutput"]
          def power_output
            (attributes_data || {})["powerOutput"]
          end

          ##
          # Get the DC voltage in volts.
          #
          # @return [Numeric, nil] voltage value from attributes_data["voltage"]
          def dc_voltage
            (attributes_data || {})["voltage"]
          end

          ##
          # Get the DC current in amperes.
          #
          # @return [Numeric, nil] current value from attributes_data["current"]
          def dc_current
            (attributes_data || {})["current"]
          end

          ##
          # Get the number of solar panels in the array.
          #
          # @return [Integer, nil] panel count from attributes_data["panelCount"]
          def panel_count
            (attributes_data || {})["panelCount"]
          end

          ##
          # Get the panel orientation (e.g., "South", "East", "West").
          #
          # @return [String, nil] orientation from attributes_data["panelOrientation"]
          def panel_orientation
            (attributes_data || {})["panelOrientation"]
          end

          ##
          # Get the panel tilt angle in degrees.
          #
          # @return [Numeric, nil] tilt angle from attributes_data["panelTilt"]
          def panel_tilt
            (attributes_data || {})["panelTilt"]
          end

          ##
          # Get the current temperature in Celsius.
          #
          # @return [Numeric, nil] temperature from attributes_data["temperature"]
          def temperature
            (attributes_data || {})["temperature"]
          end

          ##
          # Get the operational status (e.g., "active", "maintenance").
          #
          # @return [String, nil] status from attributes_data["status"]
          def status
            (attributes_data || {})["status"]
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
