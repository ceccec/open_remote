# frozen_string_literal: true

require "rails_helper"
require "support/attribute_concern_helper"

RSpec.describe Assets::EnergyMeterAttributes, type: :model do
  let(:asset_type) { AssetType.create!(name: "EnergyMeter", display_name: "Energy Meter") }
  let(:asset) do
    Asset.create!(
      name: "Test Meter",
      asset_type: asset_type,
      attributes_data: {
        "activePower" => 1000,
        "reactivePower" => 500,
        "apparentPower" => 1118,
        "energyImport" => 5000,
        "energyExport" => 2000,
        "voltage" => 240,
        "current" => 4.17,
        "powerFactor" => 0.9,
        "frequency" => 60
      }
    )
  end

  describe "attribute accessors" do
    it { expect(asset).to respond_to(:active_power) }
    it { expect(asset).to respond_to(:reactive_power) }
    it { expect(asset).to respond_to(:apparent_power) }
    it { expect(asset).to respond_to(:energy_import) }
    it { expect(asset).to respond_to(:energy_export) }
    it { expect(asset).to respond_to(:voltage) }
    it { expect(asset).to respond_to(:current) }
    it { expect(asset).to respond_to(:power_factor) }
    it { expect(asset).to respond_to(:frequency) }
  end

  describe "attribute values" do
    it "returns correct values from attributes_data" do
      expect(asset.active_power).to eq(1000)
      expect(asset.reactive_power).to eq(500)
      expect(asset.apparent_power).to eq(1118)
      expect(asset.energy_import).to eq(5000)
      expect(asset.energy_export).to eq(2000)
      expect(asset.voltage).to eq(240)
      expect(asset.current).to eq(4.17)
      expect(asset.power_factor).to eq(0.9)
      expect(asset.frequency).to eq(60)
    end

    it "returns nil when attributes_data is empty" do
      asset.update!(attributes_data: {})
      expect(asset.active_power).to be_nil
      expect(asset.voltage).to be_nil
    end
  end
end
