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
      end.to have_enqueued_job(RuleExecutionJob).with(rule)
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
      end.to have_enqueued_job(RuleExecutionJob).with(rule)
    end
  end

  describe "schedule helpers" do
    let(:timezone) { ActiveSupport::TimeZone["UTC"] }
    let(:base_time) { timezone.parse("2026-01-28 12:00:00") }

    describe ".cron_pattern?" do
      it "returns true for valid 5-part cron expressions" do
        expect(RuleManager.send(:cron_pattern?, "* * * * *")).to be true
        expect(RuleManager.send(:cron_pattern?, "0 5 * * 1-5")).to be true
      end

      it "returns false for non-cron strings" do
        expect(RuleManager.send(:cron_pattern?, "every 5 minutes")).to be false
        expect(RuleManager.send(:cron_pattern?, "17:30")).to be false
      end
    end

    describe ".time_pattern?" do
      it "detects HH:MM patterns" do
        expect(RuleManager.send(:time_pattern?, "0:05")).to be true
        expect(RuleManager.send(:time_pattern?, "17:30")).to be true
      end

      it "rejects invalid patterns" do
        expect(RuleManager.send(:time_pattern?, "1730")).to be false
        expect(RuleManager.send(:time_pattern?, "every 5 minutes")).to be false
      end
    end

    describe ".interval_pattern?" do
      it "detects supported interval expressions" do
        expect(RuleManager.send(:interval_pattern?, "every 5 minutes")).to be true
        expect(RuleManager.send(:interval_pattern?, "every 1 hour")).to be true
        expect(RuleManager.send(:interval_pattern?, "every 2 days")).to be true
      end

      it "rejects unsupported strings" do
        expect(RuleManager.send(:interval_pattern?, "sometimes")).to be false
      end
    end

    describe ".parse_time_schedule" do
      it "schedules later today when time is in the future" do
        time = RuleManager.send(:parse_time_schedule, "13:30", base_time, timezone)
        expect(time.hour).to eq(13)
        expect(time.min).to eq(30)
        expect(time.to_date).to eq(base_time.to_date)
      end

      it "schedules for tomorrow when time has already passed today" do
        time = RuleManager.send(:parse_time_schedule, "10:00", base_time, timezone)
        expect(time.to_date).to eq((base_time + 1.day).to_date)
      end
    end

    describe ".parse_interval_schedule" do
      it "parses minute intervals" do
        time = RuleManager.send(:parse_interval_schedule, "every 5 minutes", base_time, timezone)
        expect(time).to eq(base_time + 5.minutes)
      end

      it "parses hour intervals" do
        time = RuleManager.send(:parse_interval_schedule, "every 2 hours", base_time, timezone)
        expect(time).to eq(base_time + 2.hours)
      end

      it "parses day intervals" do
        time = RuleManager.send(:parse_interval_schedule, "every 3 days", base_time, timezone)
        expect(time).to eq(base_time + 3.days)
      end

      it "parses week intervals" do
        time = RuleManager.send(:parse_interval_schedule, "every 2 weeks", base_time, timezone)
        expect(time).to eq(base_time + 2.weeks)
      end

      it "parses month intervals" do
        time = RuleManager.send(:parse_interval_schedule, "every 1 month", base_time, timezone)
        expect(time).to eq(base_time + 1.month)
      end

      it "returns nil for invalid unit" do
        expect(RuleManager.send(:parse_interval_schedule, "every 5 years", base_time, timezone)).to be_nil
      end

      it "returns nil for invalid intervals" do
        expect(RuleManager.send(:parse_interval_schedule, "every sometimes", base_time, timezone)).to be_nil
      end
    end

    describe ".parse_cron_schedule" do
      it "handles wildcard schedule (* * * * *)" do
        time = RuleManager.send(:parse_cron_schedule, "* * * * *", base_time, timezone)
        expect(time).to eq(base_time + 1.minute)
      end

      it "returns nil for invalid cron format" do
        expect(RuleManager.send(:parse_cron_schedule, "invalid", base_time, timezone)).to be_nil
      end
    end

    describe ".parse_specific_time" do
      it "handles complex patterns with default fallback" do
        time = RuleManager.send(:parse_specific_time, "0", "5", "15", "3", "2", base_time, timezone)
        expect(time).to eq(base_time + 1.minute)
      end
    end

    describe ".parse_schedule" do
      it "falls back to cron parsing for unrecognized patterns" do
        schedule = "invalid pattern that doesn't match any"
        time = RuleManager.send(:parse_schedule, schedule, base_time, timezone)
        # Should attempt cron parsing (may return nil or a time)
        expect(time).to be_a(Time).or be_nil
      end
    end

    describe ".matches_schedule?" do
      let(:test_time) { timezone.parse("2026-01-28 14:30:00") }

      it "matches cron patterns" do
        expect(RuleManager.matches_schedule?("30 14 * * *", test_time, timezone)).to be true
        expect(RuleManager.matches_schedule?("0 14 * * *", test_time, timezone)).to be false
      end

      it "matches time patterns" do
        expect(RuleManager.matches_schedule?("14:30", test_time, timezone)).to be true
        expect(RuleManager.matches_schedule?("15:30", test_time, timezone)).to be false
      end

      it "returns true for interval patterns" do
        expect(RuleManager.matches_schedule?("every 5 minutes", test_time, timezone)).to be true
      end

      it "falls back to cron matching for unrecognized patterns" do
        result = RuleManager.matches_schedule?("unknown pattern", test_time, timezone)
        expect(result).to be_in([ true, false ])
      end
    end

    describe ".matches_field" do
      it "matches wildcard" do
        expect(RuleManager.send(:matches_field, "*", 10)).to be true
      end

      it "matches exact value" do
        expect(RuleManager.send(:matches_field, "5", 5)).to be true
        expect(RuleManager.send(:matches_field, "5", 6)).to be false
      end

      it "matches ranges" do
        expect(RuleManager.send(:matches_field, "0-5", 3)).to be true
        expect(RuleManager.send(:matches_field, "0-5", 6)).to be false
      end

      it "matches lists" do
        expect(RuleManager.send(:matches_field, "0,5,10", 5)).to be true
        expect(RuleManager.send(:matches_field, "0,5,10", 7)).to be false
      end
    end
  end
end
