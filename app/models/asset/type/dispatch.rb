##
# Dynamic type module dispatch for Asset model.
#
# Automatically extends Asset instances with type-specific attribute accessors
# based on their asset_type. This allows assets to have type-specific methods
# (e.g., `power_output` for SolarArray) without requiring explicit inheritance.
#
# The module is extended after finding or initializing an asset, ensuring
# type-specific methods are available immediately.
#
# @example Type-specific methods
#   solar_array = Asset.find_by(name: "Array 1")
#   solar_array.power_output  # Available because asset_type.name == "SolarArray"
#   solar_array.array_capacity # Also available for SolarArray
#
class Asset
  module Type
    module Dispatch
      extend ActiveSupport::Concern

      included do
        # Extend with type-specific module after finding or initializing
        # This ensures type-specific methods are available immediately
        after_find :extend_type_module
        after_initialize :extend_type_module
      end

      private

      ##
      # Dynamically extend this asset instance with type-specific attribute module.
      #
      # Maps asset_type.name to the corresponding Attributes module and extends
      # the instance, providing type-specific accessor methods for attributes_data.
      #
      # @return [void]
      def extend_type_module
        return unless asset_type

        # Map asset type names to their corresponding attribute modules
        mod = case asset_type.name
        when "SolarPark" then Asset::Type::Solar::Park::Attributes
        when "SolarArray" then Asset::Type::Solar::Array::Attributes
        when "Inverter" then Asset::Type::Inverter::Attributes
        when "EnergyMeter" then Asset::Type::Energy::Meter::Attributes
        when "WeatherStation" then Asset::Type::Weather::Station::Attributes
        when "GridConnectionPoint" then Asset::Type::Grid::Connection::Point::Attributes
        end

        # Extend instance with module if module exists and not already extended
        extend mod if mod && !is_a?(mod)
      end
    end
  end
end
