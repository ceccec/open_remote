# frozen_string_literal: true

require "rails_helper"

RSpec.describe Assets::WeatherStationAttributes, type: :model do
  let(:asset_type) { AssetType.create!(name: "WeatherStation", display_name: "Weather Station") }
  let(:asset) do
    Asset.create!(
      name: "Test Station",
      asset_type: asset_type,
      attributes_data: {
        "temperature" => 25.5,
        "humidity" => 60,
        "pressure" => 1013.25,
        "windSpeed" => 15,
        "windDirection" => 180,
        "solarIrradiance" => 800,
        "cloudCover" => 30,
        "visibility" => 10,
        "location" => "40.7128,-74.0060"
      }
    )
  end

  describe "attribute accessors" do
    %i[
      temperature humidity pressure wind_speed wind_direction
      solar_irradiance cloud_cover visibility location
    ].each do |method|
      it { expect(asset).to respond_to(method) }
    end
  end

  describe "attribute values" do
    it "returns correct values" do
      expect(asset.temperature).to eq(25.5)
      expect(asset.humidity).to eq(60)
      expect(asset.solar_irradiance).to eq(800)
      expect(asset.location).to eq("40.7128,-74.0060")
    end
  end
end
