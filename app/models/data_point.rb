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
  belongs_to :asset

  validates :attribute_name, presence: true
  validates :value, presence: true
  validates :timestamp, presence: true

  include DataPoint::Analytics

  has_paper_trail

  # Scopes
  scope :for_asset, ->(asset) { where(asset: asset) }
  scope :for_attribute, ->(attr_name) { where(attribute_name: attr_name) }
  scope :recent, -> { order(timestamp: :desc) }
  scope :in_time_range, ->(from, to) { where(timestamp: from..to) }
  scope :latest_for_attribute, ->(asset, attr_name) { for_asset(asset).for_attribute(attr_name).recent.limit(1) }
end
