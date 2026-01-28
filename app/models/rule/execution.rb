##
# Runtime behavior for executing a `Rule` against the asset graph.
#
# This module encapsulates all decision logic, side effects (notifications,
# attribute updates, logging), and execution bookkeeping.
module Rule::Execution
  extend ActiveSupport::Concern

  ##
  # Execute the rule once, recording a `RuleExecution` row.
  #
  # Disabled rules are recorded as `"skipped"` with a `"disabled"` reason.
  # For unknown condition types, the rule is skipped with
  # `"unknown_condition_type"`.
  #
  # @raise [StandardError] re-raises any error after logging a failed execution
  # @return [void]
  def execute!
      return log_execution("skipped", reason: "disabled") unless enabled?

      if schedule_condition?
        handle_scheduled_rule
      elsif attribute_value_condition?
        handle_attribute_value_rule
      elsif attribute_changed_condition?
        handle_attribute_changed_rule
      else
        log_execution("skipped", reason: "unknown_condition_type")
      end
    rescue StandardError => e
      log_execution("failed", error: e.message, backtrace: e.backtrace&.first(5))
      raise
  end

  private

  ##
  # @return [Boolean] true when the rule is configured as a schedule-based rule
  def schedule_condition?
      when_config && when_config["condition"] == "Schedule"
  end

  ##
  # @return [Boolean] true when the rule compares an asset attribute to a value
  def attribute_value_condition?
      when_config && when_config["condition"] == "Asset attribute value"
  end

  ##
  # @return [Boolean] true when the rule reacts to attribute changes
  def attribute_changed_condition?
      when_config && when_config["condition"] == "Asset attribute value changed"
  end

  ##
  # Execute all configured actions without any asset filtering.
  #
  # @return [void]
  def handle_scheduled_rule
      assets = target_assets.to_a
      Array(then_config).each do |action|
        apply_action!(action, assets)
      end
      log_execution("success")
  end

  ##
  # Execute a rule that depends on an attribute comparison across assets.
  #
  # @return [void]
  def handle_attribute_value_rule
      assets = target_assets
      return log_execution("skipped", reason: "no_targets") if assets.empty?

      if condition_met?(assets)
        perform_actions!(assets)
        log_execution("success")
      else
        log_execution("skipped", reason: "condition_not_met")
      end
  end

  ##
  # Execute a rule that should always run when attributes change.
  #
  # @return [void]
  def handle_attribute_changed_rule
      assets = target_assets
      return log_execution("skipped", reason: "no_targets") if assets.empty?

      perform_actions!(assets)
      log_execution("success")
  end

  ##
  # Determine whether the rule's attribute-value condition is met for
  # any of the candidate assets.
  #
  # @param assets [Enumerable<Asset>] candidate assets
  # @return [Boolean] true when at least one asset satisfies the comparison
  def condition_met?(assets)
      return true unless attribute_value_condition?

      operator = when_config["operator"]
      threshold = when_config["value"]
      attribute_name = when_config["attribute"]

      assets.any? do |asset|
        value = (asset.attributes_data || {})[attribute_name]
        compare_values(value, operator, threshold)
      end
  end

  ##
  # Compare a raw attribute value to the configured threshold.
  #
  # @param value [Object] raw attribute value
  # @param operator [String] comparison operator (`"less than"`, `"greater than"`, `"equals"`)
  # @param threshold [Object] threshold value from configuration
  # @return [Boolean] result of the comparison
  def compare_values(value, operator, threshold)
      # Handle nil values - return false for all comparisons
      return false if value.nil?

      case operator
      when "less than"
        value.to_f < threshold.to_f
      when "greater than"
        value.to_f > threshold.to_f
      when "equals"
        value == threshold
      else
        false
      end
  end

  ##
  # Select target assets for the current rule execution.
  #
  # NOTE: In this initial implementation we consider all assets as candidates;
  # rule-specific filtering is expressed in `condition_met?` and actions.
  #
  # @return [ActiveRecord::Relation<Asset>] candidate assets
  def target_assets
      Asset.all
  end

  ##
  # Apply all configured actions to the given assets.
  #
  # @param assets [Enumerable<Asset>] assets to operate on
  # @return [void]
  def perform_actions!(assets)
      Array(then_config).each do |action|
        apply_action!(action, assets)
      end
  end

  ##
  # Dispatch a single action hash to the appropriate handler.
  #
  # @param action [Hash] action configuration from `then_config`
  # @param assets [Enumerable<Asset>] assets to operate on
  # @return [void]
  def apply_action!(action, assets = [])
      case action["action"]
      when "Calculate performance ratio"
        assets.select { |a| a.asset_type.name == "SolarPark" }.each(&:update_performance_ratio!)
      when "Update attribute"
        update_attribute_action(action, assets)
      when "Send notification"
        send_notification_action(action, assets)
      when "Log event"
        log_event_action(action, assets)
      when "Compare assets"
        compare_assets_for_deviation(action)
      when "Trigger forecast recalculation"
        Rails.logger.info "Forecast recalculation triggered for rule #{id}"
      when "Evaluate grid export strategy"
        Rails.logger.info "Grid export strategy evaluated for rule #{id}"
      end
  end

  ##
  # Update a single attribute on all target assets.
  #
  # @param action [Hash] includes `"attribute"` and `"value"` keys
  # @param assets [Enumerable<Asset>] assets to update
  # @return [void]
  def update_attribute_action(action, assets)
      attr_name = action["attribute"]
      value = action["value"]

      assets.each do |asset|
        asset.attributes_data ||= {}
        asset.attributes_data = asset.attributes_data.merge(attr_name => value)
        asset.save!
      end
  end

  ##
  # Create a `Notification` for each asset, using an optional message template.
  #
  # @param action [Hash] includes `"message"` and `"severity"` keys
  # @param assets [Enumerable<Asset>] assets to notify about
  # @return [void]
  def send_notification_action(action, assets)
      message_template = action["message"] || "Notification triggered"
      severity = action["severity"] || "info"

      assets.each do |asset|
        Notification.create!(
          asset: asset,
          rule: self,
          severity: severity,
          message: interpolate_message(message_template, asset),
          sent_at: Time.current
        )
      end
  end

  ##
  # Log a low-severity informational notification for each asset.
  #
  # @param action [Hash] includes optional `"message"` key
  # @param assets [Enumerable<Asset>] assets to attach to the log entry
  # @return [void]
  def log_event_action(action, assets)
      message_template = action["message"] || "Event logged"

      assets.each do |asset|
        Notification.create!(
          asset: asset,
          rule: self,
          severity: "info",
          message: interpolate_message(message_template, asset),
          sent_at: Time.current
        )
      end
  end

  ##
  # Compare assets of a given type for deviations in an attribute and
  # optionally emit notifications when a threshold is exceeded.
  #
  # @param action [Hash] configuration for asset type, attribute, threshold and message
  # @return [void]
  def compare_assets_for_deviation(action)
      type_name = action["assetType"] || action["asset_type"]
      attr_name = action["attribute"]
      threshold = action["threshold"].to_f
      message_template = action["message"]
      action_on_dev = action["actionOnDeviation"] || "Send notification"

      return unless type_name && attr_name

      pairs = Asset.of_type(type_name).map do |asset|
        value = (asset.attributes_data || {})[attr_name]
        [ asset.id, value.to_f ] if value
      end.compact

      return if pairs.size < 2

      avg = pairs.map { |(_, v)| v }.sum / pairs.size.to_f
      return if avg.zero?

      pairs.each do |asset_id, value|
        deviation = ((value - avg).abs / avg.to_f)
        next unless deviation > threshold

        asset = Asset.find(asset_id)
        if action_on_dev == "Send notification"
          Notification.create!(
            asset: asset,
            rule: self,
            severity: "warning",
            message: interpolate_message(message_template || "Performance deviation detected", asset),
            sent_at: Time.current
          )
        end
      end
  end

  ##
  # Interpolate `${attributeName}` and `${assetName}` placeholders in a
  # message template using data from an asset.
  #
  # @param template [String] raw message template
  # @param asset [Asset] asset providing attribute data and name
  # @return [String] interpolated message
  def interpolate_message(template, asset)
      return template unless template.is_a?(String)

      # First replace ${assetName} with the asset's name
      result = template.gsub(/\$\{assetName\}/, asset.name)

      # Then replace other ${attributeName} placeholders with attribute values
      result.gsub(/\$\{(\w+)\}/) do |match|
        attr_name = Regexp.last_match(1)
        # Skip assetName since we already handled it
        next match if attr_name == "assetName"

        (asset.attributes_data || {})[attr_name] || match
      end
  end

  ##
  # Persist a `RuleExecution` row capturing the outcome of this run.
  #
  # @param status [String] outcome label (`"success"`, `"skipped"`, `"failed"`, ...)
  # @param extras [Hash] optional structured metadata about the execution
  # @return [RuleExecution] the created execution record
  def log_execution(status, extras = {})
    rule_executions.create!(
        executed_at: Time.current,
        status: status,
        result: extras.presence || {}
    )
  end
end
