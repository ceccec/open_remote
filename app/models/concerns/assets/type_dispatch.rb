module Assets
  module TypeDispatch
    extend ActiveSupport::Concern

    included do
      after_find :extend_type_module
      after_initialize :extend_type_module
    end

    private

    def extend_type_module
      return unless asset_type

      mod = case asset_type.name
      when "SolarPark" then Assets::SolarParkAttributes
      when "SolarArray" then Assets::SolarArrayAttributes
      when "Inverter" then Assets::InverterAttributes
      when "EnergyMeter" then Assets::EnergyMeterAttributes
      when "WeatherStation" then Assets::WeatherStationAttributes
      when "GridConnectionPoint" then Assets::GridConnectionPointAttributes
      else nil
      end
      extend mod if mod && !is_a?(mod)
    end
  end
end
