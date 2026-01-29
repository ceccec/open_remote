# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rule Engine", type: :feature do
  describe "Schedule-Based Rules" do
    it "executes rules based on cron schedules" do
      rule = Rule.create!(
        name: "Daily Report Rule",
        enabled: true,
        schedule: "0 9 * * *", # Every day at 9 AM
        timezone: "America/New_York",
        when_config: {
          "condition" => "Schedule",
          "schedule" => "0 9 * * *"
        },
        then_config: [
          {
            "action" => "Log event",
            "message" => "Daily report generated"
          }
        ]
      )

      # Test schedule matching
      base_time = Time.zone.parse("2026-01-28 08:00:00")
      next_execution = RuleManager.parse_schedule(rule.schedule, base_time, rule.timezone)

      expect(next_execution).to be_a(Time)
      expect(RuleManager.matches_schedule?(rule.schedule, base_time, rule.timezone)).to be false

      # At scheduled time, it should match
      scheduled_time = Time.zone.parse("2026-01-28 09:00:00")
      expect(RuleManager.matches_schedule?(rule.schedule, scheduled_time, rule.timezone)).to be true
    end

    it "supports interval-based schedules" do
      rule = Rule.create!(
        name: "Every 5 Minutes Rule",
        enabled: true,
        schedule: "every 5 minutes", # Every 5 minutes
        when_config: {
          "condition" => "Schedule",
          "schedule" => "every 5 minutes"
        },
        then_config: [ { "action" => "Log event" } ]
      )

      base_time = Time.zone.parse("2026-01-28 10:00:00")
      expect(RuleManager.matches_schedule?(rule.schedule, base_time, rule.timezone)).to be true

      # 6 minutes later should also match (intervals always return true)
      later_time = base_time + 6.minutes
      expect(RuleManager.matches_schedule?(rule.schedule, later_time, rule.timezone)).to be true
    end

    it "supports time-of-day schedules" do
      rule = Rule.create!(
        name: "Morning Check",
        enabled: true,
        schedule: "08:00", # Every day at 8 AM
        timezone: "UTC",
        when_config: {
          "condition" => "Schedule",
          "schedule" => "08:00"
        },
        then_config: [ { "action" => "Log event" } ]
      )

      morning_time = Time.zone.parse("2026-01-28 08:00:00")
      expect(RuleManager.matches_schedule?(rule.schedule, morning_time, rule.timezone)).to be true

      afternoon_time = Time.zone.parse("2026-01-28 14:00:00")
      expect(RuleManager.matches_schedule?(rule.schedule, afternoon_time, rule.timezone)).to be false
    end
  end

  describe "Attribute-Based Rules" do
    it "triggers rules when asset attribute values match conditions" do
      park = Asset.create!(
        name: "Monitored Park",
        asset_type: AssetType.create!(name: "SolarPark"),
        attributes_data: { "totalPowerOutput" => 1000 }
      )

      rule = Rule.create!(
        name: "High Output Alert",
        enabled: true,
        when_config: {
          "condition" => "Asset attribute value",
          "assetId" => park.id.to_s,
          "attributeName" => "totalPowerOutput",
          "operator" => ">",
          "value" => 500
        },
        then_config: [
          {
            "action" => "Send notification",
            "message" => "Power output exceeded threshold"
          }
        ]
      )

      # Rule should match when condition is met (test via execute! which uses attribute_value_condition?)
      # Note: attribute_value_condition? is private, so we test via execute! which uses it
      expect(rule.when_config["condition"]).to eq("Asset attribute value")

      # Update asset to match condition
      park.update!(attributes_data: { "totalPowerOutput" => 1000 })

      # Execute rule to verify it processes the condition
      expect { rule.execute! }.to change { RuleExecution.count }.by(1)
      execution = rule.rule_executions.last
      expect(execution.status).to eq("success")
    end

    it "triggers rules when asset attributes change" do
      park = Asset.create!(
        name: "Change Detection Park",
        asset_type: AssetType.create!(name: "SolarPark"),
        attributes_data: { "status" => "online" }
      )

      rule = Rule.create!(
        name: "Status Change Alert",
        enabled: true,
        when_config: {
          "condition" => "Asset attribute value changed",
          "assetId" => park.id.to_s,
          "attributeName" => "status"
        },
        then_config: [
          {
            "action" => "Log event",
            "message" => "Asset status changed"
          }
        ]
      )

      # Change the attribute and execute rule
      park.update!(attributes_data: { "status" => "offline" })

      # Execute rule to verify it processes attribute changes
      expect { rule.execute! }.to change { RuleExecution.count }.by(1)
      execution = rule.rule_executions.last
      expect(execution.status).to eq("success")
    end
  end

  describe "Rule Execution" do
    it "tracks rule execution history with status and results" do
      rule = Rule.create!(
        name: "Tracked Rule",
        enabled: true,
        when_config: { "condition" => "Schedule", "schedule" => "* * * * *" },
        then_config: [ { "action" => "Log event" } ]
      )

      execution = RuleExecution.create!(
        rule: rule,
        executed_at: Time.current,
        status: "success",
        result: { "message" => "Rule executed successfully" }
      )

      expect(rule.rule_executions).to include(execution)
      expect(Rule.recently_executed).to include(rule)

      # Query by status
      expect(RuleExecution.successful).to include(execution)
      expect(RuleExecution.failed).not_to include(execution)
    end

    it "supports rule scopes for filtering" do
      enabled_rule = Rule.create!(
        name: "Enabled Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log" } ]
      )

      disabled_rule = Rule.create!(
        name: "Disabled Rule",
        enabled: false,
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log" } ]
      )

      scheduled_rule = Rule.create!(
        name: "Scheduled Rule",
        enabled: true,
        schedule: "0 * * * *",
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log" } ]
      )

      expect(Rule.enabled).to include(enabled_rule, scheduled_rule)
      expect(Rule.enabled).not_to include(disabled_rule)
      expect(Rule.disabled).to include(disabled_rule)
      expect(Rule.scheduled).to include(scheduled_rule)
    end
  end

  describe "OpenRemote Rule Import/Export" do
    it "imports rules from OpenRemote JSON format" do
      json_rule = {
        "name" => "Imported Rule",
        "enabled" => true,
        "when" => {
          "condition" => "Schedule",
          "schedule" => "0 12 * * *"
        },
        "then" => [
          {
            "action" => "Send notification",
            "message" => "Noon alert"
          }
        ]
      }

      rule = Rule.from_openremote_json(json_rule)

      expect(rule.name).to eq("Imported Rule")
      expect(rule.enabled).to be true
      expect(rule.when_config["condition"]).to eq("Schedule")
      expect(rule.then_config.first["action"]).to eq("Send notification")
    end

    it "exports rules to OpenRemote JSON format" do
      rule = Rule.create!(
        name: "Export Rule",
        enabled: true,
        schedule: "0 9 * * *",
        timezone: "UTC",
        when_config: {
          "condition" => "Schedule",
          "schedule" => "0 9 * * *"
        },
        then_config: [
          {
            "action" => "Log event",
            "message" => "Morning check"
          }
        ]
      )

      json = rule.to_openremote_json

      expect(json["name"]).to eq("Export Rule")
      expect(json["enabled"]).to be true
      expect(json["when"]["condition"]).to eq("Schedule")
      expect(json["then"].first["action"]).to eq("Log event")
    end
  end
end
