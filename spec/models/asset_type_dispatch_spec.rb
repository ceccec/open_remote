require "rails_helper"

RSpec.describe "Asset::Type::Dispatch", type: :model do
  describe "extend_type_module callback" do
    it "extends SolarPark asset with Asset::Type::Solar::Park::Attributes" do
      asset_type = AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" }
      asset = Asset.new(
        name: "Test Park",
        asset_type: asset_type,
        attributes_data: { "totalCapacity" => 1000 }
      )

      expect(asset).to respond_to(:total_capacity)
      expect(asset).to respond_to(:update_performance_ratio!)
      expect(asset.total_capacity).to eq(1000)
    end

    it "extends SolarArray asset with Asset::Type::Solar::Array::Attributes" do
      asset_type = AssetType.find_or_create_by!(name: "SolarArray") { |at| at.display_name = "Solar Array" }
      asset = Asset.new(
        name: "Test Array",
        asset_type: asset_type,
        attributes_data: { "arrayCapacity" => 500 }
      )

      expect(asset).to respond_to(:array_capacity)
      expect(asset.array_capacity).to eq(500)
    end

    it "extends Inverter asset with Asset::Type::Inverter::Attributes" do
      asset_type = AssetType.find_or_create_by!(name: "Inverter") { |at| at.display_name = "Inverter" }
      asset = Asset.new(
        name: "Test Inverter",
        asset_type: asset_type,
        attributes_data: { "inverterCapacity" => 100 }
      )

      expect(asset).to respond_to(:inverter_capacity)
      expect(asset.inverter_capacity).to eq(100)
    end

    it "extends EnergyMeter asset with Asset::Type::Energy::Meter::Attributes" do
      asset_type = AssetType.find_or_create_by!(name: "EnergyMeter") { |at| at.display_name = "Energy Meter" }
      asset = Asset.new(
        name: "Test Meter",
        asset_type: asset_type,
        attributes_data: { "activePower" => 50 }
      )

      expect(asset).to respond_to(:active_power)
      expect(asset.active_power).to eq(50)
    end

    it "extends WeatherStation asset with Asset::Type::Weather::Station::Attributes" do
      asset_type = AssetType.find_or_create_by!(name: "WeatherStation") { |at| at.display_name = "Weather Station" }
      asset = Asset.new(
        name: "Test Station",
        asset_type: asset_type,
        attributes_data: { "temperature" => 25 }
      )

      expect(asset).to respond_to(:temperature)
      expect(asset.temperature).to eq(25)
    end

    it "extends GridConnectionPoint asset with Asset::Type::Grid::Connection::Point::Attributes" do
      asset_type = AssetType.find_or_create_by!(name: "GridConnectionPoint") { |at| at.display_name = "Grid Connection Point" }
      asset = Asset.new(
        name: "Test Point",
        asset_type: asset_type,
        attributes_data: { "connectionCapacity" => 1000 }
      )

      expect(asset).to respond_to(:connection_capacity)
      expect(asset.connection_capacity).to eq(1000)
    end

    it "does not extend when asset_type is nil" do
      asset = Asset.new(
        name: "Test Asset",
        attributes_data: {}
      )

      expect(asset).not_to respond_to(:total_capacity)
    end

    it "does not extend when asset_type name is unknown" do
      asset_type = AssetType.find_or_create_by!(name: "UnknownType") { |at| at.display_name = "Unknown" }
      asset = Asset.new(
        name: "Test Asset",
        asset_type: asset_type,
        attributes_data: {}
      )

      expect(asset).not_to respond_to(:total_capacity)
    end

    it "extends module on after_find callback" do
      asset_type = AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" }
      asset = Asset.create!(
        name: "Test Park",
        asset_type: asset_type,
        attributes_data: { "totalCapacity" => 1000 }
      )

      # Reload to trigger after_find
      reloaded = Asset.find(asset.id)
      expect(reloaded).to respond_to(:total_capacity)
      expect(reloaded.total_capacity).to eq(1000)
    end

    it "extends module on after_initialize callback" do
      asset_type = AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" }
      asset = Asset.new(
        name: "Test Park",
        asset_type: asset_type,
        attributes_data: { "totalCapacity" => 1000 }
      )

      expect(asset).to respond_to(:total_capacity)
    end

    it "does not extend module if already extended" do
      asset_type = AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" }
      asset = Asset.new(
        name: "Test Park",
        asset_type: asset_type,
        attributes_data: { "totalCapacity" => 1000 }
      )

      # First extension
      expect(asset).to respond_to(:total_capacity)
      original_method = asset.method(:total_capacity)

      # Trigger callback again (should not re-extend)
      asset.send(:extend_type_module)
      expect(asset.method(:total_capacity)).to eq(original_method)
    end
  end
end
