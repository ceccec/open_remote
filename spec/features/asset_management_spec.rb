# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Asset Management", type: :feature do
  describe "Hierarchical Asset Structure" do
    it "supports multi-level asset hierarchies with parent-child relationships" do
      # Create asset types
      solar_park_type = AssetType.create!(name: "SolarPark", display_name: "Solar Park")
      solar_array_type = AssetType.create!(name: "SolarArray", display_name: "Solar Array")
      inverter_type = AssetType.create!(name: "Inverter", display_name: "Inverter")

      # Create parent park
      park = Asset.create!(
        name: "Main Solar Park",
        asset_type: solar_park_type,
        attributes_data: {
          "totalCapacity" => 10_000,
          "totalPowerOutput" => 8500,
          "performanceRatio" => 0.85
        }
      )

      # Create child arrays
      array1 = Asset.create!(
        name: "Array 1",
        asset_type: solar_array_type,
        parent: park,
        attributes_data: {
          "arrayCapacity" => 5000,
          "powerOutput" => 4250
        }
      )

      array2 = Asset.create!(
        name: "Array 2",
        asset_type: solar_array_type,
        parent: park,
        attributes_data: {
          "arrayCapacity" => 5000,
          "powerOutput" => 4250
        }
      )

      # Create inverters under arrays
      inverter1 = Asset.create!(
        name: "Inverter 1A",
        asset_type: inverter_type,
        parent: array1,
        attributes_data: {
          "inverterCapacity" => 2500,
          "powerOutput" => 2125
        }
      )

      # Verify hierarchy
      expect(park.children).to contain_exactly(array1, array2)
      expect(array1.children).to contain_exactly(inverter1)
      expect(array1.parent).to eq(park)
      expect(inverter1.parent).to eq(array1)
      expect(Asset.root_assets).to include(park)
      expect(Asset.root_assets).not_to include(array1)
    end

    it "supports cascading deletion of child assets" do
      park = Asset.create!(
        name: "Park to Delete",
        asset_type: AssetType.create!(name: "SolarPark"),
        attributes_data: {}
      )

      array = Asset.create!(
        name: "Array to Delete",
        asset_type: AssetType.create!(name: "SolarArray"),
        parent: park,
        attributes_data: {}
      )

      expect do
        park.destroy
      end.to change { Asset.count }.by(-2)

      expect(Asset.find_by(id: array.id)).to be_nil
    end
  end

  describe "Type-Specific Attributes" do
    it "dynamically extends assets with type-specific methods" do
      solar_park_type = AssetType.create!(name: "SolarPark", display_name: "Solar Park")
      park = Asset.create!(
        name: "Test Park",
        asset_type: solar_park_type,
        attributes_data: {
          "totalCapacity" => 5000,
          "totalPowerOutput" => 4000
        }
      )

      # SolarPark assets should have type-specific methods
      expect(park).to respond_to(:total_capacity)
      expect(park).to respond_to(:total_power_output)
      expect(park).to respond_to(:update_performance_ratio!)

      expect(park.total_capacity).to eq(5000)
      expect(park.total_power_output).to eq(4000)

      # Update performance ratio
      park.update_performance_ratio!
      expect(park.attributes_data["performanceRatio"]).to be_within(0.01).of(0.8)
    end

    it "supports multiple asset types with different attributes" do
      # Solar Park
      solar_park_type = AssetType.create!(name: "SolarPark")
      park = Asset.create!(
        name: "Park",
        asset_type: solar_park_type,
        attributes_data: { "totalCapacity" => 1000 }
      )

      # Energy Meter
      meter_type = AssetType.create!(name: "EnergyMeter")
      meter = Asset.create!(
        name: "Meter",
        asset_type: meter_type,
        attributes_data: { "energyConsumed" => 500 }
      )

      # Weather Station
      weather_type = AssetType.create!(name: "WeatherStation")
      weather = Asset.create!(
        name: "Station",
        asset_type: weather_type,
        attributes_data: { "temperature" => 25.5, "humidity" => 60 }
      )

      expect(park.attributes_data.keys).to include("totalCapacity")
      expect(meter.attributes_data.keys).to include("energyConsumed")
      expect(weather.attributes_data.keys).to include("temperature", "humidity")
    end
  end

  describe "OpenRemote JSON Import/Export" do
    it "imports complete asset hierarchies from OpenRemote JSON format" do
      json_tree = {
        "name" => "Imported Solar Park",
        "type" => "SolarPark",
        "attributes" => {
          "totalCapacity" => { "value" => 20_000 },
          "totalPowerOutput" => { "value" => 18_000 }
        },
        "children" => [
          {
            "name" => "Array A",
            "type" => "SolarArray",
            "attributes" => {
              "arrayCapacity" => { "value" => 10_000 },
              "powerOutput" => { "value" => 9000 }
            },
            "children" => [
              {
                "name" => "Inverter A1",
                "type" => "Inverter",
                "attributes" => {
                  "inverterCapacity" => { "value" => 5000 }
                }
              }
            ]
          },
          {
            "name" => "Array B",
            "type" => "SolarArray",
            "attributes" => {
              "arrayCapacity" => { "value" => 10_000 }
            }
          }
        ]
      }

      # Create asset types
      AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" }
      AssetType.find_or_create_by!(name: "SolarArray") { |at| at.display_name = "Solar Array" }
      AssetType.find_or_create_by!(name: "Inverter") { |at| at.display_name = "Inverter" }

      park = Asset.from_openremote_json(json_tree)

      expect(park.name).to eq("Imported Solar Park")
      expect(park.attributes_data["totalCapacity"]).to eq(20_000)
      expect(park.children.count).to eq(2)
      # Find Array A by name (order may vary)
      array_a = park.children.find { |c| c.name == "Array A" }
      expect(array_a).to be_present
      expect(array_a.children.first.name).to eq("Inverter A1")
    end

    it "exports asset hierarchies to OpenRemote JSON format" do
      # Create types
      park_type = AssetType.create!(name: "SolarPark", display_name: "Solar Park")
      array_type = AssetType.create!(name: "SolarArray", display_name: "Solar Array")

      # Create hierarchy
      park = Asset.create!(
        name: "Export Park",
        asset_type: park_type,
        attributes_data: { "totalCapacity" => 5000 }
      )

      array = Asset.create!(
        name: "Export Array",
        asset_type: array_type,
        parent: park,
        attributes_data: { "arrayCapacity" => 2500 }
      )

      json = park.to_openremote_json_tree

      expect(json["name"]).to eq("Export Park")
      expect(json["type"]).to eq("SolarPark")
      expect(json["attributes"]["totalCapacity"]["value"]).to eq(5000)
      expect(json["children"].count).to eq(1)
      expect(json["children"].first["name"]).to eq("Export Array")
      expect(json["children"].first["attributes"]["arrayCapacity"]["value"]).to eq(2500)
    end
  end

  describe "Asset Querying" do
    it "provides powerful querying capabilities for asset discovery" do
      # Create types
      park_type = AssetType.create!(name: "SolarPark")
      array_type = AssetType.create!(name: "SolarArray")

      # Create parks with different capacities
      high_capacity_park = Asset.create!(
        name: "High Capacity Park",
        asset_type: park_type,
        attributes_data: { "totalPowerOutput" => 5000 }
      )

      low_capacity_park = Asset.create!(
        name: "Low Capacity Park",
        asset_type: park_type,
        attributes_data: { "totalPowerOutput" => 500 }
      )

      # Create arrays
      array1 = Asset.create!(
        name: "Array 1",
        asset_type: array_type,
        attributes_data: { "powerOutput" => 1000 }
      )

      array2 = Asset.create!(
        name: "Array 2",
        asset_type: array_type,
        attributes_data: { "powerOutput" => 2000 }
      )

      # Query by type
      expect(Asset.solar_parks).to contain_exactly(high_capacity_park, low_capacity_park)
      expect(Asset.solar_arrays).to contain_exactly(array1, array2)
      expect(Asset.of_type("SolarPark")).to contain_exactly(high_capacity_park, low_capacity_park)

      # Query by numeric attribute threshold
      high_output = Asset.with_numeric_attribute_greater_than("totalPowerOutput", 1000)
      expect(high_output).to include(high_capacity_park)
      expect(high_output).not_to include(low_capacity_park)

      # Get power outputs as ID-value pairs
      power_outputs = Asset.solar_array_power_outputs
      expect(power_outputs.map(&:last)).to contain_exactly(1000.0, 2000.0)
    end
  end
end
