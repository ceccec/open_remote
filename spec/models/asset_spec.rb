require "rails_helper"

RSpec.describe Asset, type: :model do
  let(:asset_type) { AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" } }

  describe "validations" do
    it "is valid with valid attributes" do
      asset = Asset.new(
        name: "Test Park",
        asset_type: asset_type,
        attributes_data: { "totalCapacity" => 1000 }
      )
      expect(asset).to be_valid
    end

    it "is invalid without name" do
      asset = Asset.new(asset_type: asset_type, attributes_data: {})
      expect(asset).not_to be_valid
      expect(asset.errors[:name]).to include("can't be blank")
    end

    it "is invalid when attributes_data is nil" do
      asset = Asset.new(name: "Test Park", asset_type: asset_type, attributes_data: nil)
      expect(asset).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to asset_type" do
      asset = Asset.create!(
        name: "Test Park",
        asset_type: asset_type,
        attributes_data: {}
      )
      expect(asset.asset_type).to eq(asset_type)
    end

    it "belongs to parent asset" do
      parent = Asset.create!(
        name: "Parent Park",
        asset_type: asset_type,
        attributes_data: {}
      )
      child = Asset.create!(
        name: "Child Array",
        asset_type: asset_type,
        parent: parent,
        attributes_data: {}
      )
      expect(child.parent).to eq(parent)
      expect(parent.children).to include(child)
    end

    it "has many data_points" do
      asset = Asset.create!(
        name: "Test Park",
        asset_type: asset_type,
        attributes_data: {}
      )
      data_point = DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 100 },
        timestamp: Time.current
      )
      expect(asset.data_points).to include(data_point)
    end
  end

  describe "Mapping::JsonImport" do
    it "imports asset from OpenRemote JSON" do
      json_node = {
        "name" => "Imported Park",
        "type" => "SolarPark",
        "attributes" => {
          "totalCapacity" => { "value" => 5000 }
        },
        "children" => [
          {
            "name" => "Array 1",
            "type" => "SolarArray",
            "attributes" => {
              "arrayCapacity" => { "value" => 1000 }
            }
          }
        ]
      }

      AssetType.find_or_create_by!(name: "SolarArray") { |at| at.display_name = "Solar Array" }

      asset = Asset.from_openremote_json(json_node, parent: nil)
      expect(asset.name).to eq("Imported Park")
      expect(asset.attributes_data["totalCapacity"]).to eq(5000)
      expect(asset.children.count).to eq(1)
      expect(asset.children.first.name).to eq("Array 1")
    end
  end

  describe "Mapping::JsonExport" do
    it "exports asset to OpenRemote JSON tree" do
      parent = Asset.create!(
        name: "Parent Park",
        asset_type: asset_type,
        attributes_data: { "totalCapacity" => 5000 }
      )
      child = Asset.create!(
        name: "Child Array",
        asset_type: AssetType.find_or_create_by!(name: "SolarArray") { |at| at.display_name = "Solar Array" },
        parent: parent,
        attributes_data: { "arrayCapacity" => 1000 }
      )

      json = parent.to_openremote_json_tree
      expect(json["name"]).to eq("Parent Park")
      expect(json["type"]).to eq("SolarPark")
      expect(json["attributes"]["totalCapacity"]["value"]).to eq(5000)
      expect(json["children"].count).to eq(1)
      expect(json["children"].first["name"]).to eq("Child Array")
    end
  end

  describe "Assets::Querying" do
    before do
      @solar_park_type = AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" }
      @solar_array_type = AssetType.find_or_create_by!(name: "SolarArray") { |at| at.display_name = "Solar Array" }
    end

    it "finds solar arrays" do
      park = Asset.create!(name: "Park", asset_type: @solar_park_type, attributes_data: {})
      array = Asset.create!(name: "Array", asset_type: @solar_array_type, attributes_data: {})
      expect(Asset.solar_arrays).to include(array)
      expect(Asset.solar_arrays).not_to include(park)
    end

    it "finds solar parks" do
      park = Asset.create!(name: "Park", asset_type: @solar_park_type, attributes_data: {})
      array = Asset.create!(name: "Array", asset_type: @solar_array_type, attributes_data: {})
      expect(Asset.solar_parks).to include(park)
      expect(Asset.solar_parks).not_to include(array)
    end

    it "finds assets of specific type" do
      park = Asset.create!(name: "Park", asset_type: @solar_park_type, attributes_data: {})
      expect(Asset.of_type("SolarPark")).to include(park)
    end

    it "returns solar array power outputs as id and float pairs" do
      array1 = Asset.create!(
        name: "Array 1",
        asset_type: @solar_array_type,
        attributes_data: { "powerOutput" => 100 }
      )
      array2 = Asset.create!(
        name: "Array 2",
        asset_type: @solar_array_type,
        attributes_data: { "powerOutput" => 200 }
      )
      _park = Asset.create!(name: "Park", asset_type: @solar_park_type, attributes_data: {})

      pairs = Asset.solar_array_power_outputs

      expect(pairs.size).to eq(2)
      expect(pairs.map(&:last)).to contain_exactly(100.0, 200.0)
    end

    it "filters assets by numeric attribute greater than a threshold" do
      high = Asset.create!(
        name: "High Output",
        asset_type: @solar_park_type,
        attributes_data: { "totalPowerOutput" => 1000 }
      )
      low = Asset.create!(
        name: "Low Output",
        asset_type: @solar_park_type,
        attributes_data: { "totalPowerOutput" => 100 }
      )

      result = Asset.with_numeric_attribute_greater_than("totalPowerOutput", 500)

      expect(result).to include(high)
      expect(result).not_to include(low)
    end
  end

  describe "#attributes_data_pretty_json" do
    it "returns a pretty-printed JSON string of attributes_data" do
      asset = Asset.create!(
        name: "Pretty Park",
        asset_type: asset_type,
        attributes_data: { "key" => "value" }
      )

      json = asset.attributes_data_pretty_json
      expect(json).to include("\"key\"")
      expect(json).to include("\"value\"")
    end
  end
end
