##
# Job to execute a rule asynchronously.
#
# Uses GlobalID to pass the Rule object directly, which simplifies
# deserialization and provides better error handling if the rule is deleted.
#
class RuleExecutionJob < ApplicationJob
  queue_as :default

  ##
  # Execute a single rule.
  #
  # @param rule [Rule] the rule to execute
  # @return [void]
  # @raise [ActiveRecord::RecordNotFound] if the rule doesn't exist in the database
  def perform(rule)
    # Ensure the rule exists in the database
    raise ActiveRecord::RecordNotFound, "Rule not found" unless rule.persisted?

    rule.execute!
  end
end
