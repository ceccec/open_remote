##
# Recurring job to execute due rules periodically.
#
# This job should be scheduled to run frequently (e.g., every minute)
# to check for and execute rules that are due based on their schedules.
class RuleManagerJob < ApplicationJob
  queue_as :default

  ##
  # Execute all rules that are due for execution.
  #
  # @return [void]
  def perform
    count = RuleManager.execute_due_rules
    Rails.logger.info "RuleManager: Enqueued #{count} rule(s) for execution" if count > 0
  end
end
