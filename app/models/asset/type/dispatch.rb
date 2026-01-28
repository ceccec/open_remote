class Asset
  module Type
    module Dispatch
      extend ActiveSupport::Concern

      included do
        after_find :extend_type_module
        after_initialize :extend_type_module
      end

      private

      def extend_type_module
        return unless asset_type

        mod = case asset_type.name
        when "SolarPark" then Asset::Type::Solar::Park::Attributes
        when "SolarArray" then Asset::Type::Solar::Array::Attributes
        when "Inverter" then Asset::Type::Inverter::Attributes
        when "EnergyMeter" then Asset::Type::Energy::Meter::Attributes
        when "WeatherStation" then Asset::Type::Weather::Station::Attributes
        when "GridConnectionPoint" then Asset::Type::Grid::Connection::Point::Attributes
        end
        extend mod if mod && !is_a?(mod)
      end
    end
  end
end
