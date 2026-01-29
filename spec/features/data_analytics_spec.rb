# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Data Analytics", type: :feature do
  let(:solar_park_type) { AssetType.create!(name: "SolarPark", display_name: "Solar Park") }
  let(:park) do
    Asset.create!(
      name: "Analytics Park",
      asset_type: solar_park_type,
      attributes_data: {}
    )
  end

  describe "Time-Series Data Collection" do
    it "collects and stores time-series measurements for assets" do
      timestamps = [
        Time.utc(2026, 1, 28, 10, 0),
        Time.utc(2026, 1, 28, 11, 0),
        Time.utc(2026, 1, 28, 12, 0)
      ]

      timestamps.each_with_index do |timestamp, index|
        DataPoint.create!(
          asset: park,
          attribute_name: "powerOutput",
          value: { "value" => 1000 + (index * 100) },
          timestamp: timestamp
        )
      end

      expect(park.data_points.count).to eq(3)
      expect(park.data_points.for_attribute("powerOutput").count).to eq(3)

      # Verify ordering
      recent = park.data_points.recent
      expect(recent.first.timestamp).to eq(timestamps.last)
    end

    it "supports multiple attributes per asset" do
      base_time = Time.utc(2026, 1, 28, 10, 0)

      DataPoint.create!(
        asset: park,
        attribute_name: "powerOutput",
        value: { "value" => 1000 },
        timestamp: base_time
      )

      DataPoint.create!(
        asset: park,
        attribute_name: "temperature",
        value: { "value" => 25.5 },
        timestamp: base_time
      )

      DataPoint.create!(
        asset: park,
        attribute_name: "voltage",
        value: { "value" => 240 },
        timestamp: base_time
      )

      expect(park.data_points.count).to eq(3)
      expect(park.data_points.for_attribute("powerOutput").count).to eq(1)
      expect(park.data_points.for_attribute("temperature").count).to eq(1)
      expect(park.data_points.for_attribute("voltage").count).to eq(1)
    end
  end

  describe "Aggregation Functions" do
    before do
      # Create data points over a time range
      base_time = Time.utc(2026, 1, 28, 10, 0)
      values = [ 1000, 1200, 1100, 1300, 1150 ]

      values.each_with_index do |value, index|
        DataPoint.create!(
          asset: park,
          attribute_name: "powerOutput",
          value: { "value" => value },
          timestamp: base_time + index.hours
        )
      end
    end

    it "calculates sum of values over time range" do
      from = Time.utc(2026, 1, 28, 10, 0)
      to = Time.utc(2026, 1, 28, 14, 0)

      sum = DataPoint.sum_for(
        asset: park,
        attribute_name: "powerOutput",
        from: from,
        to: to
      )

      expect(sum).to eq(5750.0) # 1000 + 1200 + 1100 + 1300 + 1150
    end

    it "calculates average of values over time range" do
      from = Time.utc(2026, 1, 28, 10, 0)
      to = Time.utc(2026, 1, 28, 14, 0)

      avg = DataPoint.average_for(
        asset: park,
        attribute_name: "powerOutput",
        from: from,
        to: to
      )

      expect(avg).to be_within(0.01).of(1150.0) # Average of 5 values
    end

    it "finds maximum value over time range" do
      from = Time.utc(2026, 1, 28, 10, 0)
      to = Time.utc(2026, 1, 28, 14, 0)

      max = DataPoint.max_for(
        asset: park,
        attribute_name: "powerOutput",
        from: from,
        to: to
      )

      expect(max).to eq(1300.0)
    end

    it "finds minimum value over time range" do
      from = Time.utc(2026, 1, 28, 10, 0)
      to = Time.utc(2026, 1, 28, 14, 0)

      min = DataPoint.min_for(
        asset: park,
        attribute_name: "powerOutput",
        from: from,
        to: to
      )

      expect(min).to eq(1000.0)
    end

    it "handles empty time ranges gracefully" do
      from = Time.utc(2026, 1, 29, 10, 0)
      to = Time.utc(2026, 1, 29, 14, 0)

      sum = DataPoint.sum_for(
        asset: park,
        attribute_name: "powerOutput",
        from: from,
        to: to
      )

      expect(sum).to eq(0.0)

      avg = DataPoint.average_for(
        asset: park,
        attribute_name: "powerOutput",
        from: from,
        to: to
      )

      expect(avg).to be_nil
    end
  end

  describe "Time Range Queries" do
    it "filters data points by time range" do
      base_time = Time.utc(2026, 1, 28, 10, 0)

      # Create points at different times
      DataPoint.create!(
        asset: park,
        attribute_name: "powerOutput",
        value: { "value" => 1000 },
        timestamp: base_time - 1.hour # Before range
      )

      DataPoint.create!(
        asset: park,
        attribute_name: "powerOutput",
        value: { "value" => 1100 },
        timestamp: base_time # In range
      )

      DataPoint.create!(
        asset: park,
        attribute_name: "powerOutput",
        value: { "value" => 1200 },
        timestamp: base_time + 1.hour # In range
      )

      DataPoint.create!(
        asset: park,
        attribute_name: "powerOutput",
        value: { "value" => 1300 },
        timestamp: base_time + 3.hours # After range
      )

      from = base_time
      to = base_time + 2.hours

      in_range = DataPoint.in_time_range(from, to)
      expect(in_range.count).to eq(2)
      expect(in_range.pluck(Arel.sql("value->>'value'"))).to contain_exactly("1100", "1200")
    end
  end

  describe "Latest Data Point Queries" do
    it "retrieves the most recent data point for an attribute" do
      base_time = Time.utc(2026, 1, 28, 10, 0)

      # Create older point
      DataPoint.create!(
        asset: park,
        attribute_name: "powerOutput",
        value: { "value" => 1000 },
        timestamp: base_time
      )

      # Create newer point
      latest = DataPoint.create!(
        asset: park,
        attribute_name: "powerOutput",
        value: { "value" => 1500 },
        timestamp: base_time + 2.hours
      )

      found = DataPoint.latest_for_attribute(park, "powerOutput").first
      expect(found).to eq(latest)
      expect(found.value["value"]).to eq(1500)
    end
  end

  describe "Bulk Data Recording" do
    it "records data points for all attributes of an asset type" do
      array_type = AssetType.create!(name: "SolarArray", display_name: "Solar Array")

      array1 = Asset.create!(
        name: "Array 1",
        asset_type: array_type,
        attributes_data: {
          "powerOutput" => 1000,
          "voltage" => 240
        }
      )

      array2 = Asset.create!(
        name: "Array 2",
        asset_type: array_type,
        attributes_data: {
          "powerOutput" => 2000,
          "voltage" => 480
        }
      )

      count = AssetDatapointService.record_all_attributes_for_type("SolarArray")

      # Should record 2 attributes for 2 assets = 4 data points
      expect(count).to eq(4)
      expect(DataPoint.where(asset: [ array1, array2 ]).count).to eq(4)
    end

    it "retrieves latest data points for multiple assets" do
      array_type = AssetType.create!(name: "SolarArray")

      array1 = Asset.create!(
        name: "Array 1",
        asset_type: array_type,
        attributes_data: { "powerOutput" => 1000 }
      )

      array2 = Asset.create!(
        name: "Array 2",
        asset_type: array_type,
        attributes_data: { "powerOutput" => 2000 }
      )

      # Create historical and latest points
      DataPoint.create!(
        asset: array1,
        attribute_name: "powerOutput",
        value: { "value" => 900 },
        timestamp: 1.hour.ago
      )

      latest1 = DataPoint.create!(
        asset: array1,
        attribute_name: "powerOutput",
        value: { "value" => 1000 },
        timestamp: Time.current
      )

      latest2 = DataPoint.create!(
        asset: array2,
        attribute_name: "powerOutput",
        value: { "value" => 2000 },
        timestamp: Time.current
      )

      # Get latest datapoints for each asset separately
      latest1_result = AssetDatapointService.get_latest_datapoints(array1)
      latest2_result = AssetDatapointService.get_latest_datapoints(array2)

      expect(latest1_result["powerOutput"]).to eq(latest1)
      expect(latest2_result["powerOutput"]).to eq(latest2)
    end
  end
end
