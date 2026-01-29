class Notification < ApplicationRecord
  include TestExpectations

  belongs_to :asset, optional: true
  belongs_to :rule, optional: true

  validates :message, presence: true
  validates :severity, presence: true, inclusion: { in: %w[info warning error] }
  validates :sent_at, presence: true

  # Feature declarations
  feature :validates, :message, presence: true
  feature :validates, :severity, presence: true
  feature :validates, :sent_at, presence: true
  feature :associates, :belongs_to, :asset, optional: true
  feature :associates, :belongs_to, :rule, optional: true
  feature :provides, :rails_admin_label
  feature :scopes, :acknowledged, :unacknowledged, :by_severity, :recent, :for_asset, :for_rule, :info, :warning, :error

  include BatchActions

  has_paper_trail

  # Scopes
  # Indexed: acknowledged_at, severity, sent_at, asset_id, rule_id
  # Composite index: (acknowledged_at, severity, sent_at) for common filter combinations
  scope :acknowledged, -> { where.not(acknowledged_at: nil) }
  scope :unacknowledged, -> { where(acknowledged_at: nil) }
  scope :by_severity, ->(severity) { where(severity: severity) }
  scope :recent, -> { order(sent_at: :desc) }
  scope :for_asset, ->(asset) { where(asset: asset) }
  scope :for_rule, ->(rule) { where(rule: rule) }
  scope :info, -> { where(severity: "info") }
  scope :warning, -> { where(severity: "warning") }
  scope :error, -> { where(severity: "error") }

  # RailsAdmin object label
  def rails_admin_label
    parts = [ message&.truncate(50) ]
    parts << "(#{severity})" if severity.present?
    parts << asset&.name if asset.present?
    parts << rule&.name if rule.present?
    parts.join(" - ")
  end

  ##
  # Check if notification is acknowledged.
  #
  # @return [Boolean]
  def acknowledged?
    acknowledged_at.present?
  end

  ##
  # Acknowledge this notification.
  #
  # @return [Boolean] true if acknowledged successfully
  def acknowledge!
    update(acknowledged_at: Time.current)
  end

  ##
  # Check if notification is of a specific severity.
  #
  # @param severity_level [String] severity to check
  # @return [Boolean]
  def severity?(severity_level)
    severity == severity_level
  end
end
