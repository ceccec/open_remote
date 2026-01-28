require "rails_helper"

RSpec.describe DatapointCleanupJob, type: :job do
  let(:asset) { Asset.create!(name: "Test Asset", asset_type: AssetType.create!(name: "TestType")) }

  describe "#perform" do
    context "with default older_than_days" do
      it "deletes data points older than 90 days" do
        old_datapoint = DataPoint.create!(
          asset: asset,
          attribute_name: "temperature",
          value: 20,
          timestamp: 91.days.ago
        )
        new_datapoint = DataPoint.create!(
          asset: asset,
          attribute_name: "temperature",
          value: 25,
          timestamp: 10.days.ago
        )

        expect(Rails.logger).to receive(:info).with("DatapointCleanupJob: Deleted 1 old data point(s)")
        DatapointCleanupJob.new.perform

        expect(DataPoint.find_by(id: old_datapoint.id)).to be_nil
        expect(DataPoint.find_by(id: new_datapoint.id)).to be_present
      end
    end

    context "with custom older_than_days" do
      it "deletes data points older than specified days" do
        old_datapoint = DataPoint.create!(
          asset: asset,
          attribute_name: "temperature",
          value: 20,
          timestamp: 31.days.ago
        )
        new_datapoint = DataPoint.create!(
          asset: asset,
          attribute_name: "temperature",
          value: 25,
          timestamp: 10.days.ago
        )

        expect(Rails.logger).to receive(:info).with("DatapointCleanupJob: Deleted 1 old data point(s)")
        DatapointCleanupJob.new.perform(older_than_days: 30)

        expect(DataPoint.find_by(id: old_datapoint.id)).to be_nil
        expect(DataPoint.find_by(id: new_datapoint.id)).to be_present
      end
    end

    context "when no data points are deleted" do
      it "does not log anything" do
        DataPoint.create!(
          asset: asset,
          attribute_name: "temperature",
          value: 25,
          timestamp: 10.days.ago
        )

        expect(Rails.logger).not_to receive(:info)
        DatapointCleanupJob.new.perform
      end
    end
  end
end
