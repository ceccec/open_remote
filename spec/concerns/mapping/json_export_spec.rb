require "rails_helper"

RSpec.describe Mapping::JsonExport, type: :concern do
  let(:asset_type) { AssetType.create!(name: "SolarPark") }
  let(:parent_asset) do
    Asset.create!(
      name: "Parent",
      asset_type: asset_type,
      attributes_data: { "powerOutput" => 100.0 }
    )
  end
  let(:child_asset) do
    Asset.create!(
      name: "Child",
      asset_type: asset_type,
      parent: parent_asset,
      attributes_data: { "powerOutput" => 50.0 }
    )
  end

  describe "#to_openremote_json_tree" do
    it "exports asset to OpenRemote JSON format" do
      json = parent_asset.to_openremote_json_tree

      expect(json["name"]).to eq("Parent")
      expect(json["type"]).to eq("SolarPark")
      expect(json["attributes"]["powerOutput"]).to eq({ "value" => 100.0 })
      expect(json["children"]).to be_an(Array)
    end

    it "includes nested children in tree" do
      # Ensure child is created before calling to_openremote_json_tree
      child_asset

      json = parent_asset.to_openremote_json_tree

      expect(json["children"].length).to eq(1)
      child_json = json["children"].first
      expect(child_json["name"]).to eq("Child")
      expect(child_json["attributes"]["powerOutput"]).to eq({ "value" => 50.0 })
    end

    it "denormalizes attributes to OpenRemote format" do
      json = parent_asset.to_openremote_json_tree

      expect(json["attributes"]["powerOutput"]).to eq({ "value" => 100.0 })
    end

    it "handles empty attributes_data" do
      empty_asset = Asset.create!(
        name: "Empty",
        asset_type: asset_type,
        attributes_data: {}
      )

      json = empty_asset.to_openremote_json_tree

      expect(json["attributes"]).to eq({})
    end
  end
end
