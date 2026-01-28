class RuleExecutionJob < ApplicationJob
  queue_as :default

  # Execute a single rule by id.
  #
  # @param rule_id [Integer] id of the rule to execute
  # @return [void]
  def perform(rule_id)
    rule = Rule.find(rule_id)
    rule.execute!
  end
end
