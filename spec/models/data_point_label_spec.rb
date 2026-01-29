require "rails_helper"

RSpec.describe DataPoint, type: :model do
  let(:asset_type) { AssetType.create!(name: "SolarPark", display_name: "Solar Park") }
  let(:asset) { Asset.create!(name: "Main Park", asset_type: asset_type, attributes_data: {}) }
  let(:timestamp) { Time.utc(2026, 1, 28, 15, 45) }

  subject do
    DataPoint.new(
      asset: asset,
      attribute_name: "powerOutput",
      value: { "value" => 1000 },
      timestamp: timestamp
    )
  end

  describe "#rails_admin_label" do
    it_behaves_like "has rails_admin_label",
      includes: [ "Main Park", "powerOutput" ],
      formats_timestamp: :timestamp

    it "includes asset name, attribute_name and formatted timestamp" do
      subject.save!
      label = subject.rails_admin_label
      expect(label).to include("Main Park")
      expect(label).to include("powerOutput")
      expect(label).to include("2026-01-28 15:45")
    end
  end
end
