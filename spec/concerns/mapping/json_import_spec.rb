require "rails_helper"

RSpec.describe Mapping::JsonImport, type: :concern do
  let(:asset_type) { AssetType.create!(name: "SolarPark") }
  let(:parent_asset) { Asset.create!(name: "Parent", asset_type: asset_type, attributes_data: {}) }

  describe ".from_openremote_json" do
    it "creates asset from OpenRemote JSON node" do
      json_node = {
        "name" => "Test Asset",
        "type" => "SolarPark",
        "attributes" => {
          "powerOutput" => { "value" => 100.0 }
        }
      }

      asset = Asset.from_openremote_json(json_node)

      expect(asset).to be_persisted
      expect(asset.name).to eq("Test Asset")
      expect(asset.asset_type.name).to eq("SolarPark")
      expect(asset.attributes_data["powerOutput"]).to eq(100.0)
    end

    it "creates nested children assets" do
      json_node = {
        "name" => "Parent",
        "type" => "SolarPark",
        "attributes" => {},
        "children" => [
          {
            "name" => "Child",
            "type" => "SolarArray",
            "attributes" => { "powerOutput" => { "value" => 50.0 } }
          }
        ]
      }

      parent = Asset.from_openremote_json(json_node)
      child = parent.children.first

      expect(child).to be_persisted
      expect(child.name).to eq("Child")
      expect(child.parent).to eq(parent)
      expect(child.attributes_data["powerOutput"]).to eq(50.0)
    end

    it "handles missing attributes gracefully" do
      json_node = {
        "name" => "Test",
        "type" => "SolarPark"
      }

      asset = Asset.from_openremote_json(json_node)

      expect(asset.attributes_data).to eq({})
    end

    it "uses existing asset type if present" do
      AssetType.create!(name: "ExistingType")
      json_node = {
        "name" => "Test",
        "type" => "ExistingType",
        "attributes" => {}
      }

      expect do
        Asset.from_openremote_json(json_node)
      end.not_to change(AssetType, :count)
    end
  end
end
