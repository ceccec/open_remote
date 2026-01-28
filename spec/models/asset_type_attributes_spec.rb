require "rails_helper"

RSpec.describe "Asset type attribute helpers" do
  let(:asset_type) { AssetType.create!(name: "SolarPark", display_name: "Solar Park") }

  describe "Asset::Type attribute modules" do
    it "exposes energy meter attributes" do
      asset = Asset.new(
        name: "Meter",
        asset_type: asset_type,
        attributes_data: {
          "activePower" => 1,
          "reactivePower" => 2,
          "apparentPower" => 3,
          "energyImport" => 4,
          "energyExport" => 5,
          "voltage" => 6,
          "current" => 7,
          "powerFactor" => 8,
          "frequency" => 9
        }
      )
      asset.extend(Asset::Type::Energy::Meter::Attributes)

      expect(asset.active_power).to eq(1)
      expect(asset.reactive_power).to eq(2)
      expect(asset.apparent_power).to eq(3)
      expect(asset.energy_import).to eq(4)
      expect(asset.energy_export).to eq(5)
      expect(asset.voltage).to eq(6)
      expect(asset.current).to eq(7)
      expect(asset.power_factor).to eq(8)
      expect(asset.frequency).to eq(9)
    end

    it "exposes grid connection point attributes" do
      asset = Asset.new(
        name: "Grid",
        asset_type: asset_type,
        attributes_data: {
          "connectionCapacity" => 1,
          "activePower" => 2,
          "reactivePower" => 3,
          "voltage" => 4,
          "frequency" => 5,
          "energyExported" => 6,
          "energyImported" => 7,
          "connectionStatus" => "connected",
          "location" => "Point A"
        }
      )
      asset.extend(Asset::Type::Grid::Connection::Point::Attributes)

      expect(asset.connection_capacity).to eq(1)
      expect(asset.active_power).to eq(2)
      expect(asset.reactive_power).to eq(3)
      expect(asset.voltage).to eq(4)
      expect(asset.frequency).to eq(5)
      expect(asset.energy_exported).to eq(6)
      expect(asset.energy_imported).to eq(7)
      expect(asset.connection_status).to eq("connected")
      expect(asset.location).to eq("Point A")
    end

    it "exposes inverter attributes" do
      asset = Asset.new(
        name: "Inverter",
        asset_type: asset_type,
        attributes_data: {
          "inverterCapacity" => 1,
          "acPowerOutput" => 2,
          "dcPowerInput" => 3,
          "acVoltage" => 4,
          "acFrequency" => 5,
          "efficiency" => 6,
          "temperature" => 7,
          "uptime" => 8,
          "status" => "ok",
          "alarmStatus" => "none"
        }
      )
      asset.extend(Asset::Type::Inverter::Attributes)

      expect(asset.inverter_capacity).to eq(1)
      expect(asset.ac_power_output).to eq(2)
      expect(asset.dc_power_input).to eq(3)
      expect(asset.ac_voltage).to eq(4)
      expect(asset.ac_frequency).to eq(5)
      expect(asset.efficiency).to eq(6)
      expect(asset.temperature).to eq(7)
      expect(asset.uptime).to eq(8)
      expect(asset.status).to eq("ok")
      expect(asset.alarm_status).to eq("none")
    end

    it "exposes solar array attributes" do
      asset = Asset.new(
        name: "Array",
        asset_type: asset_type,
        attributes_data: {
          "arrayCapacity" => 1,
          "powerOutput" => 2,
          "voltage" => 3,
          "current" => 4,
          "panelCount" => 5,
          "panelOrientation" => "S",
          "panelTilt" => 30,
          "temperature" => 6,
          "status" => "ok",
          "location" => "Field"
        }
      )
      asset.extend(Asset::Type::Solar::Array::Attributes)

      expect(asset.array_capacity).to eq(1)
      expect(asset.power_output).to eq(2)
      expect(asset.dc_voltage).to eq(3)
      expect(asset.dc_current).to eq(4)
      expect(asset.panel_count).to eq(5)
      expect(asset.panel_orientation).to eq("S")
      expect(asset.panel_tilt).to eq(30)
      expect(asset.temperature).to eq(6)
      expect(asset.status).to eq("ok")
      expect(asset.location).to eq("Field")
    end

    it "exposes solar park attributes including update_performance_ratio!" do
      asset = Asset.new(
        name: "Park",
        asset_type: asset_type,
        attributes_data: {
          "totalCapacity" => 1000,
          "totalPowerOutput" => 500,
          "totalEnergyGenerated" => 2000,
          "dailyEnergyGenerated" => 100,
          "forecastedGeneration" => 2500,
          "performanceRatio" => 40,
          "location" => "Parkland"
        }
      )
      asset.extend(Asset::Type::Solar::Park::Attributes)

      expect(asset.total_capacity).to eq(1000)
      expect(asset.total_power_output).to eq(500)
      expect(asset.total_energy_generated).to eq(2000)
      expect(asset.daily_energy_generated).to eq(100)
      expect(asset.forecasted_generation).to eq(2500)
      expect(asset.performance_ratio).to eq(40)
      expect(asset.location).to eq("Parkland")

      # Exercise update_performance_ratio! branch
      allow(asset).to receive(:save!).and_return(true)
      asset.update_performance_ratio!
      expect(asset.attributes_data["performanceRatio"]).to be_within(0.001).of(50.0)
    end

    it "exposes solar park attributes via Asset::Type::SolarParkAttributes duplication module" do
      asset = Asset.new(
        name: "Park",
        asset_type: asset_type,
        attributes_data: {
          "totalCapacity" => 800,
          "totalPowerOutput" => 400,
          "totalEnergyGenerated" => 1600,
          "dailyEnergyGenerated" => 80,
          "forecastedGeneration" => 2000,
          "performanceRatio" => 30,
          "location" => "Duplicated"
        }
      )
      asset.extend(Asset::Type::SolarParkAttributes)

      expect(asset.total_capacity).to eq(800)
      expect(asset.total_power_output).to eq(400)
      expect(asset.total_energy_generated).to eq(1600)
      expect(asset.daily_energy_generated).to eq(80)
      expect(asset.forecasted_generation).to eq(2000)
      expect(asset.performance_ratio).to eq(30)
      expect(asset.location).to eq("Duplicated")

      allow(asset).to receive(:save!).and_return(true)
      asset.update_performance_ratio!
      expect(asset.attributes_data["performanceRatio"]).to be_within(0.001).of(50.0)
    end
  end

  describe "Assets::* attribute concerns and type dispatch" do
    it "exposes energy meter attributes via Assets::EnergyMeterAttributes" do
      asset = Asset.new(
        name: "Meter",
        asset_type: asset_type,
        attributes_data: {
          "activePower" => 1,
          "reactivePower" => 2,
          "apparentPower" => 3,
          "energyImport" => 4,
          "energyExport" => 5,
          "voltage" => 6,
          "current" => 7,
          "powerFactor" => 8,
          "frequency" => 9
        }
      )
      asset.extend(Assets::EnergyMeterAttributes)

      expect(asset.active_power).to eq(1)
      expect(asset.reactive_power).to eq(2)
      expect(asset.apparent_power).to eq(3)
      expect(asset.energy_import).to eq(4)
      expect(asset.energy_export).to eq(5)
      expect(asset.voltage).to eq(6)
      expect(asset.current).to eq(7)
      expect(asset.power_factor).to eq(8)
      expect(asset.frequency).to eq(9)
    end

    it "exposes grid connection point attributes via Assets::GridConnectionPointAttributes" do
      asset = Asset.new(
        name: "Grid",
        asset_type: asset_type,
        attributes_data: {
          "connectionCapacity" => 1,
          "activePower" => 2,
          "reactivePower" => 3,
          "voltage" => 4,
          "frequency" => 5,
          "energyExported" => 6,
          "energyImported" => 7,
          "connectionStatus" => "connected",
          "location" => "Point A"
        }
      )
      asset.extend(Assets::GridConnectionPointAttributes)

      expect(asset.connection_capacity).to eq(1)
      expect(asset.active_power).to eq(2)
      expect(asset.reactive_power).to eq(3)
      expect(asset.voltage).to eq(4)
      expect(asset.frequency).to eq(5)
      expect(asset.energy_exported).to eq(6)
      expect(asset.energy_imported).to eq(7)
      expect(asset.connection_status).to eq("connected")
      expect(asset.location).to eq("Point A")
    end

    it "exposes inverter attributes via Assets::InverterAttributes" do
      asset = Asset.new(
        name: "Inverter",
        asset_type: asset_type,
        attributes_data: {
          "inverterCapacity" => 1,
          "acPowerOutput" => 2,
          "dcPowerInput" => 3,
          "acVoltage" => 4,
          "acFrequency" => 5,
          "efficiency" => 6,
          "temperature" => 7,
          "uptime" => 8,
          "status" => "ok",
          "alarmStatus" => "none"
        }
      )
      asset.extend(Assets::InverterAttributes)

      expect(asset.inverter_capacity).to eq(1)
      expect(asset.ac_power_output).to eq(2)
      expect(asset.dc_power_input).to eq(3)
      expect(asset.ac_voltage).to eq(4)
      expect(asset.ac_frequency).to eq(5)
      expect(asset.efficiency).to eq(6)
      expect(asset.temperature).to eq(7)
      expect(asset.uptime).to eq(8)
      expect(asset.status).to eq("ok")
      expect(asset.alarm_status).to eq("none")
    end

    it "exposes solar array attributes via Assets::SolarArrayAttributes" do
      asset = Asset.new(
        name: "Array",
        asset_type: asset_type,
        attributes_data: {
          "arrayCapacity" => 1,
          "powerOutput" => 2,
          "voltage" => 3,
          "current" => 4,
          "panelCount" => 5,
          "panelOrientation" => "S",
          "panelTilt" => 30,
          "temperature" => 6,
          "status" => "ok",
          "location" => "Field"
        }
      )
      asset.extend(Assets::SolarArrayAttributes)

      expect(asset.array_capacity).to eq(1)
      expect(asset.power_output).to eq(2)
      expect(asset.dc_voltage).to eq(3)
      expect(asset.dc_current).to eq(4)
      expect(asset.panel_count).to eq(5)
      expect(asset.panel_orientation).to eq("S")
      expect(asset.panel_tilt).to eq(30)
      expect(asset.temperature).to eq(6)
      expect(asset.status).to eq("ok")
      expect(asset.location).to eq("Field")
    end

    it "exposes solar park attributes via Assets::SolarParkAttributes" do
      asset = Asset.new(
        name: "Park",
        asset_type: asset_type,
        attributes_data: {
          "totalCapacity" => 1000,
          "totalPowerOutput" => 500,
          "totalEnergyGenerated" => 2000,
          "dailyEnergyGenerated" => 100,
          "forecastedGeneration" => 2500,
          "performanceRatio" => 40,
          "location" => "Parkland"
        }
      )
      asset.extend(Assets::SolarParkAttributes)

      expect(asset.total_capacity).to eq(1000)
      expect(asset.total_power_output).to eq(500)
      expect(asset.total_energy_generated).to eq(2000)
      expect(asset.daily_energy_generated).to eq(100)
      expect(asset.forecasted_generation).to eq(2500)
      expect(asset.performance_ratio).to eq(40)
      expect(asset.location).to eq("Parkland")
    end

    it "extends the correct module via Assets::TypeDispatch for all asset types" do
      solar_park_type = AssetType.create!(name: "SolarPark", display_name: "Solar Park")
      solar_array_type = AssetType.create!(name: "SolarArray", display_name: "Solar Array")
      inverter_type = AssetType.create!(name: "Inverter", display_name: "Inverter")
      meter_type = AssetType.create!(name: "EnergyMeter", display_name: "Energy Meter")
      weather_type = AssetType.create!(name: "WeatherStation", display_name: "Weather Station")
      grid_type = AssetType.create!(name: "GridConnectionPoint", display_name: "Grid Connection Point")

      klass = Class.new(Asset) do
        include Assets::TypeDispatch
      end

      park = klass.create!(
        name: "Park",
        asset_type: solar_park_type,
        attributes_data: { "totalCapacity" => 1000 }
      )
      array = klass.create!(
        name: "Array",
        asset_type: solar_array_type,
        attributes_data: { "arrayCapacity" => 100 }
      )
      inverter = klass.create!(
        name: "Inverter",
        asset_type: inverter_type,
        attributes_data: { "inverterCapacity" => 10 }
      )
      meter = klass.create!(
        name: "Meter",
        asset_type: meter_type,
        attributes_data: { "activePower" => 1 }
      )
      weather = klass.create!(
        name: "Weather",
        asset_type: weather_type,
        attributes_data: { "temperature" => 20 }
      )
      grid = klass.create!(
        name: "Grid",
        asset_type: grid_type,
        attributes_data: { "connectionCapacity" => 50 }
      )

      expect(park.total_capacity).to eq(1000)
      expect(array.array_capacity).to eq(100)
      expect(inverter.inverter_capacity).to eq(10)
      expect(meter.active_power).to eq(1)
      expect(weather.temperature).to eq(20)
      expect(grid.connection_capacity).to eq(50)
    end

    it "reads weather station attributes from the concern" do
      asset = Asset.new(
        name: "Weather",
        asset_type: asset_type,
        attributes_data: {
          "temperature" => 1,
          "humidity" => 2,
          "pressure" => 3,
          "windSpeed" => 4,
          "windDirection" => 5,
          "solarIrradiance" => 6,
          "cloudCover" => 7,
          "visibility" => 8,
          "location" => "Station"
        }
      )
      asset.extend(Assets::WeatherStationAttributes)

      expect(asset.temperature).to eq(1)
      expect(asset.humidity).to eq(2)
      expect(asset.pressure).to eq(3)
      expect(asset.wind_speed).to eq(4)
      expect(asset.wind_direction).to eq(5)
      expect(asset.solar_irradiance).to eq(6)
      expect(asset.cloud_cover).to eq(7)
      expect(asset.visibility).to eq(8)
      expect(asset.location).to eq("Station")
    end
  end
end
