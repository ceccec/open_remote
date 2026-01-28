##
# Service for managing asset data points.
#
# This service handles:
# - Recording data points for asset attributes
# - Querying historical data points
# - Managing data point retention and cleanup
class AssetDatapointService
  ##
  # Record a data point for an asset attribute.
  #
  # @param asset [Asset] the asset
  # @param attribute_name [String] name of the attribute
  # @param value [Object] attribute value (will be stored as JSONB)
  # @param timestamp [Time, nil] timestamp (defaults to current time)
  # @return [DataPoint] the created data point
  def self.record_datapoint(asset, attribute_name, value, timestamp: nil)
    timestamp ||= Time.current

    DataPoint.create!(
      asset: asset,
      attribute_name: attribute_name,
      value: value,
      timestamp: timestamp
    )
  end

  ##
  # Record data points for multiple attributes of an asset.
  #
  # @param asset [Asset] the asset
  # @param attributes [Hash<String, Object>] hash of attribute names to values
  # @param timestamp [Time, nil] timestamp (defaults to current time)
  # @return [Array<DataPoint>] created data points
  def self.record_datapoints(asset, attributes, timestamp: nil)
    timestamp ||= Time.current

    attributes.map do |attribute_name, value|
      record_datapoint(asset, attribute_name, value, timestamp: timestamp)
    end
  end

  ##
  # Get data points for an asset attribute within a time range.
  #
  # @param asset [Asset] the asset
  # @param attribute_name [String] name of the attribute
  # @param start_time [Time] start of time range
  # @param end_time [Time] end of time range
  # @return [ActiveRecord::Relation<DataPoint>] data points in the range
  def self.get_datapoints(asset, attribute_name, start_time:, end_time:)
    DataPoint.where(asset: asset, attribute_name: attribute_name)
             .where(timestamp: start_time..end_time)
             .order(timestamp: :asc)
  end

  ##
  # Get the latest data point for an asset attribute.
  #
  # @param asset [Asset] the asset
  # @param attribute_name [String] name of the attribute
  # @return [DataPoint, nil] latest data point or nil
  def self.get_latest_datapoint(asset, attribute_name)
    DataPoint.where(asset: asset, attribute_name: attribute_name)
             .order(timestamp: :desc)
             .first
  end

  ##
  # Get the latest data points for all attributes of an asset.
  #
  # @param asset [Asset] the asset
  # @return [Hash<String, DataPoint>] hash of attribute names to latest data points
  def self.get_latest_datapoints(asset)
    latest_by_attribute = DataPoint.where(asset: asset)
                                   .select("DISTINCT ON (attribute_name) *")
                                   .order(:attribute_name, timestamp: :desc)

    latest_by_attribute.index_by(&:attribute_name)
  end

  ##
  # Delete data points older than a specified age.
  #
  # @param older_than [ActiveSupport::Duration] age threshold (e.g., 90.days)
  # @return [Integer] number of data points deleted
  def self.cleanup_old_datapoints(older_than: 90.days)
    cutoff_time = Time.current - older_than
    DataPoint.where("timestamp < ?", cutoff_time).delete_all
  end

  ##
  # Record data points from asset attributes_data.
  #
  # This is useful for periodically recording current attribute values.
  #
  # @param asset [Asset] the asset
  # @param timestamp [Time, nil] timestamp (defaults to current time)
  # @return [Array<DataPoint>] created data points
  def self.record_current_attributes(asset, timestamp: nil)
    return [] unless asset.attributes_data.present?

    record_datapoints(asset, asset.attributes_data, timestamp: timestamp)
  end

  ##
  # Record data points for all assets of a given type.
  #
  # @param asset_type_name [String] name of the asset type
  # @param timestamp [Time, nil] timestamp (defaults to current time)
  # @return [Integer] number of data points created
  def self.record_all_attributes_for_type(asset_type_name, timestamp: nil)
    asset_type = AssetType.find_by(name: asset_type_name)
    return 0 unless asset_type

    timestamp ||= Time.current
    count = 0

    Asset.where(asset_type: asset_type).find_each do |asset|
      next unless asset.attributes_data.present?

      record_datapoints(asset, asset.attributes_data, timestamp: timestamp)
      count += asset.attributes_data.keys.length
    end

    count
  end
end
