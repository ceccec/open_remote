##
# Attribute accessors for EnergyMeter asset type.
#
# Provides convenient accessor methods for EnergyMeter-specific attributes
# stored in the attributes_data JSONB column. These methods are automatically
# available on Asset instances when asset_type.name == "EnergyMeter" via
# the Type::Dispatch concern.
#
# @example Accessing EnergyMeter attributes
#   meter = Asset.find_by(name: "Energy Meter 1")
#   meter.active_power    # => value from attributes_data["activePower"]
#   meter.energy_import   # => value from attributes_data["energyImport"]
#   meter.power_factor    # => value from attributes_data["powerFactor"]
#
class Asset
  module Type
    module Energy
      module Meter
        module Attributes
          ##
          # Get the active power (real power) in watts.
          #
          # @return [Numeric, nil] active power from attributes_data["activePower"]
          def active_power
            (attributes_data || {})["activePower"]
          end

          ##
          # Get the reactive power in volt-amperes reactive (VAR).
          #
          # @return [Numeric, nil] reactive power from attributes_data["reactivePower"]
          def reactive_power
            (attributes_data || {})["reactivePower"]
          end

          ##
          # Get the apparent power in volt-amperes (VA).
          #
          # @return [Numeric, nil] apparent power from attributes_data["apparentPower"]
          def apparent_power
            (attributes_data || {})["apparentPower"]
          end

          ##
          # Get the total energy imported in watt-hours.
          #
          # @return [Numeric, nil] energy import from attributes_data["energyImport"]
          def energy_import
            (attributes_data || {})["energyImport"]
          end

          ##
          # Get the total energy exported in watt-hours.
          #
          # @return [Numeric, nil] energy export from attributes_data["energyExport"]
          def energy_export
            (attributes_data || {})["energyExport"]
          end

          ##
          # Get the voltage in volts.
          #
          # @return [Numeric, nil] voltage from attributes_data["voltage"]
          def voltage
            (attributes_data || {})["voltage"]
          end

          ##
          # Get the current in amperes.
          #
          # @return [Numeric, nil] current from attributes_data["current"]
          def current
            (attributes_data || {})["current"]
          end

          ##
          # Get the power factor (ratio of active to apparent power).
          #
          # @return [Numeric, nil] power factor from attributes_data["powerFactor"] (typically 0.0 to 1.0)
          def power_factor
            (attributes_data || {})["powerFactor"]
          end

          ##
          # Get the frequency in hertz.
          #
          # @return [Numeric, nil] frequency from attributes_data["frequency"]
          def frequency
            (attributes_data || {})["frequency"]
          end
        end
      end
    end
  end
end
