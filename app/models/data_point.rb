##
# Time-series measurement captured for a single `Asset`.
# Stores a JSONB `value` payload and timestamp, with analytics
# helpers mixed in from `DataPoint::Analytics`.
#
# @!attribute [rw] asset
#   @return [Asset] owning asset for this data point
# @!attribute [rw] attribute_name
#   @return [String] logical name of the measured attribute
# @!attribute [rw] value
#   @return [Hash] JSON-like payload containing the measured value
# @!attribute [rw] timestamp
#   @return [Time] point in time when the value was recorded
class DataPoint < ApplicationRecord
  include TestExpectations

  belongs_to :asset

  validates :attribute_name, presence: true
  validates :value, presence: true
  validates :timestamp, presence: true

  # Feature declarations
  feature :validates, :attribute_name, presence: true
  feature :validates, :value, presence: true
  feature :validates, :timestamp, presence: true
  feature :associates, :belongs_to, :asset
  feature :provides, :rails_admin_label, :sum_for, :average_for, :max_for, :min_for
  feature :scopes, :for_asset, :for_attribute, :recent, :in_time_range, :latest_for_attribute

  include DataPoint::Analytics
  include DataPoint::BatchActions
  include DataPoint::References
  include BatchActions

  has_paper_trail

  # Scopes
  # Indexed: asset_id, attribute_name, timestamp, composite (asset_id, attribute_name, timestamp)
  scope :for_asset, ->(asset) { where(asset: asset) }
  scope :for_attribute, ->(attr_name) { where(attribute_name: attr_name) }
  scope :recent, -> { order(timestamp: :desc) }
  scope :in_time_range, ->(from, to) { where(timestamp: from..to) }
  scope :latest_for_attribute, ->(asset, attr_name) { for_asset(asset).for_attribute(attr_name).recent.limit(1) }

  # RailsAdmin object label
  def rails_admin_label
    "#{asset&.name} - #{attribute_name} (#{timestamp&.strftime('%Y-%m-%d %H:%M')})"
  end

  ##
  # Extract numeric value from the value hash.
  #
  # @return [Numeric, nil] extracted numeric value
  def numeric_value
    return nil unless value.is_a?(Hash)
    val = value["value"] || value[:value] || value["data"] || value[:data]
    val.to_f if val.respond_to?(:to_f)
  end

  ##
  # Check if this data point is older than a given age.
  #
  # @param age [ActiveSupport::Duration] age threshold (e.g., 90.days)
  # @return [Boolean]
  def older_than?(age)
    timestamp < (Time.current - age)
  end

  ##
  # Check if this data point is within a time range.
  #
  # @param from [Time] start time
  # @param to [Time] end time
  # @return [Boolean]
  def in_range?(from, to)
    timestamp >= from && timestamp <= to
  end
end
