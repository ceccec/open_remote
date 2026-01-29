##
# Service for processing asset attributes and triggering related actions.
#
# This service handles:
# - Processing attribute updates
# - Triggering rules based on attribute changes
# - Managing attribute linking and dependencies
class AssetProcessingService
  ##
  # Process an attribute update for an asset.
  #
  # This method:
  # - Updates the asset's attributes_data
  # - Records a data point if configured
  # - Triggers rules that react to attribute changes
  #
  # @param asset [Asset] the asset
  # @param attribute_name [String] name of the attribute
  # @param value [Object] new attribute value
  # @param options [Hash] processing options
  #   - :record_datapoint [Boolean] whether to record a data point (default: true)
  #   - :trigger_rules [Boolean] whether to trigger attribute-change rules (default: true)
  # @return [Asset] the updated asset
  def self.process_attribute_update(asset, attribute_name, value, options = {})
    options = { record_datapoint: true, trigger_rules: true }.merge(options)

    # Update the attribute
    asset.attributes_data ||= {}
    asset.attributes_data[attribute_name] = value
    asset.save!

    # Record data point if configured
    if options[:record_datapoint]
      AssetDatapointService.record_datapoint(asset, attribute_name, value)
    end

    # Trigger rules that react to attribute changes
    if options[:trigger_rules]
      trigger_attribute_change_rules(asset, attribute_name, value)
    end

    asset
  end

  ##
  # Process multiple attribute updates for an asset.
  #
  # @param asset [Asset] the asset
  # @param attributes [Hash<String, Object>] hash of attribute names to values
  # @param options [Hash] processing options (see #process_attribute_update)
  # @return [Asset] the updated asset
  def self.process_attribute_updates(asset, attributes, options = {})
    attributes.each do |attribute_name, value|
      process_attribute_update(asset, attribute_name, value, options)
    end

    asset.reload
  end

  ##
  # Trigger rules that react to attribute changes.
  #
  # @param asset [Asset] the asset that changed
  # @param attribute_name [String] name of the changed attribute
  # @param value [Object] new attribute value
  # @return [void]
  def self.trigger_attribute_change_rules(asset, attribute_name, value)
    # Find rules that react to attribute changes
    rules = Rule.where(enabled: true)
                .where("when_config->>'condition' = ?", "Asset attribute value changed")
                .where("when_config->>'attribute' = ?", attribute_name)

    rules.find_each do |rule|
      # Check if rule should be triggered for this asset
      if rule_should_trigger?(rule, asset, attribute_name, value)
        RuleExecutionJob.perform_later(rule)
      end
    end
  end

  ##
  # Check if a rule should be triggered for an attribute change.
  #
  # @param rule [Rule] the rule to check
  # @param asset [Asset] the asset that changed
  # @param attribute_name [String] name of the changed attribute
  # @param value [Object] new attribute value
  # @return [Boolean] true if rule should be triggered
  def self.rule_should_trigger?(rule, asset, attribute_name, value)
    # Check if asset matches rule's target criteria
    # For now, we trigger for all assets - more sophisticated filtering can be added
    true
  end

  ##
  # Process outdated attributes and mark them as stale.
  #
  # Attributes that haven't been updated within a threshold are considered outdated.
  #
  # @param threshold [ActiveSupport::Duration] time threshold (default: 1.hour)
  # @return [Hash<String, Array<Asset>>] hash of attribute names to arrays of assets with outdated values
  def self.process_outdated_attributes(threshold: 1.hour)
    cutoff_time = Time.current - threshold
    outdated = {}

    # Get latest data points for each asset/attribute combination
    # Only include those where the latest data point is older than the threshold
    # Eager load assets to prevent N+1 queries
    latest_datapoints = DataPoint.select("DISTINCT ON (asset_id, attribute_name) *")
                                  .order(:asset_id, :attribute_name, timestamp: :desc)
                                  .includes(:asset)

    # Group by attribute and filter by cutoff time
    latest_datapoints.group_by(&:attribute_name).each do |attribute_name, data_points|
      outdated_assets = data_points.select { |dp| dp.timestamp < cutoff_time }
                                   .map(&:asset)
                                   .uniq

      outdated[attribute_name] = outdated_assets if outdated_assets.any?
    end

    outdated
  end
end
