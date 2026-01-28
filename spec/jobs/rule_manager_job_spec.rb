require "rails_helper"

RSpec.describe RuleManagerJob, type: :job do
  describe "#perform" do
    let(:rule) do
      Rule.create!(
        name: "Test Rule",
        enabled: true,
        when_config: { "condition" => "Schedule" },
        then_config: [ { "action" => "Log event" } ],
        schedule: "* * * * *",
        timezone: "UTC"
      )
    end

    it "calls RuleManager.execute_due_rules" do
      rule # Ensure rule exists

      expect(RuleManager).to receive(:execute_due_rules).and_return(1)
      RuleManagerJob.new.perform
    end

    it "logs when rules are enqueued" do
      rule # Ensure rule exists

      allow(RuleManager).to receive(:execute_due_rules).and_return(2)
      expect(Rails.logger).to receive(:info).with("RuleManager: Enqueued 2 rule(s) for execution")

      RuleManagerJob.new.perform
    end
  end
end
