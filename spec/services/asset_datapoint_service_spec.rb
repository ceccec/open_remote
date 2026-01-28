require "rails_helper"

RSpec.describe AssetDatapointService do
  let(:asset_type) { AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" } }
  let(:asset) do
    Asset.create!(
      name: "Test Park",
      asset_type: asset_type,
      attributes_data: { "totalCapacity" => 1000 }
    )
  end

  describe ".record_datapoint" do
    it "creates a data point for an asset attribute" do
      expect do
        AssetDatapointService.record_datapoint(asset, "totalCapacity", 1000)
      end.to change { DataPoint.count }.by(1)

      datapoint = DataPoint.last
      expect(datapoint.asset).to eq(asset)
      expect(datapoint.attribute_name).to eq("totalCapacity")
      expect(datapoint.value).to eq(1000)
    end

    it "uses provided timestamp" do
      timestamp = 1.hour.ago
      datapoint = AssetDatapointService.record_datapoint(asset, "totalCapacity", 1000, timestamp: timestamp)

      expect(datapoint.timestamp).to be_within(1.second).of(timestamp)
    end
  end

  describe ".record_datapoints" do
    it "creates multiple data points" do
      attributes = {
        "totalCapacity" => 1000,
        "totalPowerOutput" => 800
      }

      expect do
        AssetDatapointService.record_datapoints(asset, attributes)
      end.to change { DataPoint.count }.by(2)

      expect(DataPoint.where(asset: asset, attribute_name: "totalCapacity").count).to eq(1)
      expect(DataPoint.where(asset: asset, attribute_name: "totalPowerOutput").count).to eq(1)
    end
  end

  describe ".get_datapoints" do
    before do
      AssetDatapointService.record_datapoint(asset, "totalCapacity", 1000, timestamp: 2.hours.ago)
      AssetDatapointService.record_datapoint(asset, "totalCapacity", 1100, timestamp: 1.hour.ago)
      AssetDatapointService.record_datapoint(asset, "totalCapacity", 1200, timestamp: Time.current)
    end

    it "returns data points within time range" do
      start_time = 90.minutes.ago
      end_time = 30.minutes.ago

      datapoints = AssetDatapointService.get_datapoints(asset, "totalCapacity", start_time: start_time, end_time: end_time)

      expect(datapoints.count).to eq(1)
      expect(datapoints.first.value).to eq(1100)
    end
  end

  describe ".get_latest_datapoint" do
    before do
      AssetDatapointService.record_datapoint(asset, "totalCapacity", 1000, timestamp: 2.hours.ago)
      AssetDatapointService.record_datapoint(asset, "totalCapacity", 1200, timestamp: Time.current)
    end

    it "returns the most recent data point" do
      latest = AssetDatapointService.get_latest_datapoint(asset, "totalCapacity")

      expect(latest.value).to eq(1200)
    end
  end

  describe ".record_current_attributes" do
    it "records data points for all current attributes" do
      expect do
        AssetDatapointService.record_current_attributes(asset)
      end.to change { DataPoint.count }.by(1)

      datapoint = DataPoint.last
      expect(datapoint.attribute_name).to eq("totalCapacity")
      expect(datapoint.value).to eq(1000)
    end

    it "returns empty array for asset without attributes" do
      asset.attributes_data = {}
      asset.save!

      expect(AssetDatapointService.record_current_attributes(asset)).to eq([])
    end
  end

  describe ".cleanup_old_datapoints" do
    before do
      AssetDatapointService.record_datapoint(asset, "totalCapacity", 1000, timestamp: 100.days.ago)
      AssetDatapointService.record_datapoint(asset, "totalCapacity", 1200, timestamp: 10.days.ago)
    end

    it "deletes data points older than threshold" do
      expect do
        AssetDatapointService.cleanup_old_datapoints(older_than: 90.days)
      end.to change { DataPoint.count }.by(-1)

      expect(DataPoint.where("timestamp < ?", 90.days.ago).count).to eq(0)
    end
  end
end
