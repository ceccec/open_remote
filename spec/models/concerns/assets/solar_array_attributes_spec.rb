# frozen_string_literal: true

require "rails_helper"

RSpec.describe Assets::SolarArrayAttributes, type: :model do
  let(:asset_type) { AssetType.create!(name: "SolarArray", display_name: "Solar Array") }
  let(:asset) do
    Asset.create!(
      name: "Test Array",
      asset_type: asset_type,
      attributes_data: {
        "arrayCapacity" => 5000,
        "powerOutput" => 4500,
        "voltage" => 600,
        "current" => 7.5,
        "panelCount" => 20,
        "panelOrientation" => "south",
        "panelTilt" => 30,
        "temperature" => 35,
        "status" => "online",
        "location" => "40.7128,-74.0060"
      }
    )
  end

  describe "attribute accessors" do
    %i[
      array_capacity power_output dc_voltage dc_current panel_count
      panel_orientation panel_tilt temperature status location
    ].each do |method|
      it { expect(asset).to respond_to(method) }
    end
  end

  describe "attribute values" do
    it "returns correct values" do
      expect(asset.array_capacity).to eq(5000)
      expect(asset.power_output).to eq(4500)
      expect(asset.panel_count).to eq(20)
      expect(asset.status).to eq("online")
    end
  end
end
