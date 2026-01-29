# frozen_string_literal: true

require "rails_helper"

RSpec.describe Assets::InverterAttributes, type: :model do
  let(:asset_type) { AssetType.create!(name: "Inverter", display_name: "Inverter") }
  let(:asset) do
    Asset.create!(
      name: "Test Inverter",
      asset_type: asset_type,
      attributes_data: {
        "inverterCapacity" => 5000,
        "acPowerOutput" => 4500,
        "dcPowerInput" => 4800,
        "acVoltage" => 240,
        "acFrequency" => 60,
        "efficiency" => 0.9375,
        "temperature" => 45,
        "uptime" => 8760,
        "status" => "online",
        "alarmStatus" => "normal"
      }
    )
  end

  describe "attribute accessors" do
    %i[
      inverter_capacity ac_power_output dc_power_input ac_voltage ac_frequency
      efficiency temperature uptime status alarm_status
    ].each do |method|
      it { expect(asset).to respond_to(method) }
    end
  end

  describe "attribute values" do
    it "returns correct values" do
      expect(asset.inverter_capacity).to eq(5000)
      expect(asset.ac_power_output).to eq(4500)
      expect(asset.efficiency).to eq(0.9375)
      expect(asset.status).to eq("online")
    end

    it "returns nil when attribute is missing" do
      asset.update!(attributes_data: {})
      expect(asset.inverter_capacity).to be_nil
    end
  end
end
