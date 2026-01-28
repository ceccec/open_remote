require "rails_helper"

RSpec.describe AssetType, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      asset_type = AssetType.new(
        name: "SolarPark",
        display_name: "Solar Park",
        description: "A solar park",
        icon: "solar-panel"
      )
      expect(asset_type).to be_valid
    end

    it "is invalid without name" do
      asset_type = AssetType.new(display_name: "Solar Park")
      expect(asset_type).not_to be_valid
      expect(asset_type.errors[:name]).to include("can't be blank")
    end

    it "is invalid with duplicate name" do
      AssetType.create!(name: "SolarPark", display_name: "Solar Park")
      asset_type = AssetType.new(name: "SolarPark", display_name: "Another")
      expect(asset_type).not_to be_valid
    end
  end

  describe "associations" do
    it "has many assets" do
      asset_type = AssetType.create!(name: "SolarPark", display_name: "Solar Park")
      asset = Asset.create!(
        name: "Test Park",
        asset_type: asset_type,
        attributes_data: {}
      )
      expect(asset_type.assets).to include(asset)
    end

    it "destroys associated assets when destroyed" do
      asset_type = AssetType.create!(name: "SolarPark", display_name: "Solar Park")
      asset = Asset.create!(
        name: "Test Park",
        asset_type: asset_type,
        attributes_data: {}
      )
      asset_type.destroy
      expect(Asset.find_by(id: asset.id)).to be_nil
    end
  end
end
