require "rails_helper"

RSpec.describe RuleManager do
  describe ".find_due_rules" do
    let(:solar_park_type) { AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" } }

    it "returns enabled rules with schedule condition" do
      rule1 = Rule.create!(
        name: "Scheduled Rule 1",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ],
        schedule: "0 * * * *",
        timezone: "UTC"
      )

      rule2 = Rule.create!(
        name: "Scheduled Rule 2",
        enabled: false,
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ],
        schedule: "0 * * * *"
      )

      rule3 = Rule.create!(
        name: "Attribute Rule",
        enabled: true,
        when_config: { "condition" => "Asset attribute value" },
        then_config: [ { "action" => "Log event" } ]
      )

      due_rules = RuleManager.find_due_rules

      expect(due_rules).to include(rule1)
      expect(due_rules).not_to include(rule2)
      expect(due_rules).not_to include(rule3)
    end
  end

  describe ".rule_due?" do
    let(:rule) do
      Rule.create!(
        name: "Test Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ],
        schedule: "0 * * * *",
        timezone: "UTC"
      )
    end

    it "returns false for rules without schedule" do
      rule.schedule = nil
      expect(RuleManager.rule_due?(rule)).to be false
    end

    it "returns true for rules with wildcard schedule" do
      rule.schedule = "* * * * *"
      expect(RuleManager.rule_due?(rule)).to be true
    end
  end

  describe ".next_execution_time" do
    let(:rule) do
      Rule.create!(
        name: "Test Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ],
        timezone: "UTC"
      )
    end

    it "returns nil for rules without schedule" do
      rule.schedule = nil
      expect(RuleManager.next_execution_time(rule)).to be_nil
    end

    it "parses cron-like schedules" do
      rule.schedule = "0 * * * *"
      next_time = RuleManager.next_execution_time(rule)
      expect(next_time).to be_a(Time)
    end

    it "parses time schedules (HH:MM)" do
      rule.schedule = "17:30"
      next_time = RuleManager.next_execution_time(rule)
      expect(next_time).to be_a(Time)
      expect(next_time.hour).to eq(17)
      expect(next_time.min).to eq(30)
    end

    it "parses interval schedules" do
      rule.schedule = "every 5 minutes"
      next_time = RuleManager.next_execution_time(rule)
      expect(next_time).to be_a(Time)
      expect(next_time).to be > Time.current
    end

    it "handles timezone correctly" do
      rule.schedule = "17:30"
      rule.timezone = "America/New_York"
      next_time = RuleManager.next_execution_time(rule)
      expect(next_time.time_zone.name).to eq("America/New_York")
    end
  end

  describe ".execute_due_rules" do
    let(:rule) do
      Rule.create!(
        name: "Due Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ],
        schedule: "* * * * *", # Every minute
        timezone: "UTC"
      )
    end

    it "enqueues jobs for due rules" do
      rule # Ensure rule exists

      expect do
        RuleManager.execute_due_rules
      end.to have_enqueued_job(RuleExecutionJob).with(rule.id)
    end

    it "returns count of enqueued rules" do
      rule # Ensure rule exists

      count = RuleManager.execute_due_rules
      expect(count).to be >= 1
    end
  end

  describe ".enqueue_rule_execution" do
    let(:rule) do
      Rule.create!(
        name: "Test Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ]
      )
    end

    it "enqueues a RuleExecutionJob" do
      expect do
        RuleManager.enqueue_rule_execution(rule)
      end.to have_enqueued_job(RuleExecutionJob).with(rule.id)
    end
  end
end
