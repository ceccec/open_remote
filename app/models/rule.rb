##
# Declarative rule describing conditions (`when_config`) and actions (`then_config`)
# to be executed against portfolio assets.
# Execution semantics live in `Rule::Execution`, while JSON import/export is
# provided by `Mapping::RuleJsonMapping`.
#
# @!attribute [rw] name
#   @return [String] human-readable rule name (required)
# @!attribute [rw] description
#   @return [String, nil] optional free-form description
# @!attribute [rw] enabled
#   @return [Boolean] whether the rule may be executed
# @!attribute [rw] when_config
#   @return [Hash] JSONB condition payload, never `nil` in persisted records
# @!attribute [rw] then_config
#   @return [Array<Hash>, Hash] JSONB actions payload, never `nil` in persisted records
# @!attribute [rw] timezone
#   @return [String] timezone identifier used for schedule-based rules
class Rule < ApplicationRecord
  include TestExpectations

  has_many :rule_executions, dependent: :destroy

  validates :name, presence: true

  validate :when_config_presence
  validate :then_config_presence

  # Feature declarations
  feature :validates, :name, presence: true
  feature :associates, :has_many, :rule_executions, dependent: :destroy
  feature :provides, :when_config_pretty_json, :then_config_pretty_json, :execute!
  feature :scopes, :enabled, :disabled, :with_schedule, :scheduled, :attribute_value, :attribute_changed, :recently_executed, :with_failed_executions

  include Rule::Execution
  include Mapping::RuleJsonMapping
  include Rule::References
  include BatchActions

  has_paper_trail

  # Scopes
  # Indexed: enabled, schedule, when_config (GIN index for JSONB queries)
  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(enabled: false) }
  scope :with_schedule, -> { where.not(schedule: nil).where.not(schedule: "") }
  scope :scheduled, -> { where("when_config->>'condition' = ?", "Schedule") }
  scope :attribute_value, -> { where("when_config->>'condition' = ?", "Asset attribute value") }
  scope :attribute_changed, -> { where("when_config->>'condition' = ?", "Asset attribute value changed") }
  # Indexed: rule_executions.executed_at, rule_executions.status
  scope :recently_executed, -> { joins(:rule_executions).order("rule_executions.executed_at DESC").distinct }
  scope :with_failed_executions, -> { joins(:rule_executions).where(rule_executions: { status: "failed" }).distinct }

  ##
  # Pretty JSON representation of `when_config` for admin UI.
  #
  # @return [String]
  def when_config_pretty_json
    JSON.pretty_generate(when_config || {})
  end

  ##
  # Pretty JSON representation of `then_config` for admin UI.
  #
  # @return [String]
  def then_config_pretty_json
    JSON.pretty_generate(then_config || [])
  end

  ##
  # Check if rule is scheduled (has a schedule condition).
  #
  # @return [Boolean]
  def scheduled?
    schedule_condition?
  end

  ##
  # Get the last execution of this rule.
  #
  # @return [RuleExecution, nil]
  def last_execution
    rule_executions.order(executed_at: :desc).first
  end

  ##
  # Get the last successful execution of this rule.
  #
  # @return [RuleExecution, nil]
  def last_successful_execution
    rule_executions.successful.order(executed_at: :desc).first
  end

  ##
  # Check if rule has failed executions.
  #
  # @return [Boolean]
  def has_failed_executions?
    rule_executions.failed.any?
  end

  ##
  # Get execution count for this rule.
  #
  # @return [Hash] counts by status
  def execution_counts
    rule_executions.group(:status).count
  end

  private

  ##
  # Ensure `when_config` is present and non-empty so rules always have
  # a meaningful condition payload.
  #
  # @return [void]
  def when_config_presence
    if when_config.blank?
      errors.add(:when_config, :blank)
    end
  end

  ##
  # Ensure `then_config` is present and non-empty so rules always have
  # at least one action to perform or log.
  #
  # @return [void]
  def then_config_presence
    if then_config.blank?
      errors.add(:then_config, :blank)
    end
  end
end
