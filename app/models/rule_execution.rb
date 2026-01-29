class RuleExecution < ApplicationRecord
  include TestExpectations

  belongs_to :rule

  validates :executed_at, presence: true
  validates :status, presence: true, inclusion: { in: %w[success failed skipped] }

  # Feature declarations
  feature :validates, :executed_at, presence: true
  feature :validates, :status, presence: true
  feature :associates, :belongs_to, :rule
  feature :provides, :rails_admin_label
  feature :scopes, :successful, :failed, :skipped, :recent, :for_rule, :with_errors

  has_paper_trail

  # Scopes
  # Indexed: status, executed_at, rule_id, error_message
  # Composite index: (rule_id, status, executed_at) for common query patterns
  scope :successful, -> { where(status: "success") }
  scope :failed, -> { where(status: "failed") }
  scope :skipped, -> { where(status: "skipped") }
  scope :recent, -> { order(executed_at: :desc) }
  scope :for_rule, ->(rule) { where(rule: rule) }
  scope :with_errors, -> { where.not(error_message: nil) }

  # RailsAdmin object label
  def rails_admin_label
    "#{rule&.name} - #{status} (#{executed_at&.strftime('%Y-%m-%d %H:%M')})"
  end

  ##
  # Check if execution was successful.
  #
  # @return [Boolean]
  def successful?
    status == "success"
  end

  ##
  # Check if execution failed.
  #
  # @return [Boolean]
  def failed?
    status == "failed"
  end

  ##
  # Check if execution was skipped.
  #
  # @return [Boolean]
  def skipped?
    status == "skipped"
  end

  ##
  # Get error message from database column or result hash.
  # Checks the database column first, then falls back to extracting from result hash.
  #
  # @return [String, nil]
  def error_message
    # Access the database column using read_attribute to avoid method override conflict
    column_value = read_attribute(:error_message)
    return column_value if column_value.present?

    # Fall back to extracting from result hash if column is empty
    result.is_a?(Hash) ? (result["error"] || result[:error]) : nil
  end

  ##
  # Check if execution has an error.
  #
  # @return [Boolean]
  def has_error?
    error_message.present?
  end
end
