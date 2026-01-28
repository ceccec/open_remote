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
  has_many :rule_executions, dependent: :destroy

  validates :name, presence: true

  validate :when_config_presence
  validate :then_config_presence

  include Rule::Execution
  include Mapping::RuleJsonMapping

  has_paper_trail

  # Scopes
  scope :enabled, -> { where(enabled: true) }
  scope :disabled, -> { where(enabled: false) }
  scope :with_schedule, -> { where.not(schedule: [ nil, "" ]) }
  scope :scheduled, -> { where("when_config->>'condition' = ?", "Schedule") }
  scope :attribute_value, -> { where("when_config->>'condition' = ?", "Asset attribute value") }
  scope :attribute_changed, -> { where("when_config->>'condition' = ?", "Asset attribute value changed") }
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

  private

  ##
  # Ensure `when_config` is present and non-empty so rules always have
  # a meaningful condition payload.
  #
  # @return [void]
  def when_config_presence
    errors.add(:when_config, "can't be blank") if when_config.nil? || when_config == {}
  end

  ##
  # Ensure `then_config` is present and non-empty so rules always have
  # at least one action to perform or log.
  #
  # @return [void]
  def then_config_presence
    errors.add(:then_config, "can't be blank") if then_config.nil? || then_config == [] || then_config == {}
  end
end
