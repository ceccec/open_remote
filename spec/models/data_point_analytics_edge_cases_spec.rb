require "rails_helper"

RSpec.describe "DataPoint::Analytics Edge Cases", type: :model do
  let(:asset_type) { AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" } }
  let(:asset) do
    Asset.create!(
      name: "Test Park",
      asset_type: asset_type,
      attributes_data: {}
    )
  end

  describe ".sum_for" do
    it "handles zero values correctly" do
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 0 },
        timestamp: 1.hour.ago
      )

      sum = DataPoint.sum_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: 2.hours.ago,
        to: Time.current
      )

      expect(sum).to eq(0.0)
    end

    it "handles negative values correctly" do
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => -100 },
        timestamp: 1.hour.ago
      )
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 200 },
        timestamp: 30.minutes.ago
      )

      sum = DataPoint.sum_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: 2.hours.ago,
        to: Time.current
      )

      expect(sum).to eq(100.0)
    end

    it "handles decimal values correctly" do
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 100.5 },
        timestamp: 1.hour.ago
      )
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 200.75 },
        timestamp: 30.minutes.ago
      )

      sum = DataPoint.sum_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: 2.hours.ago,
        to: Time.current
      )

      expect(sum).to eq(301.25)
    end

    it "handles string numeric values" do
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => "100" },
        timestamp: 1.hour.ago
      )

      sum = DataPoint.sum_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: 2.hours.ago,
        to: Time.current
      )

      expect(sum).to eq(100.0)
    end

    it "filters by exact time boundaries" do
      from_time = 1.hour.ago
      to_time = Time.current

      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 100 },
        timestamp: from_time - 1.minute
      )
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 200 },
        timestamp: from_time
      )
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 300 },
        timestamp: to_time
      )
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 400 },
        timestamp: to_time + 1.minute
      )

      sum = DataPoint.sum_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: from_time,
        to: to_time
      )

      expect(sum).to eq(500.0)
    end
  end

  describe ".average_for" do
    it "returns nil when no datapoints match" do
      avg = DataPoint.average_for(
        asset: asset,
        attribute_name: "nonexistent",
        from: 1.year.ago,
        to: 11.months.ago
      )

      expect(avg).to be_nil
    end

    it "handles single datapoint" do
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 100 },
        timestamp: 1.hour.ago
      )

      avg = DataPoint.average_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: 2.hours.ago,
        to: Time.current
      )

      expect(avg).to eq(100.0)
    end

    it "calculates correct average with multiple values" do
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 100 },
        timestamp: 2.hours.ago
      )
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 200 },
        timestamp: 1.hour.ago
      )
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 300 },
        timestamp: 30.minutes.ago
      )

      avg = DataPoint.average_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: 3.hours.ago,
        to: Time.current
      )

      expect(avg).to eq(200.0)
    end
  end

  describe ".max_for" do
    it "returns nil when no datapoints match" do
      max = DataPoint.max_for(
        asset: asset,
        attribute_name: "nonexistent",
        from: 1.year.ago,
        to: 11.months.ago
      )

      expect(max).to be_nil
    end

    it "finds maximum value correctly" do
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 100 },
        timestamp: 2.hours.ago
      )
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 500 },
        timestamp: 1.hour.ago
      )
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 200 },
        timestamp: 30.minutes.ago
      )

      max = DataPoint.max_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: 3.hours.ago,
        to: Time.current
      )

      expect(max).to eq(500.0)
    end

    it "handles negative maximum values" do
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => -100 },
        timestamp: 1.hour.ago
      )
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => -50 },
        timestamp: 30.minutes.ago
      )

      max = DataPoint.max_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: 2.hours.ago,
        to: Time.current
      )

      expect(max).to eq(-50.0)
    end
  end

  describe ".min_for" do
    it "returns nil when no datapoints match" do
      min = DataPoint.min_for(
        asset: asset,
        attribute_name: "nonexistent",
        from: 1.year.ago,
        to: 11.months.ago
      )

      expect(min).to be_nil
    end

    it "finds minimum value correctly" do
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 500 },
        timestamp: 2.hours.ago
      )
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 100 },
        timestamp: 1.hour.ago
      )
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 200 },
        timestamp: 30.minutes.ago
      )

      min = DataPoint.min_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: 3.hours.ago,
        to: Time.current
      )

      expect(min).to eq(100.0)
    end

    it "handles negative minimum values" do
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => -100 },
        timestamp: 1.hour.ago
      )
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => -50 },
        timestamp: 30.minutes.ago
      )

      min = DataPoint.min_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: 2.hours.ago,
        to: Time.current
      )

      expect(min).to eq(-100.0)
    end
  end

  describe ".create_continuous_aggregate" do
    it "handles TimescaleDB not being available gracefully" do
      allow(DataPoint).to receive(:execute).and_raise(
        ActiveRecord::StatementInvalid.new("timescaledb extension not found")
      )

      expect(Rails.logger).to receive(:warn).with(
        a_string_including("Could not create continuous aggregate")
      )

      expect do
        DataPoint.create_continuous_aggregate(
          "test_view",
          "SELECT 1"
        )
      end.not_to raise_error
    end

    it "handles SQL syntax errors gracefully" do
      allow(DataPoint).to receive(:execute).and_raise(
        ActiveRecord::StatementInvalid.new("syntax error at or near")
      )

      expect(Rails.logger).to receive(:warn).with(
        a_string_including("Could not create continuous aggregate")
      )

      expect do
        DataPoint.create_continuous_aggregate(
          "test_view",
          "INVALID SQL"
        )
      end.not_to raise_error
    end
  end

  describe "multiple assets" do
    let(:asset2) do
      Asset.create!(
        name: "Test Park 2",
        asset_type: asset_type,
        attributes_data: {}
      )
    end

    it "filters by asset correctly" do
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 100 },
        timestamp: 1.hour.ago
      )
      DataPoint.create!(
        asset: asset2,
        attribute_name: "powerOutput",
        value: { "value" => 200 },
        timestamp: 1.hour.ago
      )

      sum1 = DataPoint.sum_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: 2.hours.ago,
        to: Time.current
      )
      sum2 = DataPoint.sum_for(
        asset: asset2,
        attribute_name: "powerOutput",
        from: 2.hours.ago,
        to: Time.current
      )

      expect(sum1).to eq(100.0)
      expect(sum2).to eq(200.0)
    end

    it "filters by attribute_name correctly" do
      DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 100 },
        timestamp: 1.hour.ago
      )
      DataPoint.create!(
        asset: asset,
        attribute_name: "temperature",
        value: { "value" => 25 },
        timestamp: 1.hour.ago
      )

      power_sum = DataPoint.sum_for(
        asset: asset,
        attribute_name: "powerOutput",
        from: 2.hours.ago,
        to: Time.current
      )
      temp_sum = DataPoint.sum_for(
        asset: asset,
        attribute_name: "temperature",
        from: 2.hours.ago,
        to: Time.current
      )

      expect(power_sum).to eq(100.0)
      expect(temp_sum).to eq(25.0)
    end
  end
end
