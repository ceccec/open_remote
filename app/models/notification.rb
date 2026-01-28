class Notification < ApplicationRecord
  belongs_to :asset, optional: true
  belongs_to :rule, optional: true

  validates :message, presence: true
  validates :severity, presence: true
  validates :sent_at, presence: true

  has_paper_trail

  # Scopes
  scope :acknowledged, -> { where.not(acknowledged_at: nil) }
  scope :unacknowledged, -> { where(acknowledged_at: nil) }
  scope :by_severity, ->(severity) { where(severity: severity) }
  scope :recent, -> { order(sent_at: :desc) }
  scope :for_asset, ->(asset) { where(asset: asset) }
  scope :for_rule, ->(rule) { where(rule: rule) }
  scope :info, -> { where(severity: "info") }
  scope :warning, -> { where(severity: "warning") }
  scope :error, -> { where(severity: "error") }
end
