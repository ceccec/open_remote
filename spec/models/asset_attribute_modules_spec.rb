require "rails_helper"

RSpec.describe "Asset Attribute Modules", type: :model do
  describe "Asset::Type::Solar::Park::Attributes" do
    let(:asset_type) { AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" } }
    let(:asset) do
      Asset.create!(
        name: "Test Park",
        asset_type: asset_type,
        attributes_data: {
          "totalCapacity" => 1000,
          "totalPowerOutput" => 800,
          "totalEnergyGenerated" => 5000,
          "dailyEnergyGenerated" => 100,
          "forecastedGeneration" => 120,
          "performanceRatio" => 80.0,
          "location" => "Test Location"
        }
      )
    end

    it "provides total_capacity accessor" do
      expect(asset.total_capacity).to eq(1000)
    end

    it "provides total_power_output accessor" do
      expect(asset.total_power_output).to eq(800)
    end

    it "provides total_energy_generated accessor" do
      expect(asset.total_energy_generated).to eq(5000)
    end

    it "provides daily_energy_generated accessor" do
      expect(asset.daily_energy_generated).to eq(100)
    end

    it "provides forecasted_generation accessor" do
      expect(asset.forecasted_generation).to eq(120)
    end

    it "provides performance_ratio accessor" do
      expect(asset.performance_ratio).to eq(80.0)
    end

    it "provides location accessor" do
      expect(asset.location).to eq("Test Location")
    end

    it "returns nil for missing attributes" do
      asset.attributes_data = {}
      expect(asset.total_capacity).to be_nil
    end

    describe "#update_performance_ratio!" do
      it "calculates and updates performance ratio when capacity is positive" do
        asset.attributes_data = {
          "totalCapacity" => 1000,
          "totalPowerOutput" => 750
        }
        asset.update_performance_ratio!

        expect(asset.performance_ratio).to eq(75.0)
        expect(asset.reload.attributes_data["performanceRatio"]).to eq(75.0)
      end

      it "does not update when capacity is zero" do
        asset.attributes_data = {
          "totalCapacity" => 0,
          "totalPowerOutput" => 750
        }
        original_ratio = asset.attributes_data["performanceRatio"]

        asset.update_performance_ratio!
        expect(asset.attributes_data["performanceRatio"]).to eq(original_ratio)
      end

      it "does not update when capacity is negative" do
        asset.attributes_data = {
          "totalCapacity" => -100,
          "totalPowerOutput" => 750
        }
        original_ratio = asset.attributes_data["performanceRatio"]

        asset.update_performance_ratio!
        expect(asset.attributes_data["performanceRatio"]).to eq(original_ratio)
      end

      it "does not update when capacity is nil" do
        asset.attributes_data = {
          "totalPowerOutput" => 750
        }
        original_ratio = asset.attributes_data["performanceRatio"]

        asset.update_performance_ratio!
        expect(asset.attributes_data["performanceRatio"]).to eq(original_ratio)
      end

      it "handles string numeric values" do
        asset.attributes_data = {
          "totalCapacity" => "1000",
          "totalPowerOutput" => "800"
        }
        asset.update_performance_ratio!

        expect(asset.performance_ratio).to eq(80.0)
      end
    end
  end

  describe "Asset::Type::Solar::Array::Attributes" do
    let(:asset_type) { AssetType.find_or_create_by!(name: "SolarArray") { |at| at.display_name = "Solar Array" } }
    let(:asset) do
      Asset.create!(
        name: "Test Array",
        asset_type: asset_type,
        attributes_data: {
          "arrayCapacity" => 500,
          "powerOutput" => 400,
          "voltage" => 600,
          "current" => 10,
          "panelCount" => 100,
          "panelOrientation" => "South",
          "panelTilt" => 30,
          "temperature" => 25,
          "status" => "active",
          "location" => "Array Location"
        }
      )
    end

    it "provides all attribute accessors" do
      expect(asset.array_capacity).to eq(500)
      expect(asset.power_output).to eq(400)
      expect(asset.dc_voltage).to eq(600)
      expect(asset.dc_current).to eq(10)
      expect(asset.panel_count).to eq(100)
      expect(asset.panel_orientation).to eq("South")
      expect(asset.panel_tilt).to eq(30)
      expect(asset.temperature).to eq(25)
      expect(asset.status).to eq("active")
      expect(asset.location).to eq("Array Location")
    end
  end

  describe "Asset::Type::Inverter::Attributes" do
    let(:asset_type) { AssetType.find_or_create_by!(name: "Inverter") { |at| at.display_name = "Inverter" } }
    let(:asset) do
      Asset.create!(
        name: "Test Inverter",
        asset_type: asset_type,
        attributes_data: {
          "inverterCapacity" => 100,
          "acPowerOutput" => 90,
          "dcPowerInput" => 95,
          "acVoltage" => 230,
          "acFrequency" => 50,
          "efficiency" => 94.7,
          "temperature" => 40,
          "uptime" => 8760,
          "status" => "operational",
          "alarmStatus" => "normal"
        }
      )
    end

    it "provides all attribute accessors" do
      expect(asset.inverter_capacity).to eq(100)
      expect(asset.ac_power_output).to eq(90)
      expect(asset.dc_power_input).to eq(95)
      expect(asset.ac_voltage).to eq(230)
      expect(asset.ac_frequency).to eq(50)
      expect(asset.efficiency).to eq(94.7)
      expect(asset.temperature).to eq(40)
      expect(asset.uptime).to eq(8760)
      expect(asset.status).to eq("operational")
      expect(asset.alarm_status).to eq("normal")
    end
  end

  describe "Asset::Type::Energy::Meter::Attributes" do
    let(:asset_type) { AssetType.find_or_create_by!(name: "EnergyMeter") { |at| at.display_name = "Energy Meter" } }
    let(:asset) do
      Asset.create!(
        name: "Test Meter",
        asset_type: asset_type,
        attributes_data: {
          "activePower" => 1000,
          "reactivePower" => 200,
          "apparentPower" => 1020,
          "energyImport" => 5000,
          "energyExport" => 3000,
          "voltage" => 230,
          "current" => 5,
          "powerFactor" => 0.98,
          "frequency" => 50
        }
      )
    end

    it "provides all attribute accessors" do
      expect(asset.active_power).to eq(1000)
      expect(asset.reactive_power).to eq(200)
      expect(asset.apparent_power).to eq(1020)
      expect(asset.energy_import).to eq(5000)
      expect(asset.energy_export).to eq(3000)
      expect(asset.voltage).to eq(230)
      expect(asset.current).to eq(5)
      expect(asset.power_factor).to eq(0.98)
      expect(asset.frequency).to eq(50)
    end
  end

  describe "Asset::Type::Weather::Station::Attributes" do
    let(:asset_type) { AssetType.find_or_create_by!(name: "WeatherStation") { |at| at.display_name = "Weather Station" } }
    let(:asset) do
      Asset.create!(
        name: "Test Station",
        asset_type: asset_type,
        attributes_data: {
          "temperature" => 25.5,
          "humidity" => 60,
          "pressure" => 1013.25,
          "windSpeed" => 10.5,
          "windDirection" => 180,
          "solarIrradiance" => 800,
          "cloudCover" => 30,
          "visibility" => 10,
          "location" => "Station Location"
        }
      )
    end

    it "provides all attribute accessors" do
      expect(asset.temperature).to eq(25.5)
      expect(asset.humidity).to eq(60)
      expect(asset.pressure).to eq(1013.25)
      expect(asset.wind_speed).to eq(10.5)
      expect(asset.wind_direction).to eq(180)
      expect(asset.solar_irradiance).to eq(800)
      expect(asset.cloud_cover).to eq(30)
      expect(asset.visibility).to eq(10)
      expect(asset.location).to eq("Station Location")
    end
  end

  describe "Asset::Type::Grid::Connection::Point::Attributes" do
    let(:asset_type) { AssetType.find_or_create_by!(name: "GridConnectionPoint") { |at| at.display_name = "Grid Connection Point" } }
    let(:asset) do
      Asset.create!(
        name: "Test Point",
        asset_type: asset_type,
        attributes_data: {
          "connectionCapacity" => 1000,
          "activePower" => 800,
          "reactivePower" => 100,
          "voltage" => 400,
          "frequency" => 50,
          "energyExported" => 50000,
          "energyImported" => 30000,
          "connectionStatus" => "connected",
          "location" => "Grid Location"
        }
      )
    end

    it "provides all attribute accessors" do
      expect(asset.connection_capacity).to eq(1000)
      expect(asset.active_power).to eq(800)
      expect(asset.reactive_power).to eq(100)
      expect(asset.voltage).to eq(400)
      expect(asset.frequency).to eq(50)
      expect(asset.energy_exported).to eq(50000)
      expect(asset.energy_imported).to eq(30000)
      expect(asset.connection_status).to eq("connected")
      expect(asset.location).to eq("Grid Location")
    end
  end
end
