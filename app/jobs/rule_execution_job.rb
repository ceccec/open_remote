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
  def perform(rule)
    rule.execute!
  end
end
