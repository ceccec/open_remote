require "rails_helper"

RSpec.describe AssetProcessingService do
  let(:asset_type) { AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" } }
  let(:asset) do
    Asset.create!(
      name: "Test Park",
      asset_type: asset_type,
      attributes_data: { "totalCapacity" => 1000 }
    )
  end

  describe ".process_attribute_update" do
    it "updates the asset attribute" do
      AssetProcessingService.process_attribute_update(asset, "totalPowerOutput", 800)

      asset.reload
      expect(asset.attributes_data["totalPowerOutput"]).to eq(800)
    end

    it "records a data point by default" do
      expect do
        AssetProcessingService.process_attribute_update(asset, "totalPowerOutput", 800)
      end.to change { DataPoint.count }.by(1)

      datapoint = DataPoint.last
      expect(datapoint.attribute_name).to eq("totalPowerOutput")
      expect(datapoint.value).to eq(800)
    end

    it "skips data point recording when option is false" do
      expect do
        AssetProcessingService.process_attribute_update(asset, "totalPowerOutput", 800, record_datapoint: false)
      end.not_to change { DataPoint.count }
    end

    it "triggers attribute change rules by default" do
      rule = Rule.create!(
        name: "Attribute Change Rule",
        enabled: true,
        when_config: {
          "condition" => "Asset attribute value changed",
          "attribute" => "totalPowerOutput"
        },
        then_config: [ { "action" => "Log event" } ]
      )

      expect do
        AssetProcessingService.process_attribute_update(asset, "totalPowerOutput", 800)
      end.to have_enqueued_job(RuleExecutionJob).with(rule.id)
    end
  end

  describe ".process_attribute_updates" do
    it "processes multiple attribute updates" do
      attributes = {
        "totalPowerOutput" => 800,
        "efficiency" => 0.85
      }

      AssetProcessingService.process_attribute_updates(asset, attributes)

      asset.reload
      expect(asset.attributes_data["totalPowerOutput"]).to eq(800)
      expect(asset.attributes_data["efficiency"]).to eq(0.85)
    end
  end

  describe ".process_outdated_attributes" do
    before do
      AssetDatapointService.record_datapoint(asset, "totalCapacity", 1000, timestamp: 2.hours.ago)
    end

    it "finds assets with outdated attributes" do
      outdated = AssetProcessingService.process_outdated_attributes(threshold: 1.hour)

      expect(outdated["totalCapacity"]).to include(asset)
    end

    it "does not include assets with recent data points" do
      AssetDatapointService.record_datapoint(asset, "totalCapacity", 1000, timestamp: 30.minutes.ago)

      outdated = AssetProcessingService.process_outdated_attributes(threshold: 1.hour)

      # If the attribute is not in the hash (nil), that means no outdated assets for this attribute
      # If it exists, it should not include the asset with recent data points
      if outdated["totalCapacity"].nil?
        expect(outdated["totalCapacity"]).to be_nil
      else
        expect(outdated["totalCapacity"]).not_to include(asset)
      end
    end
  end
end
