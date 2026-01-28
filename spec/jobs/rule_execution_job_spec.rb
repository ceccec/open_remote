require "rails_helper"

RSpec.describe RuleExecutionJob, type: :job do
  let(:rule) do
    Rule.create!(
      name: "Test Rule",
      enabled: true,
      when_config: { "condition" => "Schedule" },
      then_config: [ { "action" => "Log event" } ]
    )
  end

  describe "#perform" do
    it "executes the rule" do
      expect { RuleExecutionJob.perform_now(rule.id) }.to change { RuleExecution.count }.by(1)
    end

    it "does not execute disabled rules" do
      rule.update!(enabled: false)
      RuleExecutionJob.perform_now(rule.id)
      execution = rule.rule_executions.last
      expect(execution.status).to eq("skipped")
    end

    it "raises when rule is missing" do
      expect { RuleExecutionJob.perform_now(99999) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
