require "rails_helper"

RSpec.describe DataPoint, type: :model do
  describe "#rails_admin_label" do
    it "includes asset name, attribute_name and formatted timestamp" do
      asset_type = AssetType.create!(name: "SolarPark", display_name: "Solar Park")
      asset = Asset.create!(name: "Main Park", asset_type: asset_type, attributes_data: {})
      time = Time.utc(2026, 1, 28, 15, 45)

      datapoint = DataPoint.create!(
        asset: asset,
        attribute_name: "powerOutput",
        value: { "value" => 1000 },
        timestamp: time
      )

      label = datapoint.rails_admin_label
      expect(label).to include("Main Park")
      expect(label).to include("powerOutput")
      expect(label).to include("2026-01-28 15:45")
    end
  end
end

