##
# Attribute accessors for GridConnectionPoint asset type.
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
          module Attributes
            ##
            # Get the connection capacity in watts.
            #
            # @return [Numeric, nil] capacity from attributes_data["connectionCapacity"]
            def connection_capacity
              (attributes_data || {})["connectionCapacity"]
            end

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
            # Get the voltage in volts.
            #
            # @return [Numeric, nil] voltage from attributes_data["voltage"]
            def voltage
              (attributes_data || {})["voltage"]
            end

            ##
            # Get the frequency in hertz.
            #
            # @return [Numeric, nil] frequency from attributes_data["frequency"]
            def frequency
              (attributes_data || {})["frequency"]
            end

            ##
            # Get the total energy exported to the grid in watt-hours.
            #
            # @return [Numeric, nil] energy exported from attributes_data["energyExported"]
            def energy_exported
              (attributes_data || {})["energyExported"]
            end

            ##
            # Get the total energy imported from the grid in watt-hours.
            #
            # @return [Numeric, nil] energy imported from attributes_data["energyImported"]
            def energy_imported
              (attributes_data || {})["energyImported"]
            end

            ##
            # Get the connection status (e.g., "connected", "disconnected", "fault").
            #
            # @return [String, nil] status from attributes_data["connectionStatus"]
            def connection_status
              (attributes_data || {})["connectionStatus"]
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
end
