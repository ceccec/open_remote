class RuleExecution < ApplicationRecord
  belongs_to :rule

  validates :executed_at, presence: true
  validates :status, presence: true

  has_paper_trail

  # Scopes
  scope :successful, -> { where(status: "success") }
  scope :failed, -> { where(status: "failed") }
  scope :skipped, -> { where(status: "skipped") }
  scope :recent, -> { order(executed_at: :desc) }
  scope :for_rule, ->(rule) { where(rule: rule) }
  scope :with_errors, -> { where.not(error_message: nil) }
end
