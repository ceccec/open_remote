require "rails_helper"

RSpec.describe Assets::SolarParkAttributes, type: :model do
  let(:asset_type) { AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" } }
  let(:asset) do
    Asset.create!(
      name: "Test Park",
      asset_type: asset_type,
      attributes_data: { "totalCapacity" => 1000, "totalPowerOutput" => 800 }
    )
  end

  describe "#update_performance_ratio!" do
    it "does nothing when total_capacity is zero" do
      asset.update!(attributes_data: { "totalCapacity" => 0, "totalPowerOutput" => 800 })
      expect { asset.update_performance_ratio! }.not_to change { asset.attributes_data["performanceRatio"] }
    end

    it "does nothing when total_capacity is negative" do
      asset.update!(attributes_data: { "totalCapacity" => -100, "totalPowerOutput" => 800 })
      expect { asset.update_performance_ratio! }.not_to change { asset.attributes_data["performanceRatio"] }
    end

    it "calculates and saves performance ratio when capacity is positive" do
      asset.update!(attributes_data: { "totalCapacity" => 1000, "totalPowerOutput" => 800 })
      asset.update_performance_ratio!
      asset.reload
      expect(asset.attributes_data["performanceRatio"]).to eq(0.8)
    end

    it "initializes attributes_data if nil" do
      asset.update_column(:attributes_data, nil)
      asset.update!(attributes_data: { "totalCapacity" => 1000, "totalPowerOutput" => 500 })
      asset.update_performance_ratio!
      asset.reload
      expect(asset.attributes_data["performanceRatio"]).to eq(0.5)
    end
  end
end
