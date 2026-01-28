require "rails_helper"

RSpec.describe Rule, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      rule = Rule.new(
        name: "Test Rule",
        description: "A test rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ],
        timezone: "UTC"
      )
      expect(rule).to be_valid
    end

    it "is invalid without name" do
      rule = Rule.new(
        when_config: {},
        then_config: []
      )
      expect(rule).not_to be_valid
      expect(rule.errors[:name]).to include("can't be blank")
    end

    it "is invalid without when_config" do
      rule = Rule.new(name: "Test Rule", then_config: [])
      expect(rule).not_to be_valid
    end

    it "is invalid without then_config" do
      rule = Rule.new(name: "Test Rule", when_config: {})
      expect(rule).not_to be_valid
    end

    it "defaults enabled to true" do
      rule = Rule.create!(
        name: "Test Rule",
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ]
      )
      expect(rule.enabled).to be_truthy
    end

    it "defaults timezone to UTC" do
      rule = Rule.create!(
        name: "Test Rule",
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ]
      )
      expect(rule.timezone).to eq("UTC")
    end

    it "adds validation errors when when_config is blank" do
      rule = Rule.new(
        name: "Invalid Rule",
        when_config: nil,
        then_config: [ { "action" => "Log event" } ]
      )
      expect(rule).not_to be_valid
      expect(rule.errors[:when_config]).to include("can't be blank")

      rule.when_config = {}
      rule.valid?
      expect(rule.errors[:when_config]).to include("can't be blank")
    end

    it "adds validation errors when then_config is blank" do
      rule = Rule.new(
        name: "Invalid Rule",
        when_config: { "condition" => "Schedule" },
        then_config: nil
      )
      expect(rule).not_to be_valid
      expect(rule.errors[:then_config]).to include("can't be blank")

      rule.then_config = []
      rule.valid?
      expect(rule.errors[:then_config]).to include("can't be blank")

      rule.then_config = {}
      rule.valid?
      expect(rule.errors[:then_config]).to include("can't be blank")
    end

    it "returns pretty JSON representations of configs" do
      rule = Rule.create!(
        name: "Pretty Rule",
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ]
      )

      expect(rule.when_config_pretty_json).to include("condition")
      expect(rule.then_config_pretty_json).to include("Log event")
    end

    it "pretty prints empty configs as empty objects/arrays" do
      rule = Rule.new(
        name: "Pretty Empty Rule",
        when_config: nil,
        then_config: nil
      )

      expect(JSON.parse(rule.when_config_pretty_json)).to eq({})
      expect(JSON.parse(rule.then_config_pretty_json)).to eq([])
    end
  end

  describe "associations" do
    it "has many rule_executions" do
      rule = Rule.create!(
        name: "Test Rule",
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ]
      )
      execution = RuleExecution.create!(
        rule: rule,
        executed_at: Time.current,
        status: "success"
      )
      expect(rule.rule_executions).to include(execution)
    end
  end

  describe "Mapping::RuleJsonMapping" do
    it "imports rule from OpenRemote JSON" do
      json_node = {
        "name" => "Imported Rule",
        "description" => "A test rule",
        "enabled" => true,
        "when" => { "condition" => "Schedule" },
        "then" => [ { "action" => "Log event" } ]
      }

      rule = Rule.from_openremote_json(json_node)
      expect(rule.name).to eq("Imported Rule")
      expect(rule.description).to eq("A test rule")
      expect(rule.enabled).to be_truthy
      expect(rule.when_config["condition"]).to eq("Schedule")
      expect(rule.then_config.first["action"]).to eq("Log event")
    end

    it "exports rule to OpenRemote JSON" do
      rule = Rule.create!(
        name: "Test Rule",
        description: "A test",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ]
      )

      json = rule.to_openremote_json
      expect(json["name"]).to eq("Test Rule")
      expect(json["description"]).to eq("A test")
      expect(json["enabled"]).to be_truthy
      expect(json["when"]["condition"]).to eq("Schedule")
      expect(json["then"].first["action"]).to eq("Log event")
    end
  end

  describe "Rules::Execution" do
    let(:asset_type) { AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" } }
    let(:asset) do
      Asset.create!(
        name: "Test Park",
        asset_type: asset_type,
        attributes_data: { "totalCapacity" => 1000, "totalPowerOutput" => 800 }
      )
    end

    it "executes scheduled rule" do
      rule = Rule.create!(
        name: "Scheduled Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event", "message" => "Test message" } ]
      )

      expect { rule.execute! }.to change { RuleExecution.count }.by(1)
      execution = rule.rule_executions.last
      expect(execution.status).to eq("success")
    end

    it "skips disabled rule" do
      rule = Rule.create!(
        name: "Disabled Rule",
        enabled: false,
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ]
      )

      expect { rule.execute! }.to change { RuleExecution.count }.by(1)
      execution = rule.rule_executions.last
      expect(execution.status).to eq("skipped")
      expect(execution.result["reason"]).to eq("disabled")
    end

    it "executes attribute value rule when condition is met" do
      asset
      Rule.create!(
        name: "Attribute Rule",
        enabled: true,
        when_config: {
          "condition" => "Asset attribute value",
          "asset" => "SolarPark",
          "attribute" => "totalPowerOutput",
          "operator" => "greater than",
          "value" => 500
        },
        then_config: [ { "action" => "Send notification", "message" => "High output", "severity" => "info" } ]
      )

      expect { Rule.first.execute! }.to change { Notification.count }.by(1)
      execution = RuleExecution.last
      expect(execution.status).to eq("success")
    end

    it "skips attribute value rule when condition is not met" do
      asset
      rule = Rule.create!(
        name: "Attribute Rule",
        enabled: true,
        when_config: {
          "condition" => "Asset attribute value",
          "asset" => "SolarPark",
          "attribute" => "totalPowerOutput",
          "operator" => "greater than",
          "value" => 1000
        },
        then_config: [ { "action" => "Log event" } ]
      )

      expect { rule.execute! }.to change { RuleExecution.count }.by(1)
      execution = rule.rule_executions.last
      expect(execution.status).to eq("skipped")
      expect(execution.result["reason"]).to eq("condition_not_met")
    end

    it "handles execution errors gracefully" do
      rule = Rule.create!(
        name: "Error Rule",
        enabled: true,
        when_config: { "condition" => "Unknown" },
        then_config: [ { "action" => "Log event" } ]
      )

      expect { rule.execute! }.to change { RuleExecution.count }.by(1)
      execution = rule.rule_executions.last
      expect(execution.status).to eq("skipped")
    end

    it "detects performance deviations between assets and sends notifications" do
      high_output_asset = Asset.create!(
        name: "High Output Park",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 2000, "location" => "Highland" }
      )
      low_output_asset = Asset.create!(
        name: "Low Output Park",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 100, "location" => "Lowland" }
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
            "message" => "Deviation detected at ${assetName} (${location})"
          }
        ]
      )

      expect { rule.execute! }.to change { Notification.count }.by(2)

      notifications = Notification.where(rule: rule).order(:sent_at)
      expect(notifications.map(&:asset)).to contain_exactly(high_output_asset, low_output_asset)
      notifications.each do |notification|
        expect(notification.severity).to eq("warning")
        expect(notification.message).to include(notification.asset.name)
        expect(notification.message).to include(notification.asset.attributes_data["location"])
      end
    end

    it "supports different comparison operators in attribute value rules" do
      asset

      equal_rule = Rule.create!(
        name: "Equals Rule",
        enabled: true,
        when_config: {
          "condition" => "Asset attribute value",
          "asset" => "SolarPark",
          "attribute" => "totalPowerOutput",
          "operator" => "equals",
          "value" => 800
        },
        then_config: [ { "action" => "Log event" } ]
      )

      less_than_rule = Rule.create!(
        name: "Less Than Rule",
        enabled: true,
        when_config: {
          "condition" => "Asset attribute value",
          "asset" => "SolarPark",
          "attribute" => "totalPowerOutput",
          "operator" => "less than",
          "value" => 900
        },
        then_config: [ { "action" => "Log event" } ]
      )

      expect { equal_rule.execute! }.to change { RuleExecution.count }.by(1)
      expect(RuleExecution.last.status).to eq("success")

      expect { less_than_rule.execute! }.to change { RuleExecution.count }.by(1)
      expect(RuleExecution.last.status).to eq("success")
    end

    it "executes attribute changed rules without condition checks" do
      asset
      rule = Rule.create!(
        name: "Changed Rule",
        enabled: true,
        when_config: {
          "condition" => "Asset attribute value changed",
          "asset" => "SolarPark",
          "attribute" => "totalPowerOutput"
        },
        then_config: [ { "action" => "Log event", "message" => "Changed" } ]
      )

      expect { rule.execute! }.to change { RuleExecution.count }.by(1)
      expect(RuleExecution.last.status).to eq("success")
    end

    it "logs informational actions without raising for forecast/grid strategy actions" do
      asset
      rule = Rule.create!(
        name: "Logging Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [
          { "action" => "Trigger forecast recalculation" },
          { "action" => "Evaluate grid export strategy" }
        ]
      )

      expect(Rails.logger).to receive(:info).twice
      expect { rule.execute! }.to change { RuleExecution.count }.by(1)
      expect(RuleExecution.last.status).to eq("success")
    end

    it "logs a failed execution and re-raises when an error occurs" do
      rule = Rule.create!(
        name: "Erroring Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ]
      )

      allow(rule).to receive(:handle_scheduled_rule).and_raise(StandardError, "boom")

      expect do
        expect { rule.execute! }.to raise_error(StandardError, "boom")
      end.to change { RuleExecution.count }.by(1)

      execution = RuleExecution.last
      expect(execution.status).to eq("failed")
      expect(execution.result["error"]).to eq("boom")
      expect(execution.result["backtrace"]).to be_an(Array)
      expect(execution.result["backtrace"].length).to be <= 5
    end
  end
end
