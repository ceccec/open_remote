# frozen_string_literal: true

require "rails_helper"

RSpec.describe Assets::GridConnectionPointAttributes, type: :model do
  let(:asset_type) { AssetType.create!(name: "GridConnectionPoint", display_name: "Grid Connection Point") }
  let(:asset) do
    Asset.create!(
      name: "Test Connection",
      asset_type: asset_type,
      attributes_data: {
        "connectionCapacity" => 10_000,
        "activePower" => 8000,
        "reactivePower" => 2000,
        "voltage" => 480,
        "frequency" => 60,
        "energyExported" => 50_000,
        "energyImported" => 5000,
        "connectionStatus" => "connected",
        "location" => "Main Substation"
      }
    )
  end

  describe "attribute accessors" do
    %i[
      connection_capacity active_power reactive_power voltage frequency
      energy_exported energy_imported connection_status location
    ].each do |method|
      it { expect(asset).to respond_to(method) }
    end
  end

  describe "attribute values" do
    it "returns correct values" do
      expect(asset.connection_capacity).to eq(10_000)
      expect(asset.active_power).to eq(8000)
      expect(asset.energy_exported).to eq(50_000)
      expect(asset.connection_status).to eq("connected")
    end
  end
end
