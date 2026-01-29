require "rails_helper"

RSpec.describe DataPoint::BatchActions do
  let!(:asset_type) { AssetType.find_or_create_by!(name: "TestAssetType") }
  let!(:asset) { Asset.create!(name: "Test Asset", asset_type: asset_type, attributes_data: {}) }
  let!(:old_data_point) { DataPoint.create!(asset: asset, attribute_name: "power", value: { value: 100 }, timestamp: 2.months.ago) }
  let!(:recent_data_point) { DataPoint.create!(asset: asset, attribute_name: "power", value: { value: 200 }, timestamp: 1.day.ago) }
  let!(:another_recent) { DataPoint.create!(asset: asset, attribute_name: "power", value: { value: 300 }, timestamp: 1.hour.ago) }

  describe ".batch_cleanup_older_than" do
    it "deletes data points older than the given timestamp" do
      expect { DataPoint.batch_cleanup_older_than(1.month.ago) }
        .to change { DataPoint.count }.by(-1)
        .and change { DataPoint.exists?(old_data_point.id) }.from(true).to(false)
    end

    it "does not delete recent data points" do
      expect { DataPoint.batch_cleanup_older_than(1.month.ago) }
        .not_to change { DataPoint.exists?(recent_data_point.id) }
    end

    it "returns the number of records deleted" do
      expect(DataPoint.batch_cleanup_older_than(1.month.ago)).to eq(1)
    end

    it "handles large batches" do
      # Create many old data points
      5.times do |i|
        DataPoint.create!(
          asset: asset,
          attribute_name: "power",
          value: { value: i },
          timestamp: 2.months.ago + i.hours
        )
      end

      expect(DataPoint.batch_cleanup_older_than(1.month.ago, batch_size: 2)).to eq(6) # 1 original + 5 new
    end
  end

  describe ".batch_cleanup_for_asset" do
    let!(:other_asset) { Asset.create!(name: "Other Asset", asset_type: AssetType.first!, attributes_data: {}) }
    let!(:other_old_point) { DataPoint.create!(asset: other_asset, attribute_name: "power", value: { value: 50 }, timestamp: 2.months.ago) }

    it "deletes old data points for a specific asset" do
      expect { DataPoint.batch_cleanup_for_asset(asset, 1.month.ago) }
        .to change { DataPoint.where(asset: asset).count }.by(-1)
      expect { DataPoint.batch_cleanup_for_asset(asset, 1.month.ago) }
        .not_to change { DataPoint.where(asset: other_asset).count }
    end

    it "works with asset ID" do
      expect { DataPoint.batch_cleanup_for_asset(asset.id, 1.month.ago) }
        .to change { DataPoint.where(asset: asset).count }.by(-1)
    end
  end

  describe ".batch_cleanup_for_attribute" do
    let!(:temp_point) { DataPoint.create!(asset: asset, attribute_name: "temperature", value: { value: 25 }, timestamp: 2.months.ago) }

    it "deletes old data points for a specific attribute" do
      expect { DataPoint.batch_cleanup_for_attribute("power", 1.month.ago) }
        .to change { DataPoint.where(attribute_name: "power").count }.by(-1)
      expect { DataPoint.batch_cleanup_for_attribute("power", 1.month.ago) }
        .not_to change { DataPoint.where(attribute_name: "temperature").count }
    end
  end

  describe ".batch_transform_values" do
    it "transforms values using a block" do
      results = DataPoint.batch_transform_values([ recent_data_point.id, another_recent.id ]) do |value|
        value.merge("normalized" => value["value"].to_f * 1000)
      end

      expect(results[:success]).to eq(2)
      expect(recent_data_point.reload.value["normalized"]).to eq(200_000)
      expect(another_recent.reload.value["normalized"]).to eq(300_000)
    end

    it "handles errors gracefully" do
      allow_any_instance_of(DataPoint).to receive(:update!).and_raise(StandardError.new("Test error"))
      results = DataPoint.batch_transform_values([ recent_data_point.id ]) { |v| v }

      expect(results[:failed]).to eq(1)
      expect(results[:errors].first[:error]).to eq("Test error")
    end
  end

  describe ".batch_delete_duplicates" do
    let!(:duplicate1) { DataPoint.create!(asset: asset, attribute_name: "power", value: { value: 100 }, timestamp: 1.hour.ago) }
    let!(:duplicate2) { DataPoint.create!(asset: asset, attribute_name: "power", value: { value: 100 }, timestamp: 1.hour.ago) }
    let!(:duplicate3) { DataPoint.create!(asset: asset, attribute_name: "power", value: { value: 100 }, timestamp: 1.hour.ago) }

    it "deletes duplicate data points, keeping the most recent" do
      expect { DataPoint.batch_delete_duplicates }
        .to change { DataPoint.count }.by(-2) # Keep 1, delete 2
    end

    it "keeps the data point with the highest ID" do
      DataPoint.batch_delete_duplicates
      # Use a range query to handle timestamp precision
      # Filter by value to only check the duplicates (value: 100), not another_recent (value: 300)
      timestamp_start = 1.hour.ago.beginning_of_second
      timestamp_end = 1.hour.ago.end_of_second
      remaining = DataPoint.where(asset: asset, attribute_name: "power", value: { value: 100 })
        .where("timestamp >= ? AND timestamp <= ?", timestamp_start, timestamp_end)
      expect(remaining.count).to eq(1)
      expect(remaining.first.id).to eq([ duplicate1.id, duplicate2.id, duplicate3.id ].max)
    end
  end

  describe ".batch_aggregate_by_window" do
    # Create data points in different hours to test windowing
    # hour1: 2 hours ago (100, 200) - both in same hour window - should aggregate to (100+200)/2 = 150 avg, 300 sum
    # hour2: 30 minutes ago (300) - should aggregate to 300
    # Use same hour for both hour1 points to ensure they're grouped together
    let!(:hour1_start) { 2.hours.ago.beginning_of_hour }
    let!(:hour1_point1) { DataPoint.create!(asset: asset, attribute_name: "power", value: { value: 100 }, timestamp: hour1_start + 10.minutes) }
    let!(:hour1_point2) { DataPoint.create!(asset: asset, attribute_name: "power", value: { value: 200 }, timestamp: hour1_start + 30.minutes) }
    let!(:hour2_point1) { DataPoint.create!(asset: asset, attribute_name: "power", value: { value: 300 }, timestamp: 30.minutes.ago) }

    it "creates aggregated data points by time window" do
      results = DataPoint.batch_aggregate_by_window("1 hour", :avg, from_time: 3.hours.ago, to_time: Time.current)

      expect(results[:created]).to be > 0
      aggregated = DataPoint.where("attribute_name LIKE ?", "%_avg")
      expect(aggregated.count).to be > 0
      expect(aggregated.first.value["aggregated"]).to be true
    end

    it "calculates average correctly" do
      DataPoint.batch_aggregate_by_window("1 hour", :avg, from_time: 3.hours.ago, to_time: Time.current)
      # Find the aggregated point for the first hour window
      # The aggregated point has timestamp = hour1_start
      aggregated = DataPoint.where("attribute_name LIKE ?", "%_avg")
        .where("timestamp = ?", hour1_start)
        .first
      expect(aggregated).not_to be_nil
      expect(aggregated.value["value"]).to be_within(0.01).of(150.0) # (100 + 200) / 2
    end

    it "supports sum aggregation" do
      DataPoint.batch_aggregate_by_window("1 hour", :sum, from_time: 3.hours.ago, to_time: Time.current)
      # Find the aggregated point for the first hour window
      # The aggregated point has timestamp = hour1_start
      aggregated = DataPoint.where("attribute_name LIKE ?", "%_sum")
        .where("timestamp = ?", hour1_start)
        .first
      expect(aggregated).not_to be_nil
      expect(aggregated.value["value"]).to eq(300.0) # 100 + 200
    end
  end
end
