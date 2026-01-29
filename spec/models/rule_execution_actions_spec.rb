require "rails_helper"

RSpec.describe "Rule::Execution Action Handlers", type: :model do
  let(:asset_type) { AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" } }
  let(:asset) do
    Asset.create!(
      name: "Test Park",
      asset_type: asset_type,
      attributes_data: {
        "totalCapacity" => 1000,
        "totalPowerOutput" => 800
      }
    )
  end

  describe "#update_attribute_action" do
    it "updates attribute on all target assets" do
      # Ensure asset exists before executing rule
      asset

      rule = Rule.create!(
        name: "Update Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Update attribute",
            "attribute" => "totalPowerOutput",
            "value" => 900
          }
        ]
      )

      rule.execute!

      asset.reload
      expect(asset.attributes_data["totalPowerOutput"]).to eq(900)
    end

    it "handles multiple assets" do
      # Ensure assets exist before executing rule
      asset

      asset2 = Asset.create!(
        name: "Test Park 2",
        asset_type: asset_type,
        attributes_data: { "totalCapacity" => 2000 }
      )

      rule = Rule.create!(
        name: "Update Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Update attribute",
            "attribute" => "testAttribute",
            "value" => "testValue"
          }
        ]
      )

      rule.execute!

      expect(asset.reload.attributes_data["testAttribute"]).to eq("testValue")
      expect(asset2.reload.attributes_data["testAttribute"]).to eq("testValue")
    end

    it "initializes attributes_data if nil" do
      # Ensure asset exists and use update_column to bypass validations
      asset
      asset.update_column(:attributes_data, nil)

      rule = Rule.create!(
        name: "Update Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Update attribute",
            "attribute" => "newAttribute",
            "value" => "newValue"
          }
        ]
      )

      rule.execute!

      asset.reload
      expect(asset.attributes_data).to be_a(Hash)
      expect(asset.attributes_data["newAttribute"]).to eq("newValue")
    end
  end

  describe "#send_notification_action" do
    it "creates notifications for all target assets" do
      # Ensure asset exists before executing rule
      asset

      rule = Rule.create!(
        name: "Notification Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Send notification",
            "message" => "Test notification",
            "severity" => "warning"
          }
        ]
      )

      expect { rule.execute! }.to change { Notification.count }.by(1)

      notification = Notification.last
      expect(notification.asset).to eq(asset)
      expect(notification.rule).to eq(rule)
      expect(notification.message).to eq("Test notification")
      expect(notification.severity).to eq("warning")
      expect(notification.sent_at).to be_present
    end

    it "uses default message when not provided" do
      # Ensure asset exists before executing rule
      asset

      rule = Rule.create!(
        name: "Notification Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Send notification",
            "severity" => "info"
          }
        ]
      )

      rule.execute!

      notification = Notification.last
      expect(notification.message).to eq("Notification triggered")
      expect(notification.severity).to eq("info")
    end

    it "uses default severity when not provided" do
      # Ensure asset exists before executing rule
      asset

      rule = Rule.create!(
        name: "Notification Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Send notification",
            "message" => "Custom message"
          }
        ]
      )

      rule.execute!

      notification = Notification.last
      expect(notification.message).to eq("Custom message")
      expect(notification.severity).to eq("info")
    end

    it "interpolates message template with asset attributes" do
      asset.attributes_data["location"] = "Test Location"
      asset.save!

      # Ensure asset exists before executing rule
      asset

      rule = Rule.create!(
        name: "Notification Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Send notification",
            "message" => "Alert at ${assetName}: ${location}",
            "severity" => "error"
          }
        ]
      )

      rule.execute!

      notification = Notification.last
      expect(notification.message).to eq("Alert at Test Park: Test Location")
    end

    it "handles missing attribute placeholders gracefully" do
      # Ensure asset exists before executing rule
      asset

      rule = Rule.create!(
        name: "Notification Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Send notification",
            "message" => "Alert: ${nonexistent}",
            "severity" => "warning"
          }
        ]
      )

      rule.execute!

      notification = Notification.last
      expect(notification.message).to eq("Alert: ${nonexistent}")
    end
  end

  describe "#log_event_action" do
    it "creates info notifications for logging" do
      # Ensure asset exists before executing rule
      asset

      rule = Rule.create!(
        name: "Log Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Log event",
            "message" => "Event logged"
          }
        ]
      )

      expect { rule.execute! }.to change { Notification.count }.by(1)

      notification = Notification.last
      expect(notification.severity).to eq("info")
      expect(notification.message).to eq("Event logged")
    end

    it "uses default message when not provided" do
      # Ensure asset exists before executing rule
      asset

      rule = Rule.create!(
        name: "Log Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Log event"
          }
        ]
      )

      rule.execute!

      notification = Notification.last
      expect(notification.message).to eq("Event logged")
    end
  end

  describe "#compare_assets_for_deviation" do
    it "detects deviations and sends notifications" do
      high_asset = Asset.create!(
        name: "High Output",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 2000 }
      )
      low_asset = Asset.create!(
        name: "Low Output",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 100 }
      )

      rule = Rule.create!(
        name: "Deviation Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Compare assets",
            "assetType" => "SolarPark",
            "attribute" => "totalPowerOutput",
            "threshold" => 0.5,
            "message" => "Deviation detected"
          }
        ]
      )

      expect { rule.execute! }.to change { Notification.count }.by(2)

      notifications = Notification.where(rule: rule).order(:sent_at)
      expect(notifications.map(&:asset)).to contain_exactly(high_asset, low_asset)
      notifications.each do |notification|
        expect(notification.severity).to eq("warning")
        expect(notification.message).to include("Deviation detected")
      end
    end

    it "does not send notifications when deviation is below threshold" do
      Asset.create!(
        name: "Asset 1",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 1000 }
      )
      Asset.create!(
        name: "Asset 2",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 1100 }
      )

      rule = Rule.create!(
        name: "Deviation Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Compare assets",
            "assetType" => "SolarPark",
            "attribute" => "totalPowerOutput",
            "threshold" => 0.5,
            "message" => "Deviation detected"
          }
        ]
      )

      expect { rule.execute! }.not_to change { Notification.count }
    end

    it "skips when fewer than 2 assets exist" do
      rule = Rule.create!(
        name: "Deviation Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Compare assets",
            "assetType" => "SolarPark",
            "attribute" => "totalPowerOutput",
            "threshold" => 0.5
          }
        ]
      )

      expect { rule.execute! }.not_to change { Notification.count }
    end

    it "skips when average is zero" do
      Asset.create!(
        name: "Asset 1",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 0 }
      )
      Asset.create!(
        name: "Asset 2",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 0 }
      )

      rule = Rule.create!(
        name: "Deviation Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Compare assets",
            "assetType" => "SolarPark",
            "attribute" => "totalPowerOutput",
            "threshold" => 0.5
          }
        ]
      )

      expect { rule.execute! }.not_to change { Notification.count }
    end

    it "handles missing attribute values gracefully" do
      Asset.create!(
        name: "Asset 1",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 1000 }
      )
      Asset.create!(
        name: "Asset 2",
        asset_type: asset_type,
        attributes_data: {}
      )

      rule = Rule.create!(
        name: "Deviation Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Compare assets",
            "assetType" => "SolarPark",
            "attribute" => "totalPowerOutput",
            "threshold" => 0.5
          }
        ]
      )

      expect { rule.execute! }.not_to change { Notification.count }
    end

    it "supports asset_type key in addition to assetType" do
      high_asset = Asset.create!(
        name: "High Output",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 2000 }
      )
      low_asset = Asset.create!(
        name: "Low Output",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 100 }
      )

      rule = Rule.create!(
        name: "Deviation Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Compare assets",
            "asset_type" => "SolarPark",
            "attribute" => "totalPowerOutput",
            "threshold" => 0.5,
            "message" => "Deviation detected"
          }
        ]
      )

      expect { rule.execute! }.to change { Notification.count }.by(2)
    end
  end

  describe "#apply_action! with Calculate performance ratio" do
    it "updates performance ratio for SolarPark assets" do
      park = Asset.create!(
        name: "Park",
        asset_type: asset_type,
        attributes_data: {
          "totalCapacity" => 1000,
          "totalPowerOutput" => 750
        }
      )
      array_type = AssetType.find_or_create_by!(name: "SolarArray") { |at| at.display_name = "Solar Array" }
      array = Asset.create!(
        name: "Array",
        asset_type: array_type,
        attributes_data: {
          "arrayCapacity" => 500,
          "powerOutput" => 400
        }
      )

      rule = Rule.create!(
        name: "Performance Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Calculate performance ratio"
          }
        ]
      )

      rule.execute!

      park.reload
      expect(park.attributes_data["performanceRatio"]).to eq(0.75)

      array.reload
      expect(array.attributes_data["performanceRatio"]).to be_nil
    end
  end

  describe "#interpolate_message" do
    it "interpolates assetName placeholder" do
      # Ensure asset exists before executing rule
      asset

      rule = Rule.create!(
        name: "Test Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Send notification",
            "message" => "Alert for ${assetName}",
            "severity" => "info"
          }
        ]
      )

      rule.execute!

      notification = Notification.last
      expect(notification.message).to eq("Alert for Test Park")
    end

    it "handles multiple placeholders" do
      asset.attributes_data["location"] = "Location A"
      asset.attributes_data["status"] = "active"
      asset.save!

      # Ensure asset exists before executing rule
      asset

      rule = Rule.create!(
        name: "Test Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Send notification",
            "message" => "${assetName} at ${location} is ${status}",
            "severity" => "info"
          }
        ]
      )

      rule.execute!

      notification = Notification.last
      expect(notification.message).to eq("Test Park at Location A is active")
    end
  end

  describe "error handling" do
    it "logs failed execution with error details" do
      # Ensure asset exists before executing rule
      asset

      rule = Rule.create!(
        name: "Error Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          {
            "action" => "Update attribute",
            "attribute" => "test",
            "value" => "test"
          }
        ]
      )

      allow_any_instance_of(Asset).to receive(:save!).and_raise(StandardError, "Database error")

      expect do
        expect { rule.execute! }.to raise_error(StandardError, "Database error")
      end.to change { RuleExecution.count }.by(1)

      execution = RuleExecution.last
      expect(execution.status).to eq("failed")
      expect(execution.result["error"]).to eq("Database error")
      expect(execution.result["backtrace"]).to be_an(Array)
    end
  end
end
