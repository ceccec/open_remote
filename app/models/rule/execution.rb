##
# Runtime behavior for executing a `Rule` against the asset graph.
#
# This module encapsulates all decision logic, side effects (notifications,
# attribute updates, logging), and execution bookkeeping.
module Rule::Execution
  extend ActiveSupport::Concern
  extend ConcernFeatures

  # Concern features - enables Rule interaction with Asset, Notification, RuleExecution
  concern_feature :provides, :execute!, :condition_met?, :perform_actions!
  enables_interaction :rule_execution, [ :Rule, :Asset ], "Enables Rule to execute against Asset conditions"
  enables_interaction :notification_triggering, [ :Rule, :Notification ], "Enables Rule to trigger Notifications"
  enables_interaction :execution_tracking, [ :Rule, :RuleExecution ], "Enables Rule to track execution history"

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

  private

  ##
  # Get target assets relation and validate that targets exist.
  #
  # This is a DRY helper method used by rule handlers to avoid duplication
  # of the "get targets, check exists" pattern.
  #
  # @return [ActiveRecord::Relation<Asset>, nil] target assets relation, or nil if no targets exist
  def validated_target_assets
      assets_relation = target_assets
      return nil unless assets_relation.exists?

      assets_relation
  end

  ##
  # Execute all configured actions without any asset filtering.
  #
  # @return [void]
  def handle_scheduled_rule
      assets_relation = validated_target_assets
      # For scheduled rules, allow execution even with no targets
      # Actions that require assets will simply have empty arrays
      assets = assets_relation ? assets_relation.to_a : []

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
      assets_relation = validated_target_assets
      return log_execution("skipped", reason: "no_targets") unless assets_relation

      if condition_met?(assets_relation)
        perform_actions!(assets_relation.to_a)
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
      assets_relation = validated_target_assets
      return log_execution("skipped", reason: "no_targets") unless assets_relation

      perform_actions!(assets_relation.to_a)
      log_execution("success")
  end

  ##
  # Determine whether the rule's attribute-value condition is met for
  # any of the candidate assets.
  #
  # Uses Asset scopes (aligned with RailsAdmin search options) to build queries.
  #
  # @param assets [ActiveRecord::Relation<Asset>] candidate assets relation
  # @return [Boolean] true when at least one asset satisfies the comparison
  def condition_met?(assets)
      return true unless attribute_value_condition?

      operator = when_config["operator"]
      threshold = when_config["value"]
      # Support both "attribute" and "attributeName" keys
      attribute_name = when_config["attribute"] || when_config["attributeName"]

      # Build query using Asset scopes (aligned with RailsAdmin search options)
      relation = build_asset_query(assets)

      # Check if any asset matches the condition
      # Note: JSONB attribute comparison requires loading records
      relation.any? do |asset|
        value = (asset.attributes_data || {})[attribute_name]
        compare_values(value, operator, threshold)
      end
  end

  ##
  # Select target assets for the current rule execution.
  #
  # Uses Asset scopes and ActiveRecord queries (aligned with RailsAdmin search options)
  # to determine which assets should be considered for rule execution.
  #
  # Supports filtering by:
  # - assetId: specific asset ID
  # - assetType: asset type name (uses Asset.of_type scope)
  #
  # @return [ActiveRecord::Relation<Asset>] candidate assets relation
  def target_assets
      apply_asset_filters(Asset.all)
  end

  ##
  # Build asset query from rule configuration and provided assets.
  #
  # Combines provided assets relation with rule-specific filters using Asset scopes.
  #
  # @param assets [ActiveRecord::Relation<Asset>, Array<Asset>] base assets relation or array
  # @return [ActiveRecord::Relation<Asset>] filtered assets relation
  def build_asset_query(assets)
      relation = assets.is_a?(ActiveRecord::Relation) ? assets : Asset.where(id: assets.map(&:id))
      apply_asset_filters(relation)
  end

  ##
  # Apply rule configuration filters to an asset relation.
  #
  # Uses Asset scopes (aligned with RailsAdmin search options) to filter assets.
  #
  # @param relation [ActiveRecord::Relation<Asset>] base assets relation
  # @return [ActiveRecord::Relation<Asset>] filtered assets relation
  def apply_asset_filters(relation)
      return relation unless when_config

      # Apply assetId filter if specified (uses where scope like RailsAdmin)
      if when_config["assetId"]
        relation = relation.where(id: when_config["assetId"])
      end

      # Apply assetType filter if specified (uses of_type scope from Assets::Querying)
      type_name = when_config["assetType"] || when_config["asset_type"]
      if type_name
        relation = relation.of_type(type_name)
      end

      relation
  end

  ##
  # Compare a raw attribute value to the configured threshold.
  #
  # @param value [Object] raw attribute value
  # @param operator [String] comparison operator (`"less than"`, `"greater than"`, `"equals"`, `"<"`, `">"`, etc.)
  # @param threshold [Object] threshold value from configuration
  # @return [Boolean] result of the comparison
  def compare_values(value, operator, threshold)
      # Handle nil values - return false for all comparisons
      return false if value.nil?

      case operator.to_s.downcase
      when "less than", "<", "lt"
        value.to_f < threshold.to_f
      when "greater than", ">", "gt"
        value.to_f > threshold.to_f
      when "equals", "=", "==", "eq"
        value == threshold
      else
        false
      end
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
  # @param assets [Array<Asset>] assets to operate on
  # @return [void]
  def apply_action!(action, assets = [])
      case action["action"]
      when "Calculate performance ratio"
        # Use Asset scope instead of in-memory filtering
        Asset.where(id: assets.map(&:id)).solar_parks.each(&:update_performance_ratio!)
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
      create_notifications_for_assets(assets, message_template, severity)
  end

  ##
  # Log a low-severity informational notification for each asset.
  #
  # @param action [Hash] includes optional `"message"` key
  # @param assets [Enumerable<Asset>] assets to attach to the log entry
  # @return [void]
  def log_event_action(action, assets)
      message_template = action["message"] || "Event logged"
      create_notifications_for_assets(assets, message_template, "info")
  end

  ##
  # Create notifications for multiple assets with a shared message template and severity.
  #
  # This is a DRY helper method used by send_notification_action, log_event_action,
  # and compare_assets_for_deviation to avoid duplication.
  #
  # @param assets [Enumerable<Asset>] assets to create notifications for
  # @param message_template [String] message template with interpolation placeholders
  # @param severity [String] notification severity (e.g., "info", "warning", "error")
  # @return [void]
  def create_notifications_for_assets(assets, message_template, severity)
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
          create_notifications_for_assets(
            [ asset ],
            message_template || "Performance deviation detected",
            "warning"
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
