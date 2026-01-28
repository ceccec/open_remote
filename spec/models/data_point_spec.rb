require "rails_helper"

RSpec.describe DataPoint, type: :model do
  let(:asset_type) { AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" } }
  let(:asset) do
    Asset.create!(
      name: "Test Park",
      asset_type: asset_type,
      attributes_data: {}
    )
  end

  describe "validations" do
    it "is valid with valid attributes" do
      data_point = DataPoint.new(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 100 },
        timestamp: Time.current
      )
      expect(data_point).to be_valid
    end

    it "is invalid without attribute_name" do
      data_point = DataPoint.new(
        asset: asset,
        value: {},
        timestamp: Time.current
      )
      expect(data_point).not_to be_valid
    end

    it "is invalid without value" do
      data_point = DataPoint.new(
        asset: asset,
        attribute_name: "powerOutput",
        timestamp: Time.current
      )
      expect(data_point).not_to be_valid
    end

    it "is invalid without timestamp" do
      data_point = DataPoint.new(
        asset: asset,
        attribute_name: "powerOutput",
        value: {}
      )
      expect(data_point).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to asset" do
      data_point = DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 100 },
        timestamp: Time.current
      )
      expect(data_point.asset).to eq(asset)
    end
  end

  describe "DataPoints::Analytics" do
    before do
      (1..5).each do |i|
        DataPoint.create!(
          asset: asset,
          attribute_name: "powerOutput",
          value: { "value" => i * 10 },
          timestamp: i.hours.ago
        )
      end
    end

    it "calculates sum for time range" do
      from = 6.hours.ago
      to = Time.current
      sum = DataPoint.sum_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: from,
        to: to
      )
      expect(sum).to be > 0
    end

    it "calculates average for time range" do
      from = 6.hours.ago
      to = Time.current
      avg = DataPoint.average_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: from,
        to: to
      )
      expect(avg).to be > 0
    end

    it "finds max value for time range" do
      from = 6.hours.ago
      to = Time.current
      max = DataPoint.max_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: from,
        to: to
      )
      expect(max).to be > 0
    end

    it "finds min value for time range" do
      from = 6.hours.ago
      to = Time.current
      min = DataPoint.min_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: from,
        to: to
      )
      expect(min).to be > 0
    end

    it "returns neutral values when there are no matching datapoints" do
      from = 1.year.ago
      to = 11.months.ago

      sum = DataPoint.sum_for(
        asset: asset,
        attribute_name: "nonexistent",
        from: from,
        to: to
      )
      avg = DataPoint.average_for(
        asset: asset,
        attribute_name: "nonexistent",
        from: from,
        to: to
      )
      max = DataPoint.max_for(
        asset: asset,
        attribute_name: "nonexistent",
        from: from,
        to: to
      )
      min = DataPoint.min_for(
        asset: asset,
        attribute_name: "nonexistent",
        from: from,
        to: to
      )

      expect(sum).to eq(0.0)
      expect(avg).to be_nil
      expect(max).to be_nil
      expect(min).to be_nil
    end

    it "logs a warning instead of raising when continuous aggregate creation fails" do
      allow(DataPoint).to receive(:execute).and_raise(
        ActiveRecord::StatementInvalid.new("timescaledb not installed")
      )
      expect(Rails.logger).to receive(:warn).with(
        a_string_including("Could not create continuous aggregate")
      )

      expect do
        DataPoint.create_continuous_aggregate(
          "example_view",
          "SELECT 1"
        )
      end.not_to raise_error
    end
  end
end
